//
//  CreateSpecies.swift
//  evolution
//
//  Created by Purav Manot on 12/11/20.
//

import SwiftUI

struct CreateSpecies: View {
    @State var speciesDNA = [SpeciesDNA("Blue", speed: 5, sight: 4, size: 1, color: Color.blue), SpeciesDNA("Red", speed: 6, sight: 6, size: 1, color: Color.red)]
    @State private var selection: Int = 0
    @State private var n: Int = 5
    @EnvironmentObject var env: SpeciesEnvironment
    @Environment(\.presentationMode) var showing
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            VStack {
                Text("Base Species")
                    .fontWeight(.heavy)
                    .font(.title)
                    .foregroundColor(.darkJungleGreen)
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 30)
                        .foregroundColor(.lightBlueGreen).opacity(0.5)
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.darkblueGray, lineWidth: 1)
                        .frame(width: 50, height: 30)
                    TextField("", value: $n, formatter: NumberFormatter())
                        .frame(width: 20)
                }
                Text("Name: ")
                    .font(.callout)
                Picker("", selection: $selection) {
                    ForEach(0..<2) { n in
                        Text(speciesDNA[n].identifier).tag(n)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 200)
                
                HStack {
                    ZStack {
                        Capsule().foregroundColor(.lightBlueGreen).opacity(0.3)
                            .frame(width: 180, height: 35)
                        Capsule()
                            .strokeBorder(Color.darkblueGray, lineWidth: 1)
                            .frame(width: 180, height: 35)
                        TextField("Species Identifier...", text: $speciesDNA[selection].identifier)
                            .frame(width: 150)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .scaleEffect(CGSize(width: 0.8, height: 0.8), anchor: .center)
                    }
                    if speciesDNA[0].identifier != speciesDNA[1].identifier {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .opacity(0.8)
                    }
                    else {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                            .opacity(0.5)
                    }
                }
                .frame(width: 180, alignment: .leading)
                .padding(.vertical, 10)
                
                VStack(alignment: .leading) {
                    Text("Speed: ")
                        .font(.caption)
                    Picker("", selection: $speciesDNA[selection].speed) {
                        ForEach(0..<10) { n in
                            Text("\(n)").tag(Double(n))
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .frame(width: 320)
                
                VStack(alignment: .leading) {
                    Text("Sight: ")
                        .font(.caption)
                    Picker("", selection: $speciesDNA[selection].sight) {
                        ForEach(0..<10) { n in
                            Text("\(n)").tag(CGFloat(n))
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .frame(width: 320)
                
                VStack(alignment: .leading) {
                    Text("Size: ")
                        .font(.caption)
                    Picker("", selection: $speciesDNA[selection].size) {
                        ForEach(0..<10) { n in
                            Text("\(n)").tag(Double(n))
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .frame(width: 320)
                ColorPicker("", selection: $speciesDNA[selection].color)
                    .padding(.horizontal, 200)
                    .padding(.vertical, 10)
                Button(action: {
                    env.baseDNA = []
                    loop(n){
                        env.addSpecies(Species(speciesDNA[0], lifespan: 100, bounds: env.bounds))
                        env.addSpecies(Species(speciesDNA[1], lifespan: 100, bounds: env.bounds))
                    }
                    env.fetchFood(min: 25, max: 30)
                    env.base(speciesDNA[0])
                    env.base(speciesDNA[1])
                    showing.wrappedValue.dismiss()
                }) {
                    ZStack {
                        Capsule()
                            .frame(width: 80, height: 40)
                            .foregroundColor(.lightBlueGreen)
                            .opacity(0.5)
                        Capsule()
                            .strokeBorder(Color.darkBlueGreen, lineWidth: 0.5)
                            .frame(width: 80, height: 40)

                        Text("OK")
                            .font(.callout)
                            .foregroundColor(.darkJungleGreen)
                            .fontWeight(.heavy)
                    }
                }
            }
        }
        .onAppear {
            if env.baseDNA.count == 2 {
                speciesDNA = env.baseDNA
            }
        }
    }
}

struct CreateSpecies_Previews: PreviewProvider {
    static var previews: some View {
        CreateSpecies()
            .environmentObject(SpeciesEnvironment())
    }
}
