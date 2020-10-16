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
    init(_ species: Species, _ style: CellStyle = .circle) {
        some_species = species
        self.style = style
        color = species.color
    }
    var body: some View {
        switch style {
        
        case .circle:
            Circle()
                .opacity(0.4)
                .overlay(Circle().stroke(lineWidth: 2).foregroundColor(.black).opacity(0.8))
                .frame(width: 20, height: 20)
                .foregroundColor(color)
                .position(some_species.coordinates.cg())
        
        case .square:
            Rectangle()
                .opacity(0.4)
                .overlay(Rectangle().stroke(lineWidth: 2).foregroundColor(.black).opacity(0.8))
                .frame(width: 15, height: 15)
                .foregroundColor(color)
                .position(some_species.coordinates.cg())
        }
    }
}


enum CellStyle {
    case circle, square
}

struct Cell_Previews: PreviewProvider {
    static var previews: some View {
        Cell(gen(coordinates: Point(x: 210, y: 400)), .square)
    }
}

