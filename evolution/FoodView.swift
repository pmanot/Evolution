//
//  FoodView.swift
//  evolution
//
//  Created by Purav Manot on 16/10/20.
//

import SwiftUI

struct FoodView: View {
    @EnvironmentObject var env: Environment
    var body: some View {
        ZStack {
            ForEach(env.food, id: \.id) { n in
                Rectangle()
                    .frame(width: 5, height: 5)
                    .foregroundColor(n.color)
                    .opacity(0.9)
                    .position(n.position.cg())
                    .animation(.easeIn)
            }
        }
    }
}

struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        FoodView()
            .environmentObject(Environment())
    }
}
