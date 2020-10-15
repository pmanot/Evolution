//
//  ContentView.swift
//  evolution
//
//  Created by Purav Manot on 09/10/20.
//

import SwiftUI

struct ContentView: View {
    @State var alive: [Species] = []
    @State var deathCount: Int = 0
    @State var birthCount: Int = 0
    @State var deathRate: Double = 1
    @State var currentPopulation = 0
    @State var runCount: Int = 0
    @State private var speed: Double = 1
    @Namespace private var animation
    let timer = Timer.publish(every: 0.01, on: .main, in: .default).autoconnect()
    var body: some View {
        GeometryReader { frame in
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: frame.size.width / 1.2 + 10, height: frame.size.height / 1.5 + 10, alignment: .center)
                    .foregroundColor(.gray)
                    .overlay(RoundedRectangle(cornerRadius: 8).frame(width: frame.size.width / 1.2, height: frame.size.height / 1.5, alignment: .center).foregroundColor(.black))
                VStack(alignment: .leading) {
                    Text("Current population size: \(currentPopulation)")
                        .fontWeight(.heavy)
                        .font(.title2)
                    Text("Purav death count: \(deathCount)")
                        .font(.caption)
                    Text("birth count: \(birthCount)")
                        .font(.caption)
                    Button(action: {
                        respawn(&alive)
                        deathCount = 0
                        birthCount = 2
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
                                Cell(alive[n], .square)
                                    .onReceive(timer) { _ in
                                        if n < alive.count { // make sure alive[n] is a valid index
                                            alive[n].updatePos()
                                            alive[n].onDeath { // when cell dies
                                                withAnimation(.easeIn) {
                                                    alive[n].color = .black
                                                }
                                                if runCount == 0 {
                                                    deathCount.increment(1) // increase death counter by 1
                                                }
                                                runCount += 1
                                                if runCount == 100 {
                                                    alive.remove(at: n)
                                                    runCount.reset()
                                                }
                                            }
                                            rate(0.995) {
                                                if alive.count < 20 {
                                                    alive.append(rate(0.5) ? gen(coordinates: alive[n].coordinates) : Species(name: "p", speed: alive.map {$0.speed}.reduce(0, +)/Double(alive.count), lifespan: alive.map {$0.lifespan}.reduce(0, +)/alive.count))
                                                    birthCount += 1
                                                }
                                            }
                                        }
                                        currentPopulation = alive.count
                                    }
                                    .opacity(alive[n].disabled ? 0.5 : 1)
                        }
                    }
                }
            }
        }
    }
}

extension Int {
    mutating func increment(_ x: Int) {
        self += x
    }
    
    mutating func reset() {
        self = 0
    }
}


func respawn(_ x: inout [Species]) {
    x = [gen(coordinates: Point(x: 200, y: 400)), gen(coordinates: Point(x: 200, y: 400))]
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



