//
//  UIComponents.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 26/12/22.
//

import SwiftUI
import SDWebImageSwiftUI

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

struct iconView: View {
    var url: URL?
    var name: String?
    var body: some View {
        VStack {
            WebImage(url: url)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: 80, height: 80)
            Text(name ?? "")
                .foregroundColor(Color.white)
                .font(.system(size: 14))
                .padding(.top, 4)
        }
        .frame(width: 120, height: 120)
    }
}
