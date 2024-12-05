//
//  MenuButton.swift
//  goodzik-ios
//
//  Created by Yehor Myropoltsev on 05.12.2024.
//

import SwiftUI

struct MenuButton: View {
   let title: String
   let image: ImageResource
   let tint: Color
   let action: () -> Void
   
   var body: some View {
       Button(action: action) {
           HStack {
               Image(image)
                   .frame(width: 24, height: 24)
                   .foregroundStyle(tint)
               
               Text(title)
                   .tint(tint)
                   .font(.system(size: 16, weight: .semibold))
                   .frame(maxWidth: .infinity, alignment: .leading)
           }
       }
   }
}
