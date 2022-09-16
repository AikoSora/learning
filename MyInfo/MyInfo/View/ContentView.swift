//
//  ContentView.swift
//  MyInfo
//
//  Created by Yamio on 15.09.2022.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        LandmarksList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
    }
}
