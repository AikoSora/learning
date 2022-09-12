#!/usr/bin/swift -frontend -interpret -enable-source-import -I.
//
//  main.swift
//  LiveWallpapers
//
//  Created by Aiko on 11.06.2022.
//

import Foundation
import AppKit

let greenColor = "\u{001B}[0;32m"
let returnColor = "\u{001B}[0;0m"
let fileManager = FileManager()

var array = URL(fileURLWithPath: #file).pathComponents
array.remove(at: array.count-1)
let workDir = String(array.joined(separator: "/").dropFirst() + "/")
let scriptArguments = CommandLine.arguments
var frameRate = 1


@discardableResult
func shell(_ args: String...) -> Int32 {
   let task = Process()
   task.launchPath = "/usr/bin/env"
   task.arguments = args

   do {
       try task.run()
       task.waitUntilExit()
   } catch {
       print(error)
   }

   return task.terminationStatus
}


@discardableResult
func shellOutput(_ args: String...) -> String {
   let task = Process()
   let pipe = Pipe()
   task.launchPath = "/usr/bin/env"
   task.arguments = args
   task.standardOutput = pipe

   do {
       try task.run()
   } catch {
       print(error)
   }

   let data = pipe.fileHandleForReading.readDataToEndOfFile()
   let output = String(data: data, encoding: .utf8)

   return output!
}


func checkFilesInTemp() -> Bool {
   do {
       var tempFileExist = false

       for x in try fileManager.contentsOfDirectory(atPath: workDir) {
           if x == "temp" {
               tempFileExist = !tempFileExist
               break
           }
       }

       if tempFileExist {
           let regex = try! NSRegularExpression(pattern: #".*\.jpg"#)

           for x in try fileManager.contentsOfDirectory(atPath: workDir + "temp") {
               if regex.firstMatch(in: x, range: NSRange(location: 0, length: x.utf16.count)) != nil {
                   return true
               }
           }
       } else {
           try fileManager.createDirectory(atPath: "\(workDir)/temp", withIntermediateDirectories: true, attributes: nil)
       }

   } catch {
       print(error)
       return true
   }

   return false
}


func splitToFrames() {
   var isMediaInArg = false

   if scriptArguments.count > 1 {
       let regex = try! NSRegularExpression(pattern: #"/(.*)\.mp4"#)
       if regex.firstMatch(in: scriptArguments[1], range: NSRange(location: 0, length: scriptArguments[1].utf16.count)) != nil {
           isMediaInArg = !isMediaInArg
       }
   }

   if isMediaInArg {
       shell("ffmpeg", "-loglevel", "quiet", "-nostdin", "-i", "\(scriptArguments[1])", "\(workDir)temp/%d.jpg")
       let textOutput = shellOutput("ffprobe", "-v", "error", "-hide_banner", "-select_streams", "v:0", "-show_streams", "\(scriptArguments[1])")
       let regex = try! NSRegularExpression(pattern: #"r_frame_rate=(.*)\n"#)
       if regex.firstMatch(in: textOutput, range: NSRange(location: 0, length: textOutput.utf16.count)) != nil {
           let regexpMatches = regex.firstMatch(in: textOutput, range: NSRange(location: 0, length: textOutput.utf16.count))
           let result = regexpMatches.map{String(textOutput[Range($0.range, in: textOutput)!])}
           frameRate = Int(result!.split(separator: "=")[1].split(separator: "/")[0]) ?? 60
       }
   }
}


func setVideoWallpaper() {
   do {
       var running = true
       let workspace = NSWorkspace.shared
       let framesCount = try fileManager.contentsOfDirectory(atPath: workDir + "temp").sorted(by: { $0 > $1 }).count
       if framesCount == 0 {
           running = !running
       }
       while (running) {
           for x in 1...framesCount {
               if let screen = NSScreen.main {
                   let imageUrl = NSURL.fileURL(withPath: workDir + "temp/\(x).jpg")
                   try workspace.setDesktopImageURL(imageUrl, for: screen, options: [NSWorkspace.DesktopImageOptionKey.imageScaling : 0])
               }
               Thread.sleep(forTimeInterval: 1.00 / Double(frameRate) - 0.0052)
           }
       }
   } catch {
       print(error)
   }
}


func clearTemp() {
   do {
       let files = try fileManager.contentsOfDirectory(atPath: workDir + "temp").sorted(by: { $0 > $1 })
       for file in files {
           try fileManager.removeItem(atPath: workDir + "temp/" + file)
       }
   } catch {
       print(error)
   }
}


shell("clear")
clearTemp()
print(greenColor + #"""

   __    _          _       __      ____
  / /   (_)   _____| |     / /___ _/ / /___  ____ _____  ___  __________
 / /   / / | / / _ \ | /| / / __ `/ / / __ \/ __ `/ __ \/ _ \/ ___/ ___/
/ /___/ /| |/ /  __/ |/ |/ / /_/ / / / /_/ / /_/ / /_/ /  __/ /  (__  )
/_____/_/ |___/\___/|__/|__/\__,_/_/_/ .___/\__,_/ .___/\___/_/  /____/
                                   /_/         /_/

Created by Aiko - https://github.com/AikoSora
"""# + returnColor)

if !checkFilesInTemp() {
   print(greenColor + "[LiveWallpapers]: Createing frames" + returnColor)
   splitToFrames()
   print(greenColor + "[LiveWallpapers]: Start video file" + returnColor)
   setVideoWallpaper()
} else {
   print(greenColor + "[LiveWallpapers]: Createing frames" + returnColor)
   splitToFrames()
   print(greenColor + "[LiveWallpapers]: Start video file" + returnColor)
   setVideoWallpaper()
}
