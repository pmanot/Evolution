//
//  CoreLogic.swift
//  evolution
//
//  Created by Purav Manot on 09/10/20.
//

import Foundation
import SwiftUI


/*
 RULES
 
 #Time conversions:
 1 day in simulation = 10 sec in real life
 
 #Survival Logic:
 In order to survive, a cell must have eaten at least one food pellet a day
 
 #Reproduction Logic:
 If a cell has eaten at least two energy pellets, it is able to reproduce
 
 #Food Logic:
 1 pellet gives you a small speed boost and a small lifespan boost
 
 
*/

public final class SpeciesEnvironment: ObservableObject { // the environment for all species (defines borders that a species cannot cross, contains food, etc)
    @Published var bounds: Bounds // boundaries of the environment
    @Published var food: [Food] // Array containing all available food
    @Published var alive: [Species] = [] // Array containing all currently alive species
    @Published var birthCapVal: Int = 50
    init(_ bounds: Bounds = Bounds(left: 50, right: 360, up: 150, down: 600)) {
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
        alive.append(Species(name: "M", speed: Int.random(in: 0..<10), lifespan: Int.random(in: 100..<1000), sight: Double.random(in: 2..<5), coordinates: coordinates, bounds: bounds))
    }
    
    func offspring(_ a: Species, b: Species) { // when two species love each other very very much...
        alive.append(Species(name: a.identifier + b.identifier, speed: (a.speed + b.speed)/2 , lifespan: Int((a.maxLifespan + b.maxLifespan)/2), sight: (a.sightRadius + b.sightRadius)/2, coordinates: midPoint(a.coordinates, b.coordinates), bounds: bounds))
    }
    
    func respawn(n: Int) { // generates n number of new species with random traits
        loop(n){
            gen(coordinates: randomPoint(bounds: self.bounds))
        }
    }
    func reset() {
        alive = []
        food = []
    }
    
    func makeFood(d: Species) {
        if let ind = alive.firstIndex(of: d) {
            food.append(Food(energy: Double(d.maxLifespan)/1000, color: .green, position: d.coordinates))
            alive.remove(at: ind)
        }
    }
}

func gen(_ name: String = "M", coordinates: Point = randomPoint(bounds: SpeciesEnvironment().bounds)) -> Species { // generates a species with random traits
    Species(name: name, speed: Int(Double.random(in: 0..<10)), lifespan: Int.random(in: 100..<1000), sight: Double.random(in: 2..<5), coordinates: coordinates, bounds: SpeciesEnvironment().bounds)
}

struct Bounds: Hashable { // used to define the boundaries of a frame
    var left: CGFloat
    var right: CGFloat
    var up: CGFloat
    var down: CGFloat
    init(frame: CGSize, position: CGPoint) {
        self.left = position.x - frame.width/2
        self.right = position.x + frame.width/2
        self.up = position.y - frame.height/2
        self.down = position.y + frame.height/2
    }
    init(left: CGFloat, right: CGFloat, up: CGFloat, down: CGFloat) {
        self.left = left
        self.right = right
        self.up = up
        self.down = down
    }
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

func midPoint(_ a: Point, _ b: Point) -> Point {
    Point(x: (a.x + b.x)/2, y: (a.y + b.y)/2)
}

struct Species: Identifiable, Hashable {
    let id = UUID()
    var identifier: String
    var color: Color
    var foodEnergy: [Food]
    var speed: Int // scale of 1 - 10
    var size: Int = 1 // scale of 1 - 5
    var cost: Double {
        Double(speed*size).mappedValue(inputRange: 1..<50, outputRange: 1..<2)
    }
    var lifespan: Double
    var movementCounter: Int
    let maxLifespan: Double
    var disabled: Bool // to be toggled at death, stops all calculations and movement
    var coordinates: Point // position of self
    var bounds: Bounds // boundaries to stop self from going out of given frame
    // var infected: Bool = false // coming soon
    var dir = CGFloat.random(in: 0..<2*(.pi)) //direction in radians
    var sightRadius: Double
    init(name: String, speed: Int, lifespan: Int, sight: Double = 5, infected: Bool = false, coordinates: Point = Point(x: 200, y: 300), bounds: Bounds = Bounds(left: 50, right: 360, up: 160, down: 660)) {
        self.identifier = name
        self.speed = speed
        self.lifespan = Double(lifespan)
        self.maxLifespan = Double(lifespan)
        // self.infected = infected
        self.coordinates = coordinates
        self.bounds = bounds
        self.sightRadius = sight
        self.foodEnergy = []
        switch speed {
        case 0..<2:
            color = .purple
        case 6..<10:
            color = .yellow
        default:
            color = .blue
        }
        self.disabled = false
        self.movementCounter = Int(10 - speed)
    }
    
    
    mutating func updatePos() { // updates the xy position of a cell (called at fixed intervals of time)
        if !disabled {
            if movementCounter <= 0 {
                movementCounter = Int(10 - speed)
            }
            if movementCounter == Int(10 - speed) {
                coordinates.x += sin(dir)*5 //increase the x position
                coordinates.y += cos(dir)*5 //increase the y position
                updateDir() //update the direction
                lifespan -= cost // 1 step
                avoidBounds()
            }
            movementCounter -= 1
            if foodEnergy.count >= 1 {
                lifespan = maxLifespan
            }
        }
        disabled = lifespan <= 0
    }
    
    mutating func updateDir(_ rStart: CGFloat = -0.05, _ rEnd: CGFloat = 0.05) { // changes the direction of a cell slightly from its given direction
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
    
    mutating func eatFood(_ food: inout [Food], _ alive: [Species]) {
        for f in 0..<food.count {
            withinLimit(f, food.count) { // make sure f is a valid index
                if self.coordinates.inRange(of: food[f].position, radius: 5) {
                    self.foodEnergy.append(food[f])
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
    return Species(name: "M", speed: Int.random(in: 0..<10), lifespan: Int.random(in: 100..<1000), sight: Double.random(in: 2..<5), coordinates: coordinates, bounds: bounds)
}

func rate(_ x: Double, _ m: () -> ()) { // function that executes a closure based on a given chance
    if Int.random(in: 0..<10000) <= Int(x*10000) {
        m()
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


extension BinaryInteger {
    func mappedValue(inputRange rS: Range<Self>, outputRange rF: Range<Self>) -> Double {
        let cappedValue = self.capped(rS.lowerBound..<rS.upperBound)
        switch (rF.lowerBound, rS.lowerBound) {
        case (0,0):
            return (Double(rF.upperBound)/Double(rS.upperBound)) * Double(cappedValue)
        default:
            let delta = Double(rF.upperBound - rF.lowerBound)/Double(rS.upperBound - rS.lowerBound)
            let c = Double(rF.lowerBound) - Double(rS.lowerBound)*delta
            return (Double(cappedValue)*delta + c)
        }
    }
    
    func capped(_ r: Range<Self>) -> Self {
        if self > r.upperBound {
            return r.upperBound
        }
        if self < r.lowerBound {
            return r.lowerBound
        }
        return self
    }
    
    mutating func reset() { // absolutely useless function
        self = 0
    }
}

extension Double {
    func mappedValue(inputRange rS: Range<Self>, outputRange rF: Range<Self>) -> Double {
        let cappedValue = self.capped(rS.lowerBound..<rS.upperBound)
        switch (rF.lowerBound, rS.lowerBound) {
        case (0,0):
            return rF.upperBound/rS.upperBound * cappedValue
        default:
            let delta = (rF.upperBound - rF.lowerBound)/(rS.upperBound - rS.lowerBound)
            let c = rF.lowerBound - rS.lowerBound*delta
            return (Double(cappedValue)*delta + c)
        }
        
    }
    
    func capped(_ r: Range<Self>) -> Self {
        if self > r.upperBound {
            return r.upperBound
        }
        if self < r.lowerBound {
            return r.lowerBound
        }
        return self
    }
}

extension Point { // converts point to CGPoint
    func cg() -> CGPoint {
        CGPoint(x: self.x, y: self.y)
    }
}

func color(_ r: Double, _ g: Double, _ b: Double) -> Color {
    Color(red: r/255, green: g/255, blue: b/255)
}

func counter(_ initialCount: Int) -> (() -> Void) -> () {
    var i = initialCount
    func countDown(_ x: () -> Void) -> () {
        i -= 1
        if i <= 0 {
            x()
        }
    }
    return countDown
}


extension Color {
    static let primaryText = color(42, 47, 65)
    static let secondaryText = color(54, 60, 82)
    static let darkblueGray = color(65, 72, 99)
    static let lightBlueGray = color(150, 157, 187)
    static let lightGray = color(218, 220, 231)
    static let blueGreen = color(124, 222, 220)
    static let darkBlueGreen = color(35, 139, 137)
    static let lightBlueGreen = color(178, 236, 235)
    static let mediumPurple = color(147, 129, 255)
    static let lavender = color(201, 191, 255)
    static let darkBlue = color(91, 62, 255)
    static let mildYellow = color(236, 221, 123)
    static let lightYellow = color(241, 230, 159)
    static let umber = color(104, 83, 77)
    static let taupe = color(116, 92, 86)
    static let lightSalmon = color(255, 166, 134)
    static let orangeCrayola = color(255, 104, 50)
    static let silk = color(255, 212, 197)
    static let coralPink = color(255, 135, 144)
    static let background = color(247, 253, 253)
    static let darkJungleGreen = color(21, 86, 86)
    static let lightTurquoise = color(162, 233, 233)
}
