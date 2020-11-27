//
//  MainUI.swift
//  evolution
//
//  Created by Purav Manot on 20/10/20.
//

import SwiftUI
import SwiftUICharts

struct MainUI: View {
    @State var createSpeciesView: Bool = false
    @State private var populationArrayA: [Double] = [0]
    @State private var populationArrayB: [Double] = [0]
    @State private var totalPopulation: [Double] = [0]
    @State private var deathAnimationloop = counter(50)
    @State private var foodLoop = counter(1000)
    @State private var updatePopulationLoop = counter(100)
    @State private var resetDay = false
    @State private var foodAmount = 15
    @State private var delayCount: Double = 2
    @State private var speciesColorGradients: [GradientColor] = [GradientColors.orngPink, GradientColors.bluPurpl]
    @EnvironmentObject var env: SpeciesEnvironment
    @Environment(\.colorScheme) var colorScheme
    @State private var timer = Timer.publish(every: 0.01, on: .current, in: .common).autoconnect()
    @State private var paused = false
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(alignment: .leading) {
                    MultiLineChartView(data: [(populationArrayA, speciesColorGradients[0]), (populationArrayB, speciesColorGradients[1]), (totalPopulation, GradientColors.green)], title: "Population data", legend: "\(env.baseDNA.first?.identifier ?? ""): \(Int(populationArrayA.last ?? 0))   \(env.baseDNA.last?.identifier ?? ""): \(Int(populationArrayB.last ?? 0))", form: ChartForm.wide)
                        .overlay(Color.blueGreen.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.lightBlueGreen, lineWidth: 2))
                        .scaleEffect(CGSize(width: 0.6, height: 0.6), anchor: .center)
                        .frame(width: 200, height: 150)
                }
                .frame(width: geo.size.width/100, height: geo.size.height/100)
                .animation(.linear)
                .position(x: geo.size.width - 130, y: 70)
                
                ZStack {
                    Capsule()
                        .foregroundColor(.lightBlueGray)
                        .frame(width: 70, height: 40)
                    HStack(spacing: 5) {
                        Button(action: {
                            createSpeciesView.toggle()
                        }){
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .foregroundColor(.darkblueGray)
                        }
                        .frame(width: 22, height: 22)
                        
                        Button(action: {
                            withAnimation {
                                self.paused.toggle()
                            }
                            if paused {
                                timer.upstream.pause()
                            }
                            else {
                                self.timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
                            }
                        }){
                            Image(systemName: !paused ? "pause.circle.fill" : "play.circle.fill")
                                .resizable()
                                .foregroundColor(.lightTurquoise)
                        }
                        .frame(width: 22, height: 22)
                    }
                }
                .position(x: 50, y: 28)
                
                VStack(alignment: .leading, spacing: 5) {
                    Button(action: {
                            env.fetchFood(min: 20, max: 30)
                    }){
                        Text("generate food")
                            .font(.caption2)
                            .fontWeight(.light)
                            .foregroundColor(.darkblueGray)
                    }
                    .buttonStyle(FunctionalButtonStyle())
                    
                    Button(action: {
                        env.alive = []
                        env.food = []
                        populationArrayA = [0]; populationArrayB = [0]; totalPopulation = [0]
                    }){
                        Text("reset")
                            .font(.caption2)
                            .fontWeight(.light)
                            .foregroundColor(.darkblueGray)
                    }
                    .buttonStyle(FunctionalButtonStyle())
                    
                    Button(action: {
                        for dna in env.baseDNA {
                            env.addSpecies(Species(dna, lifespan: 200, bounds: env.bounds), n: 2)
                        }
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
                    .buttonStyle(FunctionalButtonStyle(25))
                }
                .position(x: geo.size.width - 80, y: (geo.size.height - geo.size.width/2) - 253)
                
                HStack {
                    Group {
                        Button(action: {
                            delayCount = (delayCount*1.2).capped(1..<3)
                            self.timer = Timer.publish(every: 0.005 * delayCount, on: .main, in: .common).autoconnect()
                        }){
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
                        Button(action: {
                            delayCount = delayCount/1.2.capped(1..<3)
                            self.timer = Timer.publish(every: 0.005 * delayCount, on: .main, in: .common).autoconnect()
                        }){
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
                
                    Picker("", selection: $foodAmount) {
                        Text("low").tag(10)
                        Text("medium").tag(20)
                        Text("high").tag(35)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 200)
                    .scaleEffect(CGSize(width: 0.7, height: 0.7), anchor: .center)
                    .frame(width: 140)
                }
                .position(x: geo.size.width - 250, y: (geo.size.height - geo.size.width/2) - 200)
                
                ZStack(alignment: .topLeading) {
                    (colorScheme == .dark ? Color.mediumPurple : Color.coralPink)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 9).stroke(colorScheme == .dark ? Color.darkBlueGreen : Color.pink, lineWidth: 2))
                        .opacity(0.7)
                    EnvironmentView()
                    ForEach(env.alive, id: \.id) { s in
                        Cell(s)
                    }
                    .transition(.bright)
                }
                .frame(width: geo.size.width - 10, height: geo.size.width - 10, alignment: .center)
                .position(x: geo.size.width/2, y: geo.size.height - 188)
                .onAppear {
                    env.bounds = Bounds(left: 30, right: geo.size.width - 30, up: 30, down: geo.size.width - 30)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(DotMatrix(Int(geo.size.width), Int(geo.size.height))
                            .position(x: geo.size.width/2, y: geo.size.height/2)
                            .foregroundColor(.lightBlueGray)
                            .edgesIgnoringSafeArea(.all))
        }
        .onReceive(timer){ _ in
            for n in 0..<env.alive.count {
                if resetDay {
                    env.alive[n].dayReset()
                }
                withinLimit(n, env.alive.count) { // make sure alive[n] is a valid index (sometimes n goes out of bounds while running due to glitchy behaviour with ForEach).
                    env.alive[n].updatePos() //update position on-screen
                        if env.alive[n].foodEnergy.count >= 1 {
                            rate(0.002) { // 0.005 chance of birth per cell every 0.01 seconds, which is approximately 0.5 per second or 50 %
                                env.alive[n].foodEnergy.removeFirst()
                                env.alive[n].replicate(&env.alive)
                                 //adding the offspring to the array of all currently env.alive species
                            }
                        }
                    env.alive[n].onDeath {
                        let dead = env.alive[n]
                        delay(0.2){
                            env.makeFood(d: dead)
                        }
                    }
                    env.alive[n].eatFood(&env.food)
                }
            }
            resetDay = false
                
            updatePopulationLoop {
                if env.baseDNA.count == 2 {
                    if populationArrayA.last != Double(env.alive.filter {$0.identifier == env.baseDNA[0].identifier}.count) {
                        populationArrayA.append(Double(env.alive.filter {$0.identifier == env.baseDNA[0].identifier}.count))
                    }
                    if populationArrayB.last != Double(env.alive.filter {$0.identifier == env.baseDNA[1].identifier}.count) {
                        populationArrayB.append(Double(env.alive.filter {$0.identifier == env.baseDNA[1].identifier}.count))
                    }
                    if totalPopulation.last != Double(env.alive.count) {
                        totalPopulation.append(Double(env.alive.count))
                    }
                }
                updatePopulationLoop = counter(5)
            }
            
            foodLoop {
                env.fetchFood(min: foodAmount, max: foodAmount + 5)
                foodLoop = counter(1000)
                resetDay = true
            }
        }
        .fullScreenCover(isPresented: $createSpeciesView){
            CreateSpecies()
                .onAppear {
                    paused = true
                    self.timer.upstream.connect().cancel()
                }
                .onDisappear {
                    paused = false
                    self.timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
                    self.speciesColorGradients = [GradientColor(start: env.baseDNA.first!.color, end: env.baseDNA.first!.color), GradientColor(start: env.baseDNA.last!.color, end: env.baseDNA.last!.color)]
                    print(env.baseDNA[0].sight)
                }
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
    while c != 0 {
        c -= 2
        evenNumbers.append(c)
    }
    return IndexSet(evenNumbers)
}

extension Timer.TimerPublisher {
    func pause() {
        self.connect().cancel()
    }
}

