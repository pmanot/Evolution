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
    @State var birthCount: Int = 0
    @State var deathCount: Int = 0
    @State private var deathArray: [Double] = []
    @State private var populationArrayA: [Double] = [0]
    @State private var populationArrayB: [Double] = [0]
    @State private var birthArray: [Double] = []
    @State var maxPopulationSize = 20
    @State private var deathAnimationloop = counter(50)
    @State private var timerLoop = counter(10)
    @State private var foodLoop = counter(1000)
    @State private var updatePopulationLoop = counter(100)
    @State private var resetDay = false
    @State private var foodAmount = 15
    @State var delayCount: Int = 10
    @EnvironmentObject var env: SpeciesEnvironment
    @Environment(\.colorScheme) var colorScheme
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    var body: some View {
        GeometryReader { geo in
            ZStack {
                if colorScheme == .light {
                    Image("dot-matrix")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Rectangle())
                        .frame(width: geo.size.width, height: geo.size.height)
                        .ignoresSafeArea(.all)
                }
                else {
                    Image("dot-matrix")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Rectangle())
                        .frame(width: geo.size.width, height: geo.size.height)
                        .ignoresSafeArea(.all)
                        .colorInvert()
                        .overlay(Color.lightBlueGray.opacity(0.15))
                        .ignoresSafeArea(.all)
                }
                
                VStack(alignment: .leading) {
                    MultiLineChartView(data: [(populationArrayA, GradientColors.bluPurpl), (populationArrayB, GradientColors.orngPink)], title: "Population data", legend: "\(env.baseDNA.first?.identifier ?? ""): \(Int(populationArrayA.last ?? 0))   \(env.baseDNA.last?.identifier ?? ""): \(Int(populationArrayB.last ?? 0))", form: ChartForm.wide)
                        .overlay(Color.blueGreen.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.lightBlueGreen, lineWidth: 2))
                        .scaleEffect(CGSize(width: 0.6, height: 0.6), anchor: .center)
                        .frame(width: 200, height: 150)
                        .animation(.default)
                }
                .animation(.default)
                .position(x: geo.size.width - 130, y: 70)
                
                Button(action: {
                    createSpeciesView.toggle()
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
                        populationArrayA = []; populationArrayB = []; birthCount = 0; deathCount = 0
                    }){
                        Text("reset")
                            .font(.caption2)
                            .fontWeight(.light)
                            .foregroundColor(.darkblueGray)
                    }
                    .buttonStyle(FunctionalButton())
                    
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
                    .buttonStyle(FunctionalButton(25))
                }
                .position(x: geo.size.width - 80, y: (geo.size.height - geo.size.width/2) - 253)
                
                HStack {
                    Group {
                        Button(action: delayCount > 1 ? {delayCount = Int(Double(delayCount)*1.5); timerLoop = counter(delayCount)} : {delayCount = 2}){
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
                
                ZStack {
                    (colorScheme == .dark ? Color.mediumPurple : Color.coralPink)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 9).stroke(colorScheme == .dark ? Color.darkBlueGreen : Color.pink, lineWidth: 2))
                        .frame(width: geo.size.width - 10, height: geo.size.width - 10, alignment: .center)
                        .position(x: geo.size.width/2, y: geo.size.height - 188)
                        .opacity(0.7)
                    EnvironmentView()
                    ForEach(env.alive, id: \.id) { s in
                        Cell(s)
                            .transition(.asymmetric(insertion: .bright, removal: .identity))
                    }
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
                    if resetDay {
                        env.alive[n].dayReset()
                    }
                    
                    withinLimit(n, env.alive.count) { // make sure alive[n] is a valid index (sometimes n goes out of bounds while running due to glitchy behaviour with ForEach).
                        env.alive[n].updatePos() //update position on-screen
                        
                        if env.alive.count < maxPopulationSize { // making sure new births only happen if the population is lower than its peak
                            if env.alive[n].foodEnergy.count >= 1 {
                                rate(0.002) { // 0.005 chance of birth per cell every 0.01 seconds, which is approximately 0.5 per second or 50 %
                                    env.alive[n].foodEnergy.removeFirst()
                                    env.alive[n].replicate(&env.alive)
                                     //adding the offspring to the array of all currently env.alive species
                                    birthCount += 1 //increase birthCount
                                }
                            }
                        }
                        env.alive[n].eatFood(&env.food)
                        env.alive[n].onDeath {
                            let dead = env.alive[n]
                            delay(0.5){
                                env.makeFood(d: dead)
                            }
                        }
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
                    }
                    updatePopulationLoop = counter(5)
                }
                
                foodLoop {
                    env.fetchFood(min: foodAmount, max: foodAmount + 5)
                    foodLoop = counter(1000)
                    resetDay = true
                }
                
                timerLoop = counter(delayCount)
            }
        }
        .fullScreenCover(isPresented: $createSpeciesView, content: CreateSpecies.init)
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


