//
//  ContentView.swift
//  evolution
//
//  Created by Purav Manot on 09/10/20.
//

import SwiftUI

struct ContentView: View {
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
            HStack {
                Button(action: {
                    env.respawn(n: 3)
                    deathCount = 0
                    birthCount = 2
                    deathRate = 1
                }){
                    Text("generate random cells")
                        .fontWeight(.heavy)
                        .font(.caption)
                        .padding(8)
                        .background(Color.green)
                        .clipShape(Capsule())
                }
                .buttonStyle(PlainButtonStyle())
                Button(action: {
                    env.fetchFood(min: 30, max: 35)
                }){
                    Text("generate random food")
                        .fontWeight(.heavy)
                        .font(.caption)
                        .padding(8)
                        .background(Color.red)
                        .clipShape(Capsule())
                }
                .buttonStyle(PlainButtonStyle())
            }
            ZStack {
                FoodView() // scatter food
                ForEach(0..<env.alive.count, id: \.self) { n in //creates a view for each species env.alive currently
                    Cell(env.alive[n], style: .square)
                        .onReceive(timer) { _ in
                            safeForIn(n, env.alive.count) { // make sure alive[n] is a valid index (sometimes n goes out of bounds while running due to glitchy behaviour with ForEach).
                                env.alive[n].updatePos()
                                env.alive[n].onDeath { // when cell dies
                                    withAnimation(.easeInOut(duration: 0.4)) {
                                        env.alive[n].color = .black
                                    }
                                    runloop(){ // run counter
                                        env.alive.remove(at: n)
                                        deathCount += 1
                                        runloop = counter(50) // reset counter
                                    }
                                }
                                env.alive[n].eatFood(&env.food, env.alive) // eat any nearby food
                                if env.alive.count < maxPopulationSize { // making sure new births only happen if the population is lower than its peak
                                    rate(0.005) { // 0.005 chance of birth per cell every 0.01 seconds, which is approximately 0.5 per second or 50 %
                                        env.offspring(env.alive[n], b: gen(coordinates: env.alive[n].coordinates, env.bounds)) //adding the offspring to the array of all currently env.alive species
                                        birthCount += 1 //increase birthCount
                                    }
                                }
                            }
                            currentPopulation = env.alive.count
                        }
                        .opacity(env.alive[n].disabled ? 0.5 : 1)
                }
            }
            .frame(width: 350, height: 400)
            .background(EnvironmentView().frame(width: 350, height: 400))
            birthCap($maxPopulationSize, "New births cap")
        }
    }
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


struct birthCap: View {
    @EnvironmentObject var env: Environment
    @Binding var selection: Int
    var text: String
    init(_ val: Binding<Int>, _ text: String){
        self.text = text
        self._selection = val
    }
    var body: some View {
        VStack(spacing: 2) {
            Text(text)
                .fontWeight(.light)
                .font(.callout)
            Picker("Population size cap", selection: $selection){
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

