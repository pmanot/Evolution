//
//  MainUI.swift
//  evolution
//
//  Created by Purav Manot on 20/10/20.
//

import SwiftUI
import SwiftUICharts

struct MainUI: View {
    @State var settingsShowing: Bool = false
    @State var birthCount: Int = 0
    @State var deathCount: Int = 0
    @State private var deathArray: [Double] = []
    @State private var populationArray: [Double] = []
    @State private var birthArray: [Double] = []
    @State var currentPopulation = 0
    @State var maxPopulationSize = 20
    @State var deathAnimationloop = counter(50)
    @State var timerLoop = counter(10)
    @State var delayCount: Int = 10
    @State private var updateLoop = counter(10)
    @State private var speed: Double = 1
    @EnvironmentObject var env: SpeciesEnvironment
    @Environment(\.colorScheme) var colorScheme
    let timer = Timer.publish(every: 0.01, on: .main, in: .default).autoconnect()
    var body: some View {
        GeometryReader { geo in
            ZStack {
                if colorScheme == .light {
                    Image("dot-matrix")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Rectangle())
                        .frame(width: geo.size.width, height: geo.size.height)
                }
                else {
                    Image("dot-matrix")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Rectangle())
                        .frame(width: geo.size.width, height: geo.size.height)
                        .colorInvert()
                }
                
                MultiLineChartView(data: [(populationArray, GradientColors.bluPurpl), (deathArray, GradientColors.prplPink), (birthArray, GradientColors.green)], title: "Population data", form: ChartForm.wide)
                    .overlay(Color.blueGreen.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.lightBlueGreen, lineWidth: 2))
                    .scaleEffect(CGSize(width: 0.6, height: 0.6), anchor: .center)
                    .position(x: geo.size.width - 130, y: 65)
                    .animation(.easeInOut(duration: 0.50))
                
                Button(action: {
                    settingsShowing.toggle()
                }){
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .foregroundColor(.darkblueGray)
                }
                .frame(width: 22, height: 22)
                .position(x: 26, y: 26)
                
                
                VStack(alignment: .leading, spacing: 5) {
                    Button(action: {
                            env.fetchFood(min: 20, max: 30)
                    }){
                        Text("generate food")
                            .font(.caption2)
                            .fontWeight(.light)
                            .foregroundColor(.darkblueGray)
                    }
                    .buttonStyle(FunctionalButton())
                    
                    Button(action: {
                        env.alive = []
                        env.food = []
                    }){
                        Text("reset")
                            .font(.caption2)
                            .fontWeight(.light)
                            .foregroundColor(.darkblueGray)
                    }
                    .buttonStyle(FunctionalButton())
                    
                    Button(action: {
                        env.respawn(n: 1)
                    }){
                        HStack(spacing: 10) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .foregroundColor(.darkJungleGreen)
                                .frame(width: 15, height: 15)
                            Text("add species")
                                .font(.caption2)
                                .fontWeight(.light)
                                .foregroundColor(.darkblueGray)
                                .padding(.vertical, 2)
                        }
                    }
                    .buttonStyle(FunctionalButton(25))
                }
                .position(x: geo.size.width - 80, y: (geo.size.height - geo.size.width/2) - 253)
                
                HStack {
                    Button(action: delayCount > 1 ? {delayCount = Int(Double(delayCount)*1.5); timerLoop = counter(delayCount)} : {delayCount = 1}){
                        Image(systemName: "chevron.left.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color.darkJungleGreen)
                            .overlay(Circle().stroke(Color.darkJungleGreen, lineWidth: 2))
                            .background(Color.lightBlueGreen)
                            .clipShape(Circle())
                    }
                    .buttonStyle(PlainButtonStyle())
                
                    Button(action: delayCount > 1 ? {delayCount = Int(Double(delayCount)/1.5); timerLoop = counter(delayCount)} : {delayCount = 1; timerLoop = counter(delayCount)}){
                        Image(systemName: "chevron.right.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color.darkJungleGreen)
                            .overlay(Circle().stroke(Color.darkJungleGreen, lineWidth: 2))
                            .background(Color.lightBlueGreen)
                            .clipShape(Circle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .position(x: geo.size.width - 320, y: (geo.size.height - geo.size.width/2) - 200)
                
                ZStack {
                    Color.lightTurquoise
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 9).stroke(Color.lightBlueGreen, lineWidth: 2))
                        .overlay(RoundedRectangle(cornerRadius: 9).stroke(Color.darkJungleGreen, lineWidth: 0.25))
                        .frame(width: geo.size.width - 10, height: geo.size.width - 10, alignment: .center)
                        .position(x: geo.size.width/2, y: geo.size.height - 188)
                        .opacity(0.75)
                    
                    ForEach(env.alive, id: \.id) { s in
                        Cell(s)
                    }
                        .background(EnvironmentView())
                }
                .onAppear {
                    env.bounds = Bounds(frame: CGSize(width: geo.size.width - 40, height: geo.size.width - 40), position: CGPoint(x: geo.size.width/2, y: geo.size.height - 188))
                    print(env.bounds)
                }
            }
        }
        .onReceive(timer){ _ in
            timerLoop {
                for n in 0..<env.alive.count {
                    withinLimit(n, env.alive.count) { // make sure alive[n] is a valid index (sometimes n goes out of bounds while running due to glitchy behaviour with ForEach).
                        env.alive[n].updatePos() //update position on-screen
                        
                        env.alive[n].eatFood(&env.food, env.alive) // eat any nearby food
                        if env.alive.count < maxPopulationSize { // making sure new births only happen if the population is lower than its peak
                            rate(env.alive[n].foodEnergy.count >= 1 ? 0.2 : 0.05) { // 0.005 chance of birth per cell every 0.01 seconds, which is approximately 0.5 per second or 50 %
                                withAnimation(.easeIn(duration: 0.4)){
                                    env.offspring(env.alive[n], b: gen(coordinates: env.alive[n].coordinates, env.bounds))
                                }
                                 //adding the offspring to the array of all currently env.alive species
                                birthCount += 1 //increase birthCount
                            }
                        }
                        
                        env.alive[n].onDeath { // when cell dies
                            env.alive[n].color = .red
                        }
                    }
                }
                currentPopulation = env.alive.count
                for d in env.alive.filter({ $0.disabled == true }) {
                    deathAnimationloop {
                        deathCount += 1
                        withAnimation(.easeInOut(duration: 0.5)) {
                            env.makeFood(d: d)
                        }
                        deathAnimationloop = counter(50)
                    }
                }
                populationArray.append(Double(currentPopulation + birthCount))
                deathArray.append(Double(deathCount))
                birthArray.append(Double(birthCount))
                while populationArray.count >= 100 {
                    populationArray.remove(atOffsets: allEven(populationArray.count/4))
                }
                while deathArray.count >= 200 {
                    deathArray.remove(atOffsets: allEven(deathArray.count/4))
                }
                while birthArray.count >= 200 {
                    birthArray.remove(atOffsets: allEven(birthArray.count/4))
                }
                timerLoop = counter(delayCount)
            }
        }
        .sheet(isPresented: $settingsShowing) {
            SettingsUI()
                .environmentObject(SpeciesEnvironment())
        }
    }
}

struct MainUI_Previews: PreviewProvider {
    static var previews: some View {
        MainUI()
            .environmentObject(SpeciesEnvironment())
    }
}

extension ChartForm {
    static public var wide = CGSize(width: 350, height: 200)
}

func allEven(_ x: Int) -> IndexSet {
    var evenNumbers: [Int] = []
    var c = x
    if c % 2 != 0 {
        c -= 1
    }
    while c != 0 {
        c -= 2
        evenNumbers.append(c)
    }
    return IndexSet(evenNumbers)
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
