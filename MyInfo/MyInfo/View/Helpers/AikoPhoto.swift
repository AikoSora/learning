//
//  AikoPhoto.swift
//  MyInfo
//
//  Created by Yamio on 15.09.2022.
//

import SwiftUI

struct AikoPhoto: View {
    var image: Image
    
    var body: some View {
        image
            .clipShape(Circle()) // Обрезка кругом
            .overlay(
                Circle()
                    .stroke(.white, lineWidth: 4) // Белая обводка
                    
            )
            .shadow(radius: 7) // Тень
    }
}

struct AikoPhoto_Previews: PreviewProvider {
    static var previews: some View {
        AikoPhoto(image: Image("twinlake"))
    }
}
