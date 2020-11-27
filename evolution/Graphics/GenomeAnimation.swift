//
//  GenomeAnimation.swift
//  evolution
//
//  Created by Purav Manot on 23/11/20.
//

import SwiftUI

struct GenomeAnimation: View {
    @State private var length: Int = 50
    @State private var width: Double = 50
    @State private var blurRadius: CGFloat = 1
    @State private var spacing: Double = 0.5
    var primaryColor: Color = .blue
    var secondaryColor: Color = .red
    init(primary: Color, secondary: Color) {
        primaryColor = primary; secondaryColor = secondary
    }
    let timer = Timer.publish(every: 0.2, on: .current, in: .common).autoconnect()
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Group {
                    DotWave(size: 18, spacing: spacing, width: width, n: length, loops: 5, rotation: 0, flipped: true)
                        .foregroundColor(primaryColor)
                    DotWave(size: 7, spacing: spacing, width: 50, n: length + 5, loops: 4, rotation: 0, flipped: true)
                        .foregroundColor(primaryColor).brightness(0.2)
                        .blur(radius: 0.5)
                }
                
                Group {
                    DotWave(size: 5, spacing: spacing, width: width, n: length + 5, loops: 5, rotation: 0)
                        .foregroundColor(secondaryColor)
                    DotWave(size: 10, spacing: spacing, width: 50, n: length + 10, loops: 6, rotation: 0)
                        .foregroundColor(secondaryColor).brightness(0.2)
                    DotWave(size: 6, spacing: spacing, width: 50, n: length + 12, loops: 5, rotation: 0)
                        .foregroundColor(secondaryColor).brightness(0.5)
                }
                    .onReceive(timer, perform: { _ in
                        withAnimation(.easeInOut(duration: 1)) {
                            if length != 300 {
                                length += 1
                                width += 0.25
                                spacing += 0.1
                            }
                            width = width.capped(0..<60)
                        }
                    })
            }
            .position(x: geo.size.width/2, y: geo.size.height/2)
        }
        .drawingGroup()
    }
}

struct GenomeAnimation_Previews: PreviewProvider {
    static var previews: some View {
        GenomeAnimation(primary: .blue, secondary: .green)
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
                        .strokeBorder(lineWidth: 1.2, antialiased: true)
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

