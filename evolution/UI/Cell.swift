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
    var size: CGSize
    init(_ species: Species, size: CGSize = CGSize(width: 20, height: 20)) {
        some_species = species
        self.size = size
    }
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Color.black)
                .frame(width: some_species.foodEnergy.count >= 1 ? size.width*1.2 : size.width, height: some_species.foodEnergy.count >= 1 ? size.width*1.2 : size.width)
            Circle()
                .strokeBorder(colorScheme == .dark ? Color.accentColor : Color.lightTurquoise, lineWidth: 6, antialiased: true)
                .overlay(Arc(startAngle: .degrees(0), endAngle: angle(Int(some_species.lifespan), max: Int(some_species.maxLifespan)), clockwise: true).stroke(lineWidth: 3).frame(width: some_species.foodEnergy.count >= 1 ? size.width*1.2 : size.width, height: some_species.foodEnergy.count >= 1 ? size.width*1.2 : size.width).foregroundColor(.black))
                .overlay(some_species.foodEnergy.count >= 1 ? Color.green.opacity(0.2) : Color.lightBlueGray.opacity(0.2)).clipShape(Circle())
                .frame(width: some_species.foodEnergy.count >= 1 ? size.width*1.2 : size.width, height: some_species.foodEnergy.count >= 1 ? size.width*1.2 : size.width)
            Circle()
                .foregroundColor(colorScheme == .light ? Color.black : Color.accentColor)
                .frame(width: 2, height: 2)
        }
        .overlay(some_species.color.opacity(0.5)
        .clipShape(Circle()).frame(width: 26))
        .frame(width: 26, height: 26)
        .position(some_species.coordinates.cg())
        .animation(.easeInOut(duration: 0.5))
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




