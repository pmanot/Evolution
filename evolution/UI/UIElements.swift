//
//  UIElements.swift
//  evolution
//
//  Created by Purav Manot on 20/10/20.
//

import SwiftUI

struct UIElements: View {
    var body: some View {
        VStack {
            Button(action: {}) {
                ZStack {
                    Text("Test")
                    Circle()
                        .stroke(lineWidth: 4)
                        .frame(width: 70, height: 70)
                }
            }
            .buttonStyle(FloatingButtonStyle())
        }
    }
}

struct UIElements_Previews: PreviewProvider {
    static var previews: some View {
        UIElements()
    }
}

struct FunctionalButtonStyle: ButtonStyle {
    var cornerRadius: CGFloat
    init(_ corner: CGFloat = 8) {
        cornerRadius = corner
    }
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: 0.5).foregroundColor(.lightBlueGray))
            .background(
                Color.lavender
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            )
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.easeOut(duration: 0.2))
    }
}

struct FloatingButtonStyle: ButtonStyle {
    var colors: [Color]
    init(_ defaultColor: Color = .black, _ pressedColor: Color = .gray) {
        colors = [defaultColor, pressedColor]
    }
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .shadow(radius: configuration.isPressed ? 1 : 2, x: !configuration.isPressed ? 6.4 : 0.8, y: !configuration.isPressed ? 8 : 1)
            .offset(x: configuration.isPressed ? 6.4 : 0.6, y: configuration.isPressed ? 8 : 1)
            .animation(.easeOut(duration: 0.5))
            .foregroundColor(configuration.isPressed ? colors[1] : colors[0])
    }
}

struct Bright: ViewModifier {
    var amount: Double
    init(_ amount: Double = 0.3) {
        self.amount = amount
    }
    func body(content: Content) -> some View {
        content
            .brightness(amount)
            .opacity(1 - amount)
    }
}

extension AnyTransition {
    static var bright: AnyTransition {
        .modifier(active: Bright(0.6), identity: Bright(0))
    }
}
