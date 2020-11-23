//
//  EnvironmentView.swift
//  evolution
//
//  Created by Purav Manot on 17/10/20.
//

import SwiftUI

struct EnvironmentView: View {
    @EnvironmentObject var env: SpeciesEnvironment
    var body: some View {
        ZStack {
            FoodView()
                .environmentObject(env)
        }
    }
}

struct EnvironmentView_Previews: PreviewProvider {
    static var previews: some View {
        EnvironmentView()
            .environmentObject(SpeciesEnvironment())
    }
}

struct FoodView: View {
    @EnvironmentObject var env: SpeciesEnvironment
    var body: some View {
        ZStack {
            ForEach(env.food, id: \.id) { food in
                SingleFoodMolecule(food)
                    .environmentObject(env)
                    .animation(.easeIn(duration: 0.3))
                    .transition(.bright)
            }
        }
    }
}

struct SingleFoodMolecule: View {
    var food: Food
    init(_ food: Food) {
        self.food = food
    }
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 5, height: 5)
                .foregroundColor(food.color)
            Circle()
                .strokeBorder(Color.darkblueGray)
                .frame(width: 6, height: 6)
        }
        .position(food.position.cg())
    }
}
