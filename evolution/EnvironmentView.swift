//
//  EnvironmentView.swift
//  evolution
//
//  Created by Purav Manot on 17/10/20.
//

import SwiftUI

struct EnvironmentView: View {
    @EnvironmentObject var env: SpeciesEnvironment
    var body: some View {
        GeometryReader { frame in
            ZStack {
                FoodView()
            }
        }
    }
}

struct EnvironmentView_Previews: PreviewProvider {
    static var previews: some View {
        EnvironmentView()
            .environmentObject(SpeciesEnvironment())
    }
}
