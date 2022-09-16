//
//  LandmarkDetail.swift
//  MyInfo
//
//  Created by Yamio on 15.09.2022.
//

import SwiftUI

struct LandmarkDetail: View {
    @EnvironmentObject var modelData: ModelData
    var landmark: Landmark
    
    var landmarksIndex: Int {
        modelData.landmarks.firstIndex(where: { $0.id == landmark.id})!
    }
    
    var body: some View {
        ScrollView {
            MawView(coordinate: landmark.locationCoordinate).frame(height: 300)
                .ignoresSafeArea(edges: .top)

            AikoPhoto(image: landmark.image)
                .offset(y: -130)
                .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(landmark.name)
                        .font(.title)
                    FavoriteButton(isSet: $modelData.landmarks[landmarksIndex].isFavorite)
                }
                
                HStack {
                    Text(landmark.park)
                    Spacer()
                    Text(landmark.state)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Divider() // Разделитель
                
                Text("About \(landmark.name)")
                    .font(.title2)
                Text(landmark.description)
            }
            .padding()
        }
        .navigationTitle(landmark.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static let modelData = ModelData()
    
    static var previews: some View {
        LandmarkDetail(landmark: ModelData().landmarks[0])
            .environmentObject(modelData)
    }
}
