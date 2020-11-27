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
    @Published var baseDNA: [SpeciesDNA] = []
    @Published var birthCapVal: Int = 50
    init(_ bounds: Bounds = Bounds(left: 50, right: 360, up: 150, down: 600)) {
        self.bounds = bounds
        food = []
    }
    func fetchFood(min: Int, max: Int) { // injects food into the environment
        food = []
        loop(Int.random(in: min..<max)) {
            food.append(Food(energy: Double.random(in: 0..<10), color: Bool.random() ? .green : .pink,  position: randomPoint(bounds: bounds)))
        }
    }
    func gen(coordinates: Point, lifespan: Double = Double.random(in: 100..<1000)) { // generates a species with random traits
        alive.append(Species(name: "M", speed: Int.random(in: 0..<10), lifespan: lifespan, sight: CGFloat.random(in: 1..<5), coordinates: coordinates, bounds: bounds))
    }
    
    func offspring(_ a: Species, b: Species) { // when two species love each other very very much...
        alive.append(Species(name: a.identifier, speed: (a.speed + b.speed)/2 , lifespan: (a.maxLifespan + b.maxLifespan)/2, sight: (a.sightRadius + b.sightRadius)/2, coordinates: midPoint(a.coordinates, b.coordinates), bounds: bounds, color: a.color))
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
    
    func addSpecies(_ m: Species, n: Int = 1) {
        loop(n){
            alive.append(Species(name: m.identifier, speed: m.speed, lifespan: m.lifespan, sight: m.sightRadius, infected: false, coordinates: randomPoint(bounds: self.bounds), bounds: self.bounds, color: m.color))
        }
    }
    
    func base(_ m: SpeciesDNA){
        baseDNA.append(SpeciesDNA(m.identifier, speed: m.speed, sight: m.sight, size: m.size, color: m.color))
    }
    
    func makeFood(d: Species) {
        let id = d.id
        food.append(Food(energy: Double(d.maxLifespan)/1000, color: .green, position: d.coordinates))
        alive.remove(id: id)
    }
}

func gen(_ name: String = "M", lifespan: Double = Double.random(in: 100..<1000), coordinates: Point = randomPoint(bounds: SpeciesEnvironment().bounds)) -> Species { // generates a species with random traits
    Species(name: name, speed: Int(Double.random(in: 0..<10)), lifespan: lifespan, sight: CGFloat.random(in: 1..<5), coordinates: coordinates, bounds: SpeciesEnvironment().bounds)
}

func midPoint(_ a: Point, _ b: Point) -> Point {
    Point(x: (a.x + b.x)/2, y: (a.y + b.y)/2)
}


func combine(_ x: SpeciesDNA..., variationRate: Double) -> SpeciesDNA {
    var m = SpeciesDNA(x.map{$0.identifier}.reduce(""){$0 + $1}, speed: x.map{$0.speed}.reduce(0, +)/x.count, sight: x.map{$0.sight}.reduce(0, +), size: x.map{$0.size}.reduce(0, +)/x.count, color: x.first!.color)
    rate(variationRate){
        m.speed += Int.random(in: -1..<1)
        m.identifier += " [m]"
        m.size += Int.random(in: -1..<1)
    }
    return m
}

enum Energy: Int {
    case low = 2
    case medium = 5
    case high = 8
}

func gen(coordinates: Point, _ bounds: Bounds) -> Species {
    return Species(name: "M", speed: Int.random(in: 0..<10), lifespan: Double.random(in: 100..<200), sight: CGFloat.random(in: 1..<10), coordinates: coordinates, bounds: bounds)
}

func rate(_ x: Double, _ m: () -> ()) { // function that executes a closure based on a given chance
    if Int.random(in: 0..<10000) <= Int(x*10000) {
        m()
    }
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

func randomPoint(bounds: Bounds = Bounds(left: 50, right: 360, up: 160, down: 660)) -> Point { // picks a random point within the given constraints
    Point(x: CGFloat.random(in: bounds.left..<bounds.right), y: CGFloat.random(in: bounds.up..<bounds.down))
}


