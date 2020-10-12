//
//  ContentView.swift
//  evolution
//
//  Created by Purav Manot on 09/10/20.
//

import SwiftUI

struct ContentView: View {
    @State var alive: [Species] = [Species(name: "x", speed: 7, lifespan: 100000)]
    @State var deathCount: Int = 0
    @State var birthCount: Int = 0
    @State var deathRate: Double = 1
    @State var deathAnimation: Bool = false
    @State var currentPopulation = 0
    @State private var speed: Double = 1
    @State var timer = Timer.publish(every: 0.01, on: .main, in: .default).autoconnect()
    var body: some View {
        GeometryReader { frame in
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: frame.size.width / 1.2 + 10, height: frame.size.height / 1.5 + 10, alignment: .center)
                    .foregroundColor(.gray)
                    .overlay(RoundedRectangle(cornerRadius: 8).frame(width: frame.size.width / 1.2, height: frame.size.height / 1.5, alignment: .center).foregroundColor(.white))
                VStack(alignment: .leading) {
                    Text("Current population size: \(currentPopulation)")
                        .fontWeight(.heavy)
                        .font(.title2)
                    Text("death count: \(deathCount)")
                        .font(.caption)
                    Text("birth count: \(birthCount)")
                        .font(.caption)
                    Button(action: {
                        respawn(&alive)
                        deathCount = 0
                        birthCount = 0
                        deathRate = 1
                    }){
                        Text("Restart simulation")
                            .fontWeight(.heavy)
                            .font(.caption)
                            .padding(8)
                            .background(Color.pink)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.leading)
                .frame(width: frame.size.width, height: frame.size.height*0.95, alignment: .topLeading)
                VStack {
                    ZStack {
                        ForEach(0..<alive.count, id: \.self) { n in
                            Circle()
                                .overlay(Circle().stroke(lineWidth: 1.5).foregroundColor(.black))
                                .frame(width: 20, height: 20)
                                .foregroundColor(alive[n].color)
                                .animation(.easeIn(duration: 3))
                                .opacity(0.4)
                                .position(x: CGFloat(alive[n].xpos), y: CGFloat(alive[n].ypos))
                                .onReceive(timer, perform: { _ in
                                    if n < alive.count {
                                        alive[n].updatePos()
                                        if alive[n].die() {
                                            alive.remove(at: n)
                                            deathCount += 1
                                            deathAnimation.toggle()
                                        }
                                        if rate(0.995) {
                                            if alive.count < 100 {
                                                alive.append(rate(0.5) ? gen() : Species(name: "p", speed: alive.map {$0.speed}.reduce(0, +)/Double(alive.count), lifespan: alive.map {$0.lifespan}.reduce(0, +)/alive.count))
                                                birthCount += 1
                                            }
                                            else {
                                                var m = 1
                                                for _ in 0..<alive.count {
                                                    if rate(0.02) == true {
                                                        m = m*1
                                                    }
                                                    else {
                                                        m = m*0
                                                    }
                                                }
                                                if m == 1 {
                                                    alive.append(rate(0.5) ? gen() : Species(name: "p", speed: alive.map {$0.speed}.reduce(0, +)/Double(alive.count), lifespan: alive.map {$0.lifespan}.reduce(0, +)/alive.count))
                                                }
                                            }
                                        }
                                    }
                                    currentPopulation = alive.count
                                })
                        }
                    }
                }
            }
        }
    }
}

func respawn(_ x: inout [Species]) {
    x = [gen(), gen()]
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



