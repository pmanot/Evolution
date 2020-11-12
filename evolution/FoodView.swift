//
//  FoodView.swift
//  evolution
//
//  Created by Purav Manot on 16/10/20.
//

import SwiftUI

struct FoodView: View {
    @EnvironmentObject var env: SpeciesEnvironment
    var body: some View {
        ZStack {
            ForEach(env.food, id: \.id) { food in
                SingleFoodMolecule(food)
            }
        }
    }
}

struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        FoodView()
            .environmentObject(SpeciesEnvironment())
    }
}


struct SingleFoodMolecule: View {
    var food: Food
    init(_ food: Food) {
        self.food = food
    }
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 5, height: 5)
                .foregroundColor(food.color)
                .opacity(0.9)
                .position(food.position.cg())
                .animation(.easeIn)
        }
    }
}
