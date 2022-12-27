//
//  UIComponents.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 26/12/22.
//

import SwiftUI

struct Corners: Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: 20, height: 20))
        
        return Path(path.cgPath)
    }
}

struct RoundedRectangleButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      Spacer()
      configuration.label.foregroundColor(.black)
      Spacer()
    }
    .padding()
    .background(Color("principal").cornerRadius(8))
    .scaleEffect(configuration.isPressed ? 0.95 : 1)
  }
}
