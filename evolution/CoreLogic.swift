//
//  CoreLogic.swift
//  evolution
//
//  Created by Purav Manot on 09/10/20.
//

import Foundation
import SwiftUI

struct Species: Identifiable, Hashable {
    let id = UUID()
    var identifier: String
    var speed: Int
    var lifespan: Int
    var xpos: Double = 200
    var ypos: Double = 400
    var dir = Double.random(in: 0..<2*(.pi))
    init(name: String, speed: Int, lifespan: Int...) {
        self.identifier = name
        self.speed = speed
        self.lifespan = (lifespan.reduce(0, +) / lifespan.count) + Int.random(in: 0..<5)
    }
    
    mutating func updatePos(_ dC: Double = 1) {
        xpos += sin(dir)
        ypos += cos(dir)
        updateDir()
        lifespan += -1 // 1 step
        if rate(dC) {
            lifespan = 0
        }
        if xpos > 350 {
            xpos = 350
        }
        if xpos < 0 {
            xpos = 0
        }
        if ypos > 600 {
            ypos = 600
        }
        if ypos < 100 {
            ypos = 100
        }
        
    }
    mutating func updateDir() {
        dir += Double.random(in: -0.05..<0.05)
    }
    
    func die() -> Bool {
        lifespan == 0
    }
}

func gen() -> Species {
    Species(name: "X \(String(Int.random(in: 0..<23)))", speed: Int.random(in: 0..<10), lifespan: Int.random(in: 100..<1000))
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
