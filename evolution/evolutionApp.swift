//
//  evolutionApp.swift
//  evolution
//
//  Created by Purav Manot on 09/10/20.
//

import SwiftUI

@main
struct evolutionApp: App {
    var env = SpeciesEnvironment()
    var body: some Scene {
        WindowGroup {
            MainUI()
                .environmentObject(env)
        }
    }
}
