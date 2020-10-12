//
//  CoreLogic.swift
//  evolution
//
//  Created by Purav Manot on 09/10/20.
//

import Foundation
import SwiftUI


struct Food {
    var id = UUID()
    var energy = 10
}

struct Species: Identifiable, Hashable {
    let id = UUID()
    var identifier: String
    var color: Color = .green
    var speed: Double
    var lifespan: Int
    var xpos: Double = 200
    var ypos: Double = 400
    var infected: Bool = false
    var dir = Double.random(in: 0..<2*(.pi))
    init(name: String, speed: Double, lifespan: Int..., infected: Bool = false) {
        self.identifier = name
        self.speed = speed
        self.lifespan = (lifespan.reduce(0, +) / lifespan.count) + Int.random(in: 0..<5)
        self.infected = infected
        if self.speed <= 2 {
            self.color = .red
        }
        else if self.speed <= 5 {
            self.color = .yellow
        }
        else {
            self.color = .green
        }
    }
    
    mutating func updatePos(_ dC: Double = 1) {
        xpos += sin(dir)*speed/2
        ypos += cos(dir)*speed/2
        updateDir()
        lifespan += -1 // 1 step
        if rate(dC) {
            lifespan = 0
        }
        if xpos > 360 {
            xpos = 360
            dir = Double.random(in: 0..<2*(.pi))
        }
        if xpos < 50 {
            xpos = 50
            dir = Double.random(in: 0..<2*(.pi))
        }
        if ypos > 660 {
            ypos = 660
            dir = Double.random(in: 0..<2*(.pi))
        }
        if ypos < 150 {
            ypos = 150
            dir = Double.random(in: 0..<2*(.pi))
        }
        
    }
    mutating func updateDir(_ rStart: Double = -0.05, _ rEnd: Double = 0.05) {
        dir += Double.random(in: rStart..<rEnd)
        if dir > 2*(.pi) || dir < 0 {
            dir = Double.random(in: 0..<2*(.pi))
        }
    }
    
    mutating func die() -> Bool {
        if lifespan == 0 {
            withAnimation {
                self.color = .red
            }
            return true
        }
        return false
    }
}

func gen() -> Species {
    Species(name: "X \(String(Int.random(in: 0..<23)))", speed: Double.random(in: 0..<10), lifespan: Int.random(in: 100..<1000))
}

enum Edge: CGFloat {
    case left = 20
    case right = 350
    case top = 650
    case bottom = 100
}

func rate(_ x: Double) -> Bool {
    !(Int.random(in: 0..<10000) <= Int(x*10000))
}
