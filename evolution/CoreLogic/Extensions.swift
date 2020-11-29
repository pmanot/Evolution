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

//Color
func color(_ r: Double, _ g: Double, _ b: Double) -> Color {
    Color(red: r/255, green: g/255, blue: b/255)
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
    static let umber = color(104, 83, 77)
    static let taupe = color(116, 92, 86)
    static let lightSalmon = color(255, 166, 134)
    static let orangeCrayola = color(255, 104, 50)
    static let silk = color(255, 212, 197)
    static let coralPink = color(255, 135, 144)
    static let background = color(247, 253, 253)
    static let darkJungleGreen = color(21, 86, 86)
    static let lightTurquoise = color(162, 233, 233)
    static let lightGreen = color(162, 193, 116)
    static let tropicGreen = color(100, 150, 108)
}

extension Color {
    var components: (red: Double, green: Double, blue: Double, opacity: Double) {

        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0

        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            // You can handle the failure here as you want
            return (0, 0, 0, 0)
        }

        return (Double(r), Double(g), Double(b), Double(o))
    }
    
    func darken(_ n: Double, r: Double = 1, g: Double = 1, b: Double = 1) -> Color {
        Color(red: Double(self.components.red)/((n+1)*r), green: Double(self.components.green)/((n+1)*g), blue: Double(self.components.blue)/((n+1)*b), opacity: Double(self.components.opacity))
    }
    
    func lighten(_ n: Double) -> Color {
        Color(red: Double(self.components.red)/n, green: Double(self.components.green)/n, blue: Double(self.components.blue)/n, opacity: Double(self.components.opacity))
    }
    
    func merge(_ c: Color) -> Color {
        return Color(red: (c.components.red + self.components.red)/2, green: (c.components.green + self.components.green)/2, blue: (c.components.blue + self.components.blue)/2, opacity: 1)
    }
    
}

func merge(_ x: Color, _ c: Color) -> Color {
    return Color(red: (c.components.red + x.components.red)/2, green: (c.components.green + x.components.green)/2, blue: (c.components.blue + x.components.blue)/2, opacity: 1)
}

func merge(_ c: Color...) -> Color {
    Color(red: c.map {$0.components.red}.reduce(0, +)/Double(c.count), green: c.map {$0.components.green}.reduce(0, +)/Double(c.count), blue: c.map {$0.components.blue}.reduce(0, +)/Double(c.count))
}

func merge(_ c: [Color]) -> Color {
    Color(red: c.map {$0.components.red}.reduce(0, +)/Double(c.count), green: c.map {$0.components.green}.reduce(0, +)/Double(c.count), blue: c.map {$0.components.blue}.reduce(0, +)/Double(c.count))
}


extension Array where Element == Species {
    mutating func remove(id: UUID){
        self.removeAll {$0.id == id}
    }
}
