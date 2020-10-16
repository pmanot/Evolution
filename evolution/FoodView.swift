//
//  FoodView.swift
//  evolution
//
//  Created by Purav Manot on 16/10/20.
//

import SwiftUI

struct FoodView: View {
    var food: [Food]
    @EnvironmentObject var env: Environment
    init(_ food: [Food]) {
        self.food = food
    }
    var body: some View {
        ZStack {
            ForEach(food, id: \.id) { n in
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
        FoodView(genFood(min: 20, max: 40))
            .environmentObject(Environment())
    }
}
