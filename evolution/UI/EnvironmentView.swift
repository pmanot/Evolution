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
            Image(systemName: "circle.circle.fill")
                .resizable()
                .frame(width: 5, height: 5)
                .foregroundColor(.black)
                .opacity(0.7)
        }
        .position(food.position.cg())
    }
}
