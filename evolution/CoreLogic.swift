//
//  CoreLogic.swift
//  evolution
//
//  Created by Purav Manot on 09/10/20.
//

import Foundation
import SwiftUI



public final class Environment: ObservableObject {
    var bounds = Bounds(left: 50, right: 360, up: 150, down: 660)
}

struct Bounds: Hashable {
    var left: CGFloat
    var right: CGFloat
    var up: CGFloat
    var down: CGFloat
}

struct Food {
    var id = UUID()
    var energy = 10
}

struct Point: Hashable {
    var x: CGFloat
    var y: CGFloat
}

struct Species: Identifiable, Hashable {
    let id = UUID()
    var identifier: String
    var color: Color = .green
    var speed: Double
    var lifespan: Int
    var disabled: Bool
    var coordinates: Point = Point(x: 200, y: 400)
    var bounds: Bounds
    var infected: Bool = false
    var dir = CGFloat.random(in: 0..<2*(.pi))
    var calclatedCoordinates: [Int] = []
    init(name: String, speed: Double, lifespan: Int..., infected: Bool = false, coordinates: Point = Point(x: 200, y: 400), bounds: Bounds = Bounds(left: 50, right: 360, up: 160, down: 660)) {
        self.identifier = name
        self.speed = speed
        self.lifespan = (lifespan.reduce(0, +) / lifespan.count) + Int.random(in: 0..<5)
        self.infected = infected
        self.coordinates = coordinates
        self.bounds = bounds
        switch speed {
        case 0..<2:
            color = .purple
        case 6..<10:
            color = .yellow
        default:
            color = .blue
        }
        self.disabled = false
    }
    
    mutating func updatePos(_ dC: Double = 1) { // updates the xy position of a cell (called at fixed intervals of time)
        if !disabled {
            coordinates.x += sin(dir)*CGFloat(speed)/2
            coordinates.y += cos(dir)*CGFloat(speed)/2
            updateDir()
            lifespan += -1 // 1 step
            avoidBounds()
        }
        disabled = lifespan == 0
    }
    
    mutating func updateDir(_ rStart: CGFloat = -0.05, _ rEnd: CGFloat = 0.05) { //changes the direction of a cell
        dir += CGFloat.random(in: rStart..<rEnd)
        if dir > 2*(.pi) || dir < 0 {
            dir = CGFloat.random(in: 0..<2*(.pi))
        }
    }
    
    func onDeath(_ x: () -> ()) {
        if disabled {
            x()
        }
    }
    
    mutating func avoidBounds() {
        if coordinates.x < bounds.left {
            coordinates.x = bounds.left
            dir = CGFloat.random(in: 0..<2*(.pi))
        }
        if coordinates.x > bounds.right {
            coordinates.x = bounds.right
            dir = CGFloat.random(in: 0..<2*(.pi))
        }
        if coordinates.y > bounds.down {
            coordinates.y = bounds.down
            dir = CGFloat.random(in: 0..<2*(.pi))
        }
        if coordinates.y < bounds.up {
            coordinates.y = bounds.up
            dir = CGFloat.random(in: 0..<2*(.pi))
        }
    }
}

func gen(coordinates: Point) -> Species {
    Species(name: "M", speed: Double.random(in: 0..<10), lifespan: Int.random(in: 100..<1000), coordinates: coordinates)
}

enum Energy: Int {
    case low = 2
    case medium = 5
    case high = 8
}

func rate(_ x: Double) -> (Bool) {
    !(Int.random(in: 0..<10000) <= Int(x*10000))
}

func rate(_ x: Double, _ m: () -> ()) {
    if !(Int.random(in: 0..<10000) <= Int(x*10000)) {
        m()
    }
}

extension Point {
    func cg() -> CGPoint {
        CGPoint(x: self.x, y: self.y)
    }
}
