//
//  Cell.swift
//  evolution
//
//  Created by Purav Manot on 13/10/20.
//

import SwiftUI

struct Cell: View {
    var some_species: Species
    var style: CellStyle = .circle
    @EnvironmentObject var env: SpeciesEnvironment
    init(_ species: Species, style: CellStyle = .circle) {
        some_species = species
        self.style = style
    }
    var body: some View {
        switch style {
        
        case .circle:
            ZStack {
                Circle()
                    .strokeBorder(Color.darkJungleGreen)
                    .frame(width: 25, height: 25)
                    .foregroundColor(.blueGreen)
                Circle()
                    .strokeBorder(Color.blueGreen, lineWidth: 6, antialiased: true)
                    .overlay(Arc(startAngle: .degrees(0), endAngle: angle(some_species.lifespan, max: some_species.maxLifespan), clockwise: true).stroke(lineWidth: 2).frame(width: 25, height: 25).foregroundColor(.black))
                    .overlay(some_species.foodEnergy.count >= 1 ? Color.green.opacity(0.2) : Color.lightBlueGray.opacity(0.2)).clipShape(Circle())
                    .frame(width: 25, height: 25)
                Circle()
                    .foregroundColor(.darkJungleGreen)
                    .frame(width: 2, height: 2)
            }
            .overlay(Color.red.opacity(some_species.disabled ? 0.6 : 0).clipShape(Circle()))
            .position(some_species.coordinates.cg())
            .animation(.easeInOut(duration: 0.5))
        
        case .square:
            ZStack {
                // in progress
            }
        }
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


