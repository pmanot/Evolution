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
    @Published var speciesCount: [Double : Int]
    @Published var foodRate: Int
    @Published var cellLifespan: Double
    @Published var reproductionRate: Double
    @Published var allowMutations: Bool = false
    @Published var mutationRate: Double
    @Published var mutationAmount: Int
    @Published var mutationColor: Color = Color.tropicGreen
    @Published var allowCrossBreeding: Bool = false
    init(_ bounds: Bounds = Bounds(left: 50, right: 360, up: 150, down: 600)) {
        self.bounds = bounds
        food = []
        speciesCount = [:]
        foodRate = 20
        cellLifespan = 300
        reproductionRate = 0.002
        mutationAmount = 1
        mutationRate = 0.05
        allowCrossBreeding = false
    }
    func fetchFood(min: Int, max: Int) { // injects food into the environment
        food = []
        loop(Int.random(in: min..<max)) {
            food.append(Food(energy: Double.random(in: 0..<10), color: .black,  position: randomPoint(bounds: bounds)))
        }
    }
    func gen(coordinates: Point, lifespan: Double = Double.random(in: 100..<1000)) { // generates a species with random traits
        alive.append(Species(name: "M", speed: Int.random(in: 0..<10), lifespan: lifespan, sight: Int.random(in: 1..<5), coordinates: coordinates, bounds: bounds))
    }
    
    func replicate(_ s: Species) {
        var offspring = Species(s.genome, lifespan: s.maxLifespan, bounds: self.bounds)
        offspring.coordinates = s.coordinates
        if allowMutations {
            mutate(&offspring, variationRate: mutationRate, variationAmount: mutationAmount)
        }
        alive.append(offspring)
        self.speciesCount.increment(offspring.genome.percentageComposition[baseDNA[0].identifier]!, by: 1)
    }
    
    func makeOffspring(_ s1: Species, _ s2: Species) {
        var offspring = Species(combine(s1.genome, s2.genome, variationRate: 0), lifespan: (s1.maxLifespan + s2.maxLifespan) / 2, bounds: self.bounds)
        offspring.coordinates = s1.coordinates
        alive.append(offspring)
        self.speciesCount.increment(offspring.genome.percentageComposition[baseDNA[0].identifier]!, by: 1)
    }
    
    func respawn(n: Int) { // generates n number of new species with random traits
        loop(n){
            gen(coordinates: randomPoint(bounds: self.bounds))
        }
    }
    func reset() {
        alive = []
        food = []
        speciesCount = [ : ]
    }
    
    func addSpecies(_ m: Species, n: Int = 1) {
        loop(n){
            alive.append(Species(m.genome, lifespan: m.lifespan, bounds: m.bounds))
        }
        self.speciesCount.increment(m.genome.percentageComposition[baseDNA[0].identifier]!, by: 1)
    }
    
    func base(_ a: SpeciesDNA, _ b: SpeciesDNA){
        var baseA = SpeciesDNA(a.identifier, speed: a.speed, sight: a.sight, size: a.size, color: a.color)
        var baseB = SpeciesDNA(b.identifier, speed: b.speed, sight: b.sight, size: b.size, color: b.color)
        baseA.percentageComposition = [baseA.identifier : 1, baseB.identifier : 0]
        baseB.percentageComposition = [baseA.identifier : 0, baseB.identifier : 1]
        baseDNA = [baseA, baseB]
    }
    
    func makeFood(d: Species) {
        let id = d.id
        alive.remove(id: id){
            food.append(Food(energy: Double(d.maxLifespan)/1000, color: d.color, position: d.coordinates))
            self.speciesCount.increment(d.genome.percentageComposition[baseDNA[0].identifier]!, by: -1)
        }
    }
    
    func foodFound(_ cell: Species ) {
        for f in food {
            if f.position.distanceSquared(to: cell.coordinates) <= Double(cell.squaredSightRadius) {
                alive.mutate(id: cell.id, using: {$0.forage(f)})
                if f.position.distanceSquared(to: cell.coordinates) <= 25 {
                    alive.mutate(id: cell.id, using: {
                        if !$0.foodEnergy.contains(f) {
                            $0.foodEnergy.append(f)
                            food.removeAll {$0.id == f.id}
                        }
                        $0.foodDetected = false
                    })
                }
            }
        }
    }
}

func midPoint(_ a: Point, _ b: Point) -> Point {
    Point(x: (a.x + b.x)/2, y: (a.y + b.y)/2)
}


func combine(_ x: SpeciesDNA..., variationRate: Double) -> SpeciesDNA {
    var m = SpeciesDNA(x.map{$0.identifier}.reduce(""){$0 + $1}, speed: x.map{$0.speed}.reduce(0, +)/x.count, sight: x.map{$0.sight}.reduce(0, +), size: x.map{$0.size}.reduce(0, +)/x.count, color: merge(x.map {$0.color}))
    m.percentageComposition = [ : ]
    for a in x {
        m.percentageComposition.add(a.percentageComposition)
    }
    m.percentageComposition = m.percentageComposition.mapValues{ $0 / Double(x.count) }
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


