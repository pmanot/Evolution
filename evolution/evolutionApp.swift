//
//  evolutionApp.swift
//  evolution
//
//  Created by Purav Manot on 09/10/20.
//

import SwiftUI

@main
struct evolutionApp: App {
    var environment = Environment()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(environment)
        }
    }
}
