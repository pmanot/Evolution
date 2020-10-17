//
//  CoreLogic.swift
//  evolution
//
//  Created by Purav Manot on 09/10/20.
//

import Foundation
import SwiftUI



public final class Environment: ObservableObject { // the environment for all species (defines borders that a species cannot cross, contains food, etc)
    @Published var bounds: Bounds // boundaries of the environment
    @Published var food: [Food] // Array containing all available food
    @Published var alive: [Species] = [] // Array containing all currently alive species
    init(min: Int = 30, max: Int = 45, _ bounds: Bounds = Bounds(left: 50, right: 360, up: 150, down: 600)) {
        self.bounds = bounds
        food = []
    }
    func fetchFood(min: Int, max: Int) { // injects food into the environment
        food = []
        loop(Int.random(in: min..<max)) {
            food.append(Food(energy: Double.random(in: 0..<10), color: Bool.random() ? .green : .pink, position: randomPoint(bounds: bounds)))
        }
    }
    func gen(coordinates: Point) { // generates a species with random traits
        alive.append(Species(name: "M", speed: Double.random(in: 0..<10), lifespan: Int.random(in: 100..<1000), sight: Double.random(in: 2..<5), coordinates: coordinates, bounds: bounds))
    }
    
    func offspring(_ a: Species, b: Species) { // when two species love each other very very much...
        alive.append(Species(name: a.identifier + b.identifier, speed: (a.speed + b.speed)/2 , lifespan: (a.lifespan + b.lifespan)/2, sight: (a.sightRadius + b.sightRadius)/2, bounds: bounds))
    }
    
    func respawn(n: Int) { // generates n number of new species with random traits
        loop(n){
            gen(coordinates: randomPoint(bounds: self.bounds))
        }
    }
}

struct Bounds: Hashable { // used to define the boundaries of a frame
    var left: CGFloat
    var right: CGFloat
    var up: CGFloat
    var down: CGFloat
}

struct Food: Identifiable, Hashable {
    var id = UUID()
    var energy: Double // foods with higher energy allow cells to survive longer
    var color: Color
    var position: Point
    init(energy: Double, color: Color, position: Point) {
        self.energy = energy
        self.color = color
        self.position = position
    }
}

struct Point: Hashable, Strideable { // Custom CGPoint struct that conforms to Hashable and Strideable
    var x: CGFloat
    var y: CGFloat
    func distance(to other: Point) -> CGFloat { // calculates the distance between two points
        let delta_x2 = Double(self.x - other.x)*Double(self.x - other.x)
        let delta_y2 = Double(self.y - other.y)*Double(self.y - other.y)
        return CGFloat(sqrt(delta_x2 + delta_y2))
    }
    
    func advanced(by n: CGFloat) -> Point {
        Point(x: self.x + n, y: self.y + n)
    }
    
    func line(_ a: Point, _ b: Point) -> (m: Double, c: Double) { // returns the gradient and y intercept of a line made by two points
        let m = Double((a.y - b.y) / (a.x - b.x))
        return (m: Double((a.y - b.y) / (a.x - b.x)), c: (Double(y) - m*Double(x)))
    }
    
    func liesOn(_ a: Point, _ b: Point) -> Bool { // returns true if point lies on a line (ie. all 3 points are collinear)
        let l = line(a, b)
        return Double(self.y) == Double(self.x)*l.m + l.c
    }
    
    func inRange(of point: Point, radius: CGFloat = 5) -> Bool { // used to detect a collision / touch between two objects
        self.distance(to: point) <= radius
    }
}


struct Species: Identifiable, Hashable {
    let id = UUID()
    var identifier: String
    var color: Color
    var foodEaten: Bool // whether it has consumed food or not
    var speed: Double
    var lifespan: Int
    var disabled: Bool // to be toggled at death, stops all calculations and movement
    var coordinates: Point // position of self
    var bounds: Bounds // boundaries to stop self from going out of given frame
    // var infected: Bool = false // coming soon
    var dir = CGFloat.random(in: 0..<2*(.pi)) //direction in radians
    var sightRadius: Double
    init(name: String, speed: Double, lifespan: Int, sight: Double, infected: Bool = false, coordinates: Point = Point(x: 200, y: 300), bounds: Bounds = Bounds(left: 50, right: 360, up: 160, down: 660)) {
        self.identifier = name
        self.speed = speed
        self.lifespan = lifespan
        // self.infected = infected
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
    
    mutating func updateDir(_ rStart: CGFloat = -0.1, _ rEnd: CGFloat = 0.1) { // changes the direction of a cell slightly from its given direction
        dir += CGFloat.random(in: rStart..<rEnd)
        if dir > 2*(.pi) || dir < 0 { // make sure direction stays within the range of a full rotation (2pi)
            dir = CGFloat.random(in: 0..<2*(.pi))
        }
    }
    
    func onDeath(_ x: () -> ()) { // execute closure when cell dies
        if disabled {
            x()
        }
    }
    
    mutating func avoidBounds() { // bounds collision function to prevent cells from going out of bound
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
        self.lifespan += Int(food.energy*Double(1000)) // energy gained from 'consuming' food increases lifespan
        self.foodEaten = true
    }
    
    mutating func eatFood(_ food: inout [Food], _ alive: [Species]) {
        for f in 0..<food.count {
            withinLimit(f, food.count) { // make sure f is a valid index
                if self.coordinates.inRange(of: food[f].position, radius: 5) {
                    self.consume(food[f])
                    food.remove(at: f)
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

func rate(_ x: Double, _ m: () -> ()) { // function that executes a closure based on a given chance
    if Int.random(in: 0..<10000) <= Int(x*10000) {
        m()
    }
}

extension Point { // converts point to CGPoint
    func cg() -> CGPoint {
        CGPoint(x: self.x, y: self.y)
    }
}

extension BinaryInteger {
    mutating func reset() { // absolutely useless function
        self = 0
    }
}

func randomPoint(bounds: Bounds = Bounds(left: 50, right: 360, up: 160, down: 660)) -> Point { // picks a random point within the given constraints
    Point(x: CGFloat.random(in: bounds.left..<bounds.right), y: CGFloat.random(in: bounds.up..<bounds.down))
}

func withinLimit(_ n: Int, _ limit: Int, _ x: () -> ()){ // used mainly for ensuring indexes are valid before removing them
    if n < limit {
        x()
    }
}

func loop(_ n: Int, _ x: () -> ()) { // pretty self explanatory, executes a closure repeatedly for a given (n) number of times.
    for _ in 0..<n {
        x()
    }
}
