//
//  GenomeAnimation.swift
//  evolution
//
//  Created by Purav Manot on 23/11/20.
//

import SwiftUI

struct GenomeAnimation: View {
    @State private var length: Int = 50
    @State private var width: CGFloat = 60
    @State private var rotation: Double = 0
    @State private var spacing: Double = 0
    var color1: Color = .blue
    var color2: Color = .red
    init(color: Color) {
        color1 = color; color2 = color
    }
    let timer = Timer.publish(every: 0.2, on: .current, in: .common).autoconnect()
    var body: some View {
        GeometryReader { geo in
            ZStack {
                DotWave(size: 5, spacing: spacing, width: 70, n: length, loops: 4, rotation: rotation, flipped: true)
                    .foregroundColor(color1)
                DotWave(size: 5, spacing: spacing, width: 70, n: length + 5, loops: 5, rotation: 0)
                    .foregroundColor(color2)
                    .onReceive(timer, perform: { _ in
                        withAnimation(.easeOut(duration: 0.1)) {
                            if length != 300 {
                                length += 1
                                width += 2
                                spacing += 0.1
                                rotation += 1
                                if rotation == 360 {
                                    rotation = 0
                                }
                            }
                        }
                    })
            }
            .position(x: geo.size.width/2, y: geo.size.height/2)
        }.animation(.easeInOut)
    }
}

struct GenomeAnimation_Previews: PreviewProvider {
    static var previews: some View {
        GenomeAnimation(color: .red)
    }
}


struct DotWave: View {
    var circleSize: CGFloat = 20
    var spacing: Double
    var length: Int = 10
    var width: Double
    var flipped: Bool
    var rotation: Double
    var loops: Double
    init(size: CGFloat, spacing: Double = 5, width: Double = 60, n: Int, loops: Int, rotation: Double, flipped: Bool = false){
        circleSize = size
        self.spacing = spacing
        self.length = n
        self.width = width
        self.flipped = flipped
        self.rotation = rotation
        self.loops = Double(loops)
    }
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center, spacing: CGFloat(spacing)) {
                ForEach(0..<length, id: \.self) { n in
                    Circle()
                        .frame(width: circleSize, height: circleSize, alignment: .center)
                        .offset(x: (flipped ? 1 : -1) * sin(CGFloat(Double(n).mappedValue(inputRange: 0..<Double(length), outputRange: -loops*Double.pi..<loops*Double.pi))) * CGFloat(rotation.mappedValue(inputRange: 0..<360, outputRange: -width..<width)))
                }
            }
            .position(x: geo.size.width/2, y: geo.size.height/2)
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

func genArray(_ n: Int) -> Array<Int> {
    var f: [Int] = []
    for a in 0..<n {
        f.append(a)
    }
    return f
}
