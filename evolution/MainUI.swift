//
//  MainUI.swift
//  evolution
//
//  Created by Purav Manot on 20/10/20.
//

import SwiftUI

struct MainUI: View {
    @State var deathCount: Int = 0
    @State var birthCount: Int = 0
    @State var deathRate: Double = 1
    @State var currentPopulation = 0
    @State var maxPopulationSize = 10
    @State var runloop = counter(50)
    @State var foodLoop = counter(10)
    @State private var speed: Double = 1
    @EnvironmentObject var env: Environment
    let timer = Timer.publish(every: 0.02, on: .main, in: .default).autoconnect()
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("dot-matrix")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Rectangle()).frame(width: geo.size.width, height: geo.size.height)
                VStack(alignment: .leading) {
                    Button(action: {
                        env.respawn(n: 1)
                    }){
                            HStack(spacing: 10) {
                                Image(systemName: "plus")
                                    .resizable()
                                    .foregroundColor(.darkBlue)
                                    .frame(width: 10, height: 10)
                                Text("add species")
                                    .font(.caption)
                                    .fontWeight(.light)
                                    .foregroundColor(.darkblueGray)
                            }
                        }
                    .buttonStyle(FunctionalButton(25))
                    Button(action: {
                            env.fetchFood(min: 20, max: 30)
                    }){
                        Text("generate food")
                            .font(.caption)
                            .fontWeight(.light)
                            .foregroundColor(.darkblueGray)
                    }
                    .buttonStyle(FunctionalButton())
                    Button(action: {
                        env.alive = []
                        env.food = []
                    }){
                        Text("reset")
                            .font(.caption)
                            .fontWeight(.light)
                            .foregroundColor(.darkblueGray)
                    }
                    .buttonStyle(FunctionalButton())
                }
                .position(x: 75, y: 80)
                    ZStack {
                        Color.lightBlueGreen
                            .brightness(0.2)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.lightBlueGreen, lineWidth: 1))
                            .frame(width: 330, height: 330, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .position(x: geo.size.width/2, y: geo.size.height/1.425)
                        ForEach(env.alive, id: \.id) { alive in
                            Cell(alive)
                        }
                        .background(EnvironmentView())
                    }
                    .onAppear {
                        env.bounds = Bounds(frame: CGSize(width: 300, height: 300), position: CGPoint(x: geo.size.width/2, y: geo.size.height/1.425))
                        print(env.bounds)
                    }
            }
        }
        .onReceive(timer, perform: { _ in
            for n in 0..<env.alive.count {
                withinLimit(n, env.alive.count) { // make sure alive[n] is a valid index (sometimes n goes out of bounds while running due to glitchy behaviour with ForEach).
                    env.alive[n].updatePos() //update position on-screen
                    
                    env.alive[n].eatFood(&env.food, env.alive) // eat any nearby food
                    if env.alive.count < maxPopulationSize { // making sure new births only happen if the population is lower than its peak
                        rate(0.005) { // 0.005 chance of birth per cell every 0.01 seconds, which is approximately 0.5 per second or 50 %
                            env.offspring(env.alive[n], b: gen(coordinates: env.alive[n].coordinates, env.bounds)) //adding the offspring to the array of all currently env.alive species
                            birthCount += 1 //increase birthCount
                        }
                    }
                    
                    env.alive[n].onDeath { // when cell dies
                        withAnimation(.easeInOut(duration: 0.1)) {
                            env.alive[n].color = .black
                        }
                        // run counter
                            env.alive.remove(at: n)
                            deathCount += 1
                    }
                }
            }
            currentPopulation = env.alive.count
        })
    }
}

struct MainUI_Previews: PreviewProvider {
    static var previews: some View {
        MainUI()
            .environmentObject(Environment())
    }
}
/*
.onReceive(timer, perform: { _ in
    for n in 0..<env.alive.count {
        withinLimit(n, env.alive.count) { // make sure alive[n] is a valid index (sometimes n goes out of bounds while running due to glitchy behaviour with ForEach).
            env.alive[n].updatePos() //update position on-screen
            
            env.alive[n].eatFood(&env.food, env.alive) // eat any nearby food
            if env.alive.count < maxPopulationSize { // making sure new births only happen if the population is lower than its peak
                rate(0.005) { // 0.005 chance of birth per cell every 0.01 seconds, which is approximately 0.5 per second or 50 %
                    env.offspring(env.alive[n], b: gen(coordinates: env.alive[n].coordinates, env.bounds)) //adding the offspring to the array of all currently env.alive species
                    birthCount += 1 //increase birthCount
                }
            }
            
            env.alive[n].onDeath { // when cell dies
                withAnimation(.easeInOut(duration: 0.1)) {
                    env.alive[n].color = .black
                }
                // run counter
                    env.alive.remove(at: n)
                    deathCount += 1
            }
        }
    }
    currentPopulation = env.alive.count
})
*/
