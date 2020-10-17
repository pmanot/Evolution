//
//  EnvironmentView.swift
//  evolution
//
//  Created by Purav Manot on 17/10/20.
//

import SwiftUI

struct EnvironmentView: View {
    @EnvironmentObject var env: Environment
    var body: some View {
        GeometryReader { frame in
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .overlay(RoundedRectangle(cornerRadius: 8).foregroundColor(.black))
                FoodView()
            }
            .onAppear{
                env.bounds = Bounds(left: 10, right: frame.size.width - 10, up: 10, down: frame.size.height - 10)
            }
        }
        
    }
}

struct EnvironmentView_Previews: PreviewProvider {
    static var previews: some View {
        EnvironmentView()
            .environmentObject(Environment())
    }
}
