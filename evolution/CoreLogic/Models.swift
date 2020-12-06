//
//  Models.swift
//  evolution
//
//  Created by Purav Manot on 21/11/20.
//

import Foundation
import SwiftUI
import SwiftUICharts

//Species
struct Species: Identifiable, Hashable {
    let id = UUID()
    var genome: SpeciesDNA
    var foodEnergy: [Food]
    var cost: Double {
        Double(genome.speed*genome.size).mappedValue(inputRange: 1..<100, outputRange: 1..<2)
    }
    var lifespan: Double
    var movementCounter: Int
    let maxLifespan: Double
    var disabled: Bool // to be toggled at death, stops all calculations and movement
    var coordinates: Point // position of self
    var bounds: Bounds // boundaries to stop self from going out of given frame
    // var infected: Bool = false // coming soon
    var dir = CGFloat.random(in: 0..<2*(.pi)) //direction in radians
    var squaredSightRadius: Int
    var foodDetected: Bool = false
    init(name: String, speed: Int, size: Int = 1, lifespan: Double, sight: Int = 5, infected: Bool = false, coordinates: Point = Point(x: 200, y: 300), bounds: Bounds = SpeciesEnvironment().bounds, color: Color = .green) {
        self.lifespan = lifespan
        self.maxLifespan = lifespan
        // self.infected = infected
        self.coordinates = coordinates
        self.bounds = bounds
        self.squaredSightRadius = (size + 15)^2 + (sight*3)^2
        self.foodEnergy = []
        self.disabled = false
        self.movementCounter = 10 - speed
        genome = SpeciesDNA(name, speed: speed, sight: sight, size: size, color: color)
    }
    
    init(_ base: SpeciesDNA, lifespan: Double, bounds: Bounds = SpeciesEnvironment().bounds, coordinates: Point = Point(x: 200, y: 300)) {
        self.bounds = bounds
        self.lifespan = lifespan
        self.squaredSightRadius = (base.size + 15)^2 + (base.sight*3)^2
        self.coordinates = coordinates
        self.foodEnergy = []
        self.maxLifespan = lifespan
        self.disabled = false
        self.movementCounter = 10 - base.speed
        genome = base
    }
    
    mutating func updatePos() { // updates the xy position of a cell (called at fixed intervals of time)
        if !disabled {
            coordinates.x += cos(dir)*5 //increase the x position
            coordinates.y -= sin(dir)*5 //increase the y position
            lifespan -= cost // 1 step
            avoidBounds()
        }
        disabled = lifespan <= 0
    }
    
    mutating func update() {
        movementCounter -= 1
        if movementCounter <= 0 {
            movementCounter = 10 - genome.speed
        }
        if foodEnergy.count >= 1 {
            lifespan = maxLifespan
        }
    }
    
    mutating func dayReset(){
        if foodEnergy.count >= 1 {
            lifespan = maxLifespan
        }
        foodEnergy = []
    }
    
    mutating func updateDir(_ rStart: CGFloat = -0.05, _ rEnd: CGFloat = 0.05) { // changes the direction of a cell slightly from its given direction
        if !foodDetected {
            dir += CGFloat.random(in: rStart..<rEnd)
            if dir > 2*(.pi) || dir < 0 { // make sure direction stays within the range of a full rotation (2pi)
                dir = CGFloat.random(in: 0..<2*(.pi))
            }
        }
    }
    
    func onDeath(_ x: () -> ()) { // execute closure when cell dies
        if disabled {
            x()
        }
    }
    
    mutating func avoidBounds() { // bounds collision function to prevent cells from going out of bound
        if coordinates.x < bounds.left || coordinates.x > bounds.right || coordinates.y > bounds.down || coordinates.y < bounds.up {
            coordinates.x.cap(bounds.left..<bounds.right)
            coordinates.y.cap(bounds.up..<bounds.down)
            dir = CGFloat.random(in: 0..<2*(.pi))
        }
    }
    
    mutating func forage(_ f: Food) {
        if self.coordinates.inRange(of: f.position, radiusSquared: Double(self.squaredSightRadius)) {
            let value = atan(abs(f.position.y - self.coordinates.y)/abs(self.coordinates.x - f.position.x))
            if (self.coordinates.x - f.position.x) >= 0 && (f.position.y - self.coordinates.y) >= 0 { // 1st quadrant works
                dir = (.pi) + value
                //print("A")
            }
            else if (self.coordinates.x - f.position.x) <= 0 && (f.position.y - self.coordinates.y) <= 0 { // 3rd quadrant doesn't work
                dir = value
                //print("B")
            }
            else if (self.coordinates.x - f.position.x) >= 0 && (f.position.y - self.coordinates.y) <= 0 { // 4th quadrant works
                dir = (.pi) - value
                //print("C")
            }
            else if (self.coordinates.x - f.position.x) <= 0 && (f.position.y - self.coordinates.y) >= 0 { // 2nd quadrant works
                dir = 2*(.pi) - value
                //print("D")
            }
            foodDetected = true
        }
    }
}


struct SpeciesDNA: Hashable {
    var identifier: String
    var percentageComposition: [String: Double]
    var speed: Int
    var sight: Int
    var size: Int
    var color: Color
    init(_ identifier: String, speed: Int, sight: Int, size: Int, color: Color){
        self.identifier = identifier
        self.speed = speed
        self.sight = sight
        self.size = size
        self.color = color
        self.percentageComposition = [ : ]
        self.percentageComposition[identifier] = 1
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

struct Point: Hashable, Strideable { // Custom CGPoint struct that conforms to Hashable and Strideable
    var x: CGFloat
    var y: CGFloat
}

func delay(_ time: Double, _ x: @escaping () -> ()){
    DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: x)
}

struct ChartData {
    var data: [Double]
    var gradientColor: GradientColor
    init(_ data: Int, color: Color) {
        self.data = [0]
        self.data.append(Double(data))
        self.gradientColor = color.gC()
    }
    
    mutating func reset() {
        data = [0]
    }
    
    mutating func update(value: Int) {
        if data.last ?? 0 != Double(value) {
            data.append(Double(value))
        }
    }
    
    func tuple() -> ([Double], GradientColor) {
        (self.data, self.gradientColor)
    }
}
