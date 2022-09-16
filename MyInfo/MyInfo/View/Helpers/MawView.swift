//
//  MawView.swift
//  MyInfo
//
//  Created by Yamio on 15.09.2022.
//

import SwiftUI
import MapKit


struct MawView: View {
    var coordinate: CLLocationCoordinate2D
    @State private var region = MKCoordinateRegion()
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
    
    var body: some View {
        Map(coordinateRegion: $region)
            .onAppear {
                setRegion(coordinate)
            }
    }
}

struct MawView_Previews: PreviewProvider {
    static var previews: some View {
        MawView(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
    }
}
