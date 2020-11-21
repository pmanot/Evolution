//
//  Extensions.swift
//  evolution
//
//  Created by Purav Manot on 21/11/20.
//

import Foundation
import SwiftUI

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

extension CGFloat {
    func capped(_ r: Range<Self>) -> Self {
        if self > r.upperBound {
            return r.upperBound
        }
        if self < r.lowerBound {
            return r.lowerBound
        }
        return self
    }
    
    mutating func cap(_ r: Range<Self>) {
        if self >= r.upperBound {
            self = r.upperBound
        }
        if self <= r.lowerBound {
            self = r.lowerBound
        }
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
