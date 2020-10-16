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
    @State var maxPopulationSize = 10
    @State var runloop = counter(50)
    @State var foodLoop = counter(2)
    @State private var speed: Double = 1
    @EnvironmentObject var env: Environment
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
                    Text("death count: \(deathCount)")
                        .fontWeight(.light)
                        .font(.caption)
                    Text("birth count: \(birthCount)")
                        .fontWeight(.light)
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
                        FoodView(env.food)
                        ForEach(0..<alive.count, id: \.self) { n in
                            Cell(alive[n], .square)
                                .onReceive(timer) { _ in
                                    safeForIn(n, alive.count) { // make sure alive[n] is a valid index (sometimes n goes out of bounds while running due to glitchy behaviour with ForEach).
                                        alive[n].updatePos()
                                        alive[n].onDeath { // when cell dies
                                            withAnimation(.easeInOut(duration: 0.4)) {
                                                alive[n].color = .black
                                            }
                                            runloop(){ // run counter
                                                alive.remove(at: n)
                                                deathCount += 1
                                                runloop = counter(50) // reset counter
                                            }
                                        }
                                        alive[n].eatFood(&env.food, alive)
                                        if alive.count < maxPopulationSize { // making sure new births only happen if the population is lower than its peak
                                            rate(0.005) {
                                                alive.append(offspring(alive[n], b: gen(coordinates: alive[n].coordinates)))
                                                birthCount += 1 //increase birthCount
                                            }
                                        }
                                    }
                                    currentPopulation = alive.count
                                }
                                .opacity(alive[n].disabled ? 0.5 : 1)
                        }
                    }
                    VStack(spacing: 2) {
                        Text("Population size cap")
                            .fontWeight(.light)
                            .font(.subheadline)
                        Picker("Population size cap", selection: $maxPopulationSize){
                            Text("5").tag(5)
                            Text("10").tag(10)
                            Text("25").tag(25)
                            Text("50").tag(50)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 200)
                    }
                }
            }
        }
    }
}

func respawn(_ x: inout [Species]) {
    x = [gen(coordinates: Point(x: 200, y: 400)), gen(coordinates: Point(x: 200, y: 400))]
}

func counter(_ initialCount: Int) -> (() -> Void) -> () {
    var i = initialCount
    func countDown(_ x: () -> Void) -> () {
        i -= 1
        if i == 0 {
            x()
        }
    }
    return countDown
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Environment())
    }
}



