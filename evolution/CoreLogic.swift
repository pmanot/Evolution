//
//  CoreLogic.swift
//  evolution
//
//  Created by Purav Manot on 09/10/20.
//

import Foundation
import SwiftUI



public final class Environment: ObservableObject {
    @Published var bounds: Bounds
    @Published var food: [Food]
    @Published var alive: [Species] = []
    init(min: Int = 30, max: Int = 45, _ bounds: Bounds = Bounds(left: 50, right: 360, up: 150, down: 660)) {
        self.bounds = bounds
        food = []
    }
    func fetchFood(min: Int, max: Int) {
        food = []
        for _ in 0..<Int.random(in: min..<max) {
            food.append(Food(energy: Double.random(in: 0..<10), color: Bool.random() ? .green : .pink, position: randomPoint(bounds: bounds)))
        }
    }
    func gen(coordinates: Point) {
        alive.append(Species(name: "M", speed: Double.random(in: 0..<10), lifespan: Int.random(in: 100..<1000), sight: Double.random(in: 2..<5), coordinates: coordinates, bounds: bounds))
    }
    
    func offspring(_ a: Species, b: Species) {
        alive.append(Species(name: a.identifier + b.identifier, speed: (a.speed + b.speed)/2 , lifespan: (a.lifespan + b.lifespan)/2, sight: (a.sightRadius + b.sightRadius)/2, bounds: bounds))
    }
    
    func respawn(n: Int) {
        loop(n){
            gen(coordinates: randomPoint(bounds: self.bounds))
        }
    }
}

struct Bounds: Hashable {
    var left: CGFloat
    var right: CGFloat
    var up: CGFloat
    var down: CGFloat
}

struct Food: Identifiable, Hashable {
    var id = UUID()
    var energy: Double
    var color: Color
    var position: Point = Point(x: 200, y: 400)
    init(energy: Double, color: Color, position: Point) {
        self.energy = energy
        self.color = color
        self.position = position
    }
}

struct Point: Hashable, Strideable {
    func distance(to other: Point) -> CGFloat {
        let delta_x2 = Double(self.x - other.x)*Double(self.x - other.x)
        let delta_y2 = Double(self.y - other.y)*Double(self.y - other.y)
        return CGFloat(sqrt(delta_x2 + delta_y2))
    }
    
    func advanced(by n: CGFloat) -> Point {
        Point(x: self.x + n, y: self.y + n)
    }
    
    func line(_ a: Point, _ b: Point) -> (m: Double, c: Double) {
        let m = Double((a.y - b.y) / (a.x - b.x))
        return (m: Double((a.y - b.y) / (a.x - b.x)), c: (Double(y) - m*Double(x)))
    }
    
    func liesOn(_ a: Point, _ b: Point) -> Bool {
        let l = line(a, b)
        return Double(self.y) == Double(self.x)*l.m + l.c
    }
    
    func inRange(of point: Point, radius: CGFloat = 5) -> Bool {
        self.distance(to: point) <= radius
    }
    
    var x: CGFloat
    var y: CGFloat
}


struct Species: Identifiable, Hashable {
    let id = UUID()
    var identifier: String
    var color: Color
    var foodEaten: Bool
    var speed: Double
    var lifespan: Int
    var disabled: Bool
    var coordinates: Point = Point(x: 200, y: 400)
    var bounds: Bounds
    var infected: Bool = false
    var dir = CGFloat.random(in: 0..<2*(.pi))
    var sightRadius: Double
    init(name: String, speed: Double, lifespan: Int, sight: Double, infected: Bool = false, coordinates: Point = Point(x: 200, y: 400), bounds: Bounds = Bounds(left: 50, right: 360, up: 160, down: 660)) {
        self.identifier = name
        self.speed = speed
        self.lifespan = lifespan
        self.infected = infected
        self.coordinates = coordinates
        self.bounds = bounds
        self.sightRadius = sight
        self.foodEaten = false
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
            coordinates.x += sin(dir)*CGFloat(speed) //increase the x position
            coordinates.y += cos(dir)*CGFloat(speed) //increase the y position
            updateDir() //update the direction
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
    
    mutating func consume(_ food: Food) {
        self.lifespan += Int(food.energy*Double(1000))
        self.foodEaten = true
    }
    
    mutating func eatFood(_ food: inout [Food], _ alive: [Species]) {
        for f in 0..<food.count {
            safeForIn(f, food.count) {
                if self.coordinates.inRange(of: food[f].position, radius: 5) {
                    self.consume(food[f])
                    if f < food.count {
                        food.remove(at: f)
                    }
                }
            }
        }
    }
}

enum Energy: Int {
    case low = 2
    case medium = 5
    case high = 8
}

func gen(coordinates: Point, _ bounds: Bounds) -> Species {
    return Species(name: "M", speed: Double.random(in: 0..<10), lifespan: Int.random(in: 100..<1000), sight: Double.random(in: 2..<5), coordinates: coordinates, bounds: bounds)
}

func rate(_ x: Double, _ m: () -> ()) {
    if Int.random(in: 0..<10000) <= Int(x*10000) {
        m()
    }
}

extension Point {
    func cg() -> CGPoint {
        CGPoint(x: self.x, y: self.y)
    }
}

extension BinaryInteger {
    mutating func reset() {
        self = 0
    }
}

func randomPoint(bounds: Bounds = Bounds(left: 50, right: 360, up: 160, down: 660)) -> Point {
    Point(x: CGFloat.random(in: bounds.left..<bounds.right), y: CGFloat.random(in: bounds.up..<bounds.down))
}

func safeForIn(_ n: Int, _ limit: Int, _ x: () -> ()){
    if n < limit {
        x()
    }
}

func loop(_ n: Int, _ x: () -> ()) {
    for _ in 0..<n {
        x()
    }
}
