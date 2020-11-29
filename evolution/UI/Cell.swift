//
//  Cell.swift
//  evolution
//
//  Created by Purav Manot on 13/10/20.
//

import SwiftUI

struct Cell: View {
    var some_species: Species
    @EnvironmentObject var env: SpeciesEnvironment
    @Environment(\.colorScheme) var colorScheme
    @State private var showInfo: Bool = false
    var size: CGSize
    init(_ species: Species, size: CGSize = CGSize(width: 20, height: 20)) {
        some_species = species
        self.size = CGSize(width: CGFloat(species.size/2 + 20), height: CGFloat(species.size/2 + 20))
    }
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Color.black)
                .frame(width: some_species.foodEnergy.count >= 1 ? size.width*1.2 : size.width, height: some_species.foodEnergy.count >= 1 ? size.width*1.2 : size.width)
            Circle()
                .strokeBorder(Color.black, lineWidth: 2, antialiased: true)
                .clipShape(Circle())
                .frame(width: some_species.foodEnergy.count >= 1 ? size.width*1.2 : size.width, height: some_species.foodEnergy.count >= 1 ? size.width*1.2 : size.width)
            Circle()
                .foregroundColor(some_species.color)
                .opacity(0.2)
                .frame(width: some_species.foodEnergy.count >= 1 ? size.width*1.2 : size.width, height: some_species.foodEnergy.count >= 1 ? size.width*1.2 : size.width)
            LinearGradient(gradient: Gradient(colors: [some_species.color.darken(0.1), some_species.color.darken(0.2), some_species.color.darken(0.4), some_species.color.darken(0.6), some_species.color.darken(0.8)].reversed()), startPoint: .leading, endPoint: .trailing)
                .clipShape(Arc(startAngle: .degrees(0), endAngle: angle(Int(some_species.lifespan), max: Int(some_species.maxLifespan)), clockwise: true).stroke(lineWidth: 2))
                .frame(width: some_species.foodEnergy.count >= 1 ? size.width : size.width*0.8, height: some_species.foodEnergy.count >= 1 ? size.width : size.width*0.8)
            LinearGradient(gradient: Gradient(colors: [some_species.color.lighten(0.7), some_species.color.lighten(0.6), some_species.color.lighten(0.9)]), startPoint: .leading, endPoint: .trailing)
                .clipShape(Circle())
                .overlay(Circle().strokeBorder(lineWidth: 0.5, antialiased: true).foregroundColor(.black))
                .frame(width: 8, height: 8)
            if showInfo {
                Group {
                    Circle()
                        .strokeBorder(lineWidth: 2)
                    Circle()
                        .opacity(0.2)
                }
                .foregroundColor(.black)
                .frame(width: some_species.foodEnergy.count >= 1 ? size.width*1.2 : size.width, height: some_species.foodEnergy.count >= 1 ? size.height*1.2 : size.height)
                .transition(AnyTransition.opacity.animation(.linear(duration: 0.1)))
                
                VStack(spacing: 0) {
                    ZStack {
                        Group {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(lineWidth: 3, antialiased: true)
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(colorScheme == .light ? Color.gray : Color.black)
                                .opacity(0.3)
                        }
                        .frame(width: 120, height: 50)
                        .foregroundColor(.black)
                        .shadow(radius: 3)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("\(env.baseDNA[0].identifier): \(Int((some_species.genome.percentageComposition.values.first ?? 0)*100)) %")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .padding(2)
                                if env.baseDNA.count >= 2 {
                                    ZStack {
                                        env.baseDNA[0].color
                                            .clipShape(Circle())
                                            .frame(width: 15, height: 15)
                                        Circle()
                                            .stroke(lineWidth: 0.5)
                                            .foregroundColor(.black)
                                            .frame(width: 15, height: 15)
                                    }
                                }
                            }
                            HStack {
                                Text("\(env.baseDNA[1].identifier): \(Int((some_species.genome.percentageComposition.values.map {$0}.last ?? 0)*100)) %")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .padding(2)
                                if env.baseDNA.count >= 2 {
                                    ZStack {
                                        env.baseDNA[1].color
                                            .clipShape(Circle())
                                            .frame(width: 15, height: 15)
                                        Circle()
                                            .stroke(lineWidth: 0.5)
                                            .foregroundColor(.black)
                                            .frame(width: 15, height: 15)
                                    }
                                }
                            }
                        }
                    }
                    .offset(x: some_species.coordinates.x <= (env.bounds.left + 100) ? 50 : (some_species.coordinates.x >= (env.bounds.right - 100) ? -50 : 0) )
                    Image(systemName: "arrowtriangle.down.fill")
                        .resizable()
                        .frame(width: 10, height: 5)
                }
                .offset(y: -50)
                .transition(AnyTransition.offset(y: -20).combined(with: AnyTransition.scale(scale: 0.4)).combined(with: AnyTransition.opacity))
            }
            
        }
        .position(some_species.coordinates.cg())
        .animation(.easeInOut(duration: 0.2))
        .onTapGesture(perform: {
            withAnimation {
                showInfo.toggle()
            }
        })
    }
}


enum CellStyle { // two styles for visual representation of a species
    case circle, square
}

struct Cell_Previews: PreviewProvider {
    static var previews: some View {
        Cell(gen(coordinates: Point(x: 200, y: 400), SpeciesEnvironment().bounds))
            .environmentObject(SpeciesEnvironment())
    }
}

func angle(_ val: Int, max: Int) -> Angle {
    return Angle.degrees(val.mappedValue(inputRange: 0..<max, outputRange: 0..<360))
}

struct Arc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool

    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment

        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)

        return path
    }
}




