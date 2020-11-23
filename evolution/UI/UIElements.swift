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
                
            }
            .buttonStyle(FunctionalButton())
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
            .background(
                Color.lavender
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            )
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.easeOut(duration: 0.2))
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
