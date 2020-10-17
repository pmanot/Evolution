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
    var color: Color
    @EnvironmentObject var env: Environment
    init(_ species: Species, style: CellStyle = .circle) {
        some_species = species
        self.style = style
        color = species.color
    }
    var body: some View {
        switch style {
        
        case .circle:
            ZStack {
                Circle()
                    .opacity(0.4)
                    .overlay(Circle().stroke(lineWidth: 2).foregroundColor(.black).opacity(0.8))
                    .frame(width: 15, height: 15)
                    .foregroundColor(color)
                    .position(some_species.coordinates.cg())
                if some_species.foodEaten { // if food eaten, display a small dot like indicator within view to show
                    Circle()
                        .opacity(0.4)
                        .overlay(Rectangle().stroke(lineWidth: 2).foregroundColor(.black).opacity(0.8))
                        .frame(width: 4, height: 4)
                        .position(some_species.coordinates.cg())
                }
            }
        
        case .square:
            ZStack {
                Rectangle()
                    .opacity(0.4)
                    .overlay(Rectangle().stroke(lineWidth: 2).foregroundColor(.black).opacity(0.8))
                    .frame(width: 15, height: 15)
                    .foregroundColor(color)
                    .position(some_species.coordinates.cg())
                if some_species.foodEaten { // if food eaten, display a small dot like indicator within view to show
                    Rectangle()
                        .opacity(0.4)
                        .overlay(Rectangle().stroke(lineWidth: 2).foregroundColor(.black).opacity(0.8))
                        .frame(width: 4, height: 4)
                        .position(some_species.coordinates.cg())
                }
            }
        }
    }
}


enum CellStyle { // two styles for visual representation of a species
    case circle, square
}

struct Cell_Previews: PreviewProvider {
    static var previews: some View {
        Cell(gen(coordinates: Point(x: 200, y: 400), Environment().bounds))
            .environmentObject(Environment())
    }
}

