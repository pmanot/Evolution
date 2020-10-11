//
//  ContentView.swift
//  evolution
//
//  Created by Purav Manot on 09/10/20.
//

import SwiftUI

struct ContentView: View {
    @State var alive: [Species] = [gen(), gen()]
    @State var deathCount: Int = 0
    @State var birthCount: Int = 0
    @State var deathRate: Double = 1
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 390, height: 500, alignment: .topLeading)
                .opacity(0.2)
            VStack {
                Text("death count: \(deathCount)")
                Text("birth count: \(birthCount)")
                Button(action: {
                    respawn(&alive)
                    deathCount = 0
                    birthCount = 0
                    deathRate = 1
                }){
                    Text("restart simulation")
                        .fontWeight(.heavy)
                        .font(.caption)
                        .padding()
                        .background(Color.pink)
                        .clipShape(Capsule())
                }
                .buttonStyle(PlainButtonStyle())
            }
                .frame(width: 375, height: 650, alignment: .top)
            ForEach(0..<alive.count, id: \.self) { n in
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.pink)
                    .opacity(0.2)
                    .position(x: CGFloat(alive[n].xpos), y: CGFloat(alive[n].ypos))
                    .onReceive(timer, perform: { _ in
                        if n < alive.count {
                            alive[n].updatePos(deathRate)
                            if alive[n].die() {
                                alive.remove(at: n)
                                deathCount += 1
                            }
                            if random() {
                                alive = alive + [gen()]
                                if alive.count >= 20 {
                                    deathRate = 0.9 - 0.0001*Double((alive.count - 20))
                                }
                                print(alive.count)
                                birthCount += 1
                            }
                        }
                    })
            }
        }
    }
}

func random() -> Bool {
    Int.random(in: 0..<1000) == 4
}

func respawn(_ x: inout [Species]) {
    x = [gen(), gen()]
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

