//
//  SettingsUI.swift
//  evolution
//
//  Created by Purav Manot on 27/10/20.
//

import SwiftUI

struct SettingsUI: View {
    @Environment(\.presentationMode) var dismiss
    @EnvironmentObject var env: SpeciesEnvironment
    var body: some View {
        ZStack {
            Text("Hello")
        }
    }
}

struct SettingsUI_Previews: PreviewProvider {
    static var previews: some View {
        SettingsUI()
            .environmentObject(SpeciesEnvironment())
    }
}
