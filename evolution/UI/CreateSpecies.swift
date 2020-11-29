//
//  CreateSpecies.swift
//  evolution
//
//  Created by Purav Manot on 12/11/20.
//

import SwiftUI

struct CreateSpecies: View {
    @State var speciesDNA = [SpeciesDNA("X", speed: 5, sight: 41, size: 1, color: Color.blue), SpeciesDNA("M", speed: 6, sight: 61, size: 1, color: Color.red)]
    @State private var selection: Int = 0
    @State private var n: Int = 5
    @EnvironmentObject var env: SpeciesEnvironment
    @Environment(\.presentationMode) var showing
    @Environment(\.colorScheme) var colorScheme
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = colorScheme == .dark ? UIColor.black : UIColor.white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: colorScheme == .dark ? UIColor.white : UIColor.black], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: colorScheme == .dark ? UIColor.white : UIColor.black], for: .normal)

    }
    var body: some View {
        ZStack {
            if (colorScheme == .light) {
                Color.gray
                    .brightness(0.2)
                    .opacity(0.5)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .frame(width: 350, height: 550)
            }
            RoundedRectangle(cornerRadius: 25.0)
                .strokeBorder(Color.gray, lineWidth: 2)
                .opacity(0.8)
                .frame(width: 370, height: 620)
                .background(
                    ZStack {
                        if (colorScheme == .light) {
                            GenomeAnimation(primary: speciesDNA[selection].color, secondary: Color.black)
                                .opacity(0.7)
                                .offset(x: -100)
                                .animation(.easeIn(duration: 0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        }
                        else {
                            GenomeAnimation(primary: speciesDNA[selection].color, secondary: speciesDNA[1 - selection].color)
                                .opacity(0.5)
                                .offset(x: -100)
                                .animation(.easeIn(duration: 0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        }
                    }
                )
            VStack {
                Text("DNA")
                    .fontWeight(.heavy)
                    .font(.largeTitle)
                    .opacity(0.8)
                ZStack {
                    Capsule().foregroundColor(.black).opacity(0.3)
                        .frame(width: 50, height: 30)
                    Capsule()
                        .strokeBorder(Color.black, lineWidth: 0.5)
                        .frame(width: 50, height: 30)
                    TextField("", value: $n, formatter: NumberFormatter())
                        .frame(width: 20)
                }
                Text("Name: ")
                    .font(.callout)
                Picker("", selection: $selection) {
                    ForEach(0..<2, id: \.self) { n in
                        Text(speciesDNA[n].identifier).tag(n)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(
                    ZStack {
                        if colorScheme == .light {
                            Color.black
                                .opacity(0.1)
                                .clipShape(RoundedRectangle(cornerRadius: 7))
                            Color.black
                                .clipShape(RoundedRectangle(cornerRadius: 7).stroke(lineWidth: 0.2))
                        }
                        else {
                            Color.gray
                                .opacity(0.1)
                                .clipShape(RoundedRectangle(cornerRadius: 7))
                            Color.gray
                                .clipShape(RoundedRectangle(cornerRadius: 7).stroke(lineWidth: 0.2))
                        }
                    }
                )
                .frame(width: 200)
                
                HStack {
                    ZStack {
                        Capsule().foregroundColor(.black).opacity(0.3)
                            .frame(width: 180, height: 35)
                        Capsule()
                            .strokeBorder(Color.black, lineWidth: 0.5)
                            .frame(width: 180, height: 35)
                        TextField("Species Identifier...", text: $speciesDNA[selection].identifier)
                            .frame(width: 150)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .scaleEffect(CGSize(width: 0.8, height: 0.8), anchor: .center)
                    }
                    if speciesDNA[0].identifier != speciesDNA[1].identifier {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor((colorScheme == .light) ? Color.black : speciesDNA[selection].color )
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
                        .font(.caption2)
                    Picker("", selection: $speciesDNA[selection].speed) {
                        ForEach(1..<10, id: \.self) { n in
                            Text("\(n)").tag(Double(n))
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(
                        ZStack {
                            if colorScheme == .light {
                                Color.black
                                    .opacity(0.1)
                                    .clipShape(RoundedRectangle(cornerRadius: 7))
                                Color.black
                                    .clipShape(RoundedRectangle(cornerRadius: 7).stroke(lineWidth: 0.2))
                            }
                            else {
                                Color.gray
                                    .opacity(0.1)
                                    .clipShape(RoundedRectangle(cornerRadius: 7))
                                Color.gray
                                    .clipShape(RoundedRectangle(cornerRadius: 7).stroke(lineWidth: 0.2))
                            }
                        }
                    )
                }
                .frame(width: 280)
                
                VStack(alignment: .leading) {
                    Text("Sight: ")
                        .font(.caption2)
                    Picker("", selection: $speciesDNA[selection].sight) {
                        ForEach(1..<10, id: \.self) { n in
                            Text("\(n)").tag(Double(n*n + 25))
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(
                        ZStack {
                            if colorScheme == .light {
                                Color.black
                                    .opacity(0.1)
                                    .clipShape(RoundedRectangle(cornerRadius: 7))
                                Color.black
                                    .clipShape(RoundedRectangle(cornerRadius: 7).stroke(lineWidth: 0.2))
                            }
                            else {
                                Color.gray
                                    .opacity(0.1)
                                    .clipShape(RoundedRectangle(cornerRadius: 7))
                                Color.gray
                                    .clipShape(RoundedRectangle(cornerRadius: 7).stroke(lineWidth: 0.2))
                            }
                        }
                    )
                }
                .frame(width: 280)
                
                VStack(alignment: .leading) {
                    Text("Size: ")
                        .font(.caption2)
                    Picker("", selection: $speciesDNA[selection].size) {
                        ForEach(1..<10, id: \.self) { n in
                            Text("\(n)").tag(Double(n))
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(
                        ZStack {
                            if colorScheme == .light {
                                Color.black
                                    .opacity(0.1)
                                    .clipShape(RoundedRectangle(cornerRadius: 7))
                                Color.black
                                    .clipShape(RoundedRectangle(cornerRadius: 7).stroke(lineWidth: 0.2))
                            }
                            else {
                                Color.gray
                                    .opacity(0.1)
                                    .clipShape(RoundedRectangle(cornerRadius: 7))
                                Color.gray
                                    .clipShape(RoundedRectangle(cornerRadius: 7).stroke(lineWidth: 0.2))
                            }
                        }
                    )
                }
                .frame(width: 280)
                ColorPicker("", selection: $speciesDNA[selection].color)
                    .padding(.horizontal, 200)
                    .padding(.vertical, 10)
                Button(action: {
                    env.base(speciesDNA[0], speciesDNA[1])
                    loop(n){
                        env.addSpecies(Species(env.baseDNA[0], lifespan: 100, bounds: env.bounds))
                        env.addSpecies(Species(env.baseDNA[1], lifespan: 100, bounds: env.bounds))
                    }
                    env.fetchFood(min: 25, max: 30)
                    showing.wrappedValue.dismiss()
                }) {
                    ZStack {
                        Capsule()
                            .frame(width: 80, height: 40)
                            .foregroundColor(speciesDNA[selection].color)
                            .opacity(0.5)
                        Capsule()
                            .strokeBorder(Color.black, lineWidth: 0.5)
                            .frame(width: 80, height: 40)

                        Text("OK")
                            .font(.callout)
                            .foregroundColor(.black)
                            .fontWeight(.heavy)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .animation(.default)
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
