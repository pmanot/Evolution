//
//  SpeciesInfoView.swift
//  evolution
//
//  Created by Purav Manot on 30/11/20.
//

import SwiftUI

struct SpeciesInfoView: View {
    @EnvironmentObject var env: SpeciesEnvironment
    @Environment(\.colorScheme) var colorScheme
    var some_species: Species
    var size: CGSize
    init(_ species: Species) {
        some_species = species
        self.size = CGSize(width: CGFloat(species.genome.size/2 + 20), height: CGFloat(species.genome.size/2 + 20))
    }
    var body: some View {
        ZStack {
            Group {
                Circle()
                    .strokeBorder(lineWidth: 2)
                Circle()
                    .opacity(0.2)
            }
            .foregroundColor(.black)
            .frame(width: size.width*1.1, height: size.height*1.1)
            .transition(AnyTransition.opacity.animation(.linear(duration: 0.1)))
            
            VStack(spacing: 0) {
                ZStack {
                    Group {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(lineWidth: 2, antialiased: true)
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(colorScheme == .light ? Color.gray : Color.black)
                            .opacity(0.9)
                    }
                    .frame(width: 120, height: 100)
                    .foregroundColor(.black)
                    .shadow(radius: 3, x: -2, y: 2)
                    
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 0) {
                                Group {
                                    HStack(spacing: 0.5) {
                                        Text("\(env.baseDNA[0].identifier): ")
                                            .font(.caption2)
                                        Text(String(Int(some_species.genome.percentageComposition[env.baseDNA[0].identifier]!*100)))
                                            .font(.caption)
                                            .fontWeight(.bold)
                                        Text("%")
                                            .font(.caption2)
                                    }
                                    HStack(spacing: 0.5) {
                                        Text("\(env.baseDNA[1].identifier): ")
                                            .font(.caption2)
                                        Text(String(Int(some_species.genome.percentageComposition[env.baseDNA[1].identifier]!*100)))
                                            .font(.caption)
                                            .fontWeight(.bold)
                                        Text("%")
                                            .font(.caption2)
                                    }
                                }
                            }
                            ZStack {
                                Circle()
                                    .stroke(lineWidth: 5)
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(env.baseDNA[1].color)
                                Arc(startAngle: .degrees((some_species.genome.percentageComposition[env.baseDNA[1].identifier]!.mappedValue(inputRange: 0..<1, outputRange: 0..<360))), endAngle: .degrees(360), clockwise: true)
                                    .stroke(lineWidth: 5)
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(env.baseDNA[0].color)
                            }
                        }
                        .padding(2)
                        VStack(alignment: .leading) {
                            HStack(spacing: 0.5) {
                                Text("Food eaten: ")
                                    .font(.caption2)
                                Text(String(some_species.foodEnergy.count))
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            HStack(spacing: 0.5) {
                                Text("Lifespan: ")
                                    .font(.caption2)
                                Text(String(Int(some_species.lifespan*100/some_species.maxLifespan)))
                                    .font(.caption)
                                    .fontWeight(.bold)
                                Text("%")
                                    .font(.caption2)
                            }
                        }
                        .padding(2)
                    }
                }
                .opacity(0.8)
                .offset(x: some_species.coordinates.x <= (env.bounds.left + 50) ? 50 : (some_species.coordinates.x >= (env.bounds.right - 50) ? -50 : 0) )
                Image(systemName: "arrowtriangle.down.fill")
                    .resizable()
                    .frame(width: 10, height: 5)
                    .shadow(radius: 3, x: -2, y: 2)
            }
            .offset(y: -65)
            .transition(AnyTransition.offset(y: -20).combined(with: AnyTransition.scale(scale: 0.4)).combined(with: AnyTransition.opacity))
        }
    }
}


