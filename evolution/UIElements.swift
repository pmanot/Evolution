//
//  UIElements.swift
//  evolution
//
//  Created by Purav Manot on 20/10/20.
//

import SwiftUI

struct UIElements: View {
    var body: some View {
        GeometryReader { screen in
            ZStack {
                VStack {
                    Button(action:{}){
                        Text("someText")
                            .frame(alignment: .leading)
                    }
                }
                .frame(width: screen.size.width, height: screen.size.height)
            }
        }
    }
}

struct UIElements_Previews: PreviewProvider {
    static var previews: some View {
        UIElements()
    }
}

struct FunctionalButton: ButtonStyle {
    var cornerRadius: CGFloat
    init(_ corner: CGFloat = 8) {
        cornerRadius = corner
    }
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: 0.5).foregroundColor(.lightBlueGray))
            .background((configuration.isPressed ? Color.lightBlueGreen : Color.blueGreen) .clipShape(RoundedRectangle(cornerRadius: cornerRadius)))
            .animation(.easeOut(duration: 0.3))
            .opacity(configuration.isPressed ? 0.8 : 1 )
    }
}
