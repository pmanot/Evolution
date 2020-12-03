//
//  Settings.swift
//  evolution
//
//  Created by Purav Manot on 02/12/20.
//

import SwiftUI

struct Settings: View {
    @Environment(\.presentationMode) var showing
    @EnvironmentObject var env: SpeciesEnvironment
    @State var allowMutations: Bool = false
    var body: some View {
        ZStack {
            Color.mediumPurple
                .edgesIgnoringSafeArea(.all)
            VStack {
                Button(action: {self.showing.wrappedValue.dismiss()}) {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
                .buttonStyle(FloatingButtonStyle(.black, .black))
                .padding()
                
                Toggle(isOn: $env.allowMutations, label: {
                    Text("Mutations")
                        .fontWeight(.medium)
                        .font(.callout)
                })
                .toggleStyle(SwitchToggleStyle(tint: Color.mediumPurple.darken(0.5)))
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke()
                        .frame(width: 220, height: 45)
                )
                .padding(.vertical, 10)
                Group {
                    VStack(alignment: .leading) {
                        Text("Cell lifespan")
                            .fontWeight(.bold)
                            .font(.caption)
                        Picker("", selection: $env.cellLifespan) {
                            Text("Low").tag(Double(200))
                            Text("Medium").tag(Double(300))
                            Text("High").tag(Double(500))
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke()
                                .frame(width: 210, height: 40)
                        )
                    }
                    VStack(alignment: .leading) {
                        Text("Food generation")
                            .fontWeight(.bold)
                            .font(.caption)
                        Picker("", selection: $env.foodRate) {
                            Text("Low").tag(12)
                            Text("Medium").tag(20)
                            Text("High").tag(35)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke()
                                .frame(width: 210, height: 40)
                        )
                    }
                    VStack(alignment: .leading) {
                        Text("Reproduction rate")
                            .fontWeight(.bold)
                            .font(.caption)
                        Picker("", selection: $env.reproductionRate) {
                            Text("Low").tag(0.0005)
                            Text("Medium").tag(0.001)
                            Text("High").tag(0.002)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(
                            ZStack {
                                Color.mediumPurple
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke()
                                    .frame(width: 210, height: 40)
                            }
                        )
                    }
                }
                .padding(.vertical, 5)
                
            }
            .frame(width: 200, height: 50)
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
            .environmentObject(SpeciesEnvironment())
    }
}

struct CheckboxStyle: ToggleStyle {

    func makeBody(configuration: Self.Configuration) -> some View {

        return HStack {

            configuration.label

            Spacer()

            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(configuration.isOn ? .purple : .gray)
                .font(.system(size: 20, weight: .bold, design: .default))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }

    }
}
