//
//  MyInfoApp.swift
//  MyInfo
//
//  Created by Yamio on 15.09.2022.
//

import SwiftUI

@main
struct MyInfoApp: App {
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
