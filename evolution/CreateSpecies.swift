//
//  CreateSpecies.swift
//  evolution
//
//  Created by Purav Manot on 12/11/20.
//

import SwiftUI

struct CreateSpecies: View {
    @State var species = [Species(name: "A", speed: 5, lifespan: 200, sight: 4, infected: false, coordinates: randomPoint(), bounds: <#T##Bounds#>, color: <#T##Color#>) , Species(name: <#T##String#>, speed: <#T##Int#>, lifespan: <#T##Int#>, sight: <#T##CGFloat#>, infected: <#T##Bool#>, coordinates: <#T##Point#>, bounds: <#T##Bounds#>, color: <#T##Color#>)]
    @State private var selection: Int = 0
    @State private var n: Int = 5
    @EnvironmentObject var env: SpeciesEnvironment
    @Environment(\.presentationMode) var showing
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            species[selection].color.brightness(0.2)
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
                        Text(species[n].identifier).tag(n)
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
                        TextField("Species Identifier...", text: $species[selection].identifier)
                            .frame(width: 150)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .scaleEffect(CGSize(width: 0.8, height: 0.8), anchor: .center)
                    }
                    if species[0].identifier != species[1].identifier {
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
                    Picker("", selection: $species[selection].speed) {
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
                    Picker("", selection: $species[selection].sightRadius) {
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
                    Picker("", selection: $species[selection].size) {
                        ForEach(0..<10) { n in
                            Text("\(n)").tag(Double(n))
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .frame(width: 320)
                ColorPicker("", selection: $species[selection].color)
                    .padding(.horizontal, 200)
                    .padding(.vertical, 10)
                Button(action: {
                    env.baseSpecies = []
                    loop(n){
                        env.addSpecies(species[0])
                        env.addSpecies(species[1])
                    }
                    env.base(species[0])
                    env.base(species[1])
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
    }
}

struct CreateSpecies_Previews: PreviewProvider {
    static var previews: some View {
        CreateSpecies()
    }
}
