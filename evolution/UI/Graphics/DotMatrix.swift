//
//  DotMatrix.swift
//  evolution
//
//  Created by Purav Manot on 26/11/20.
//

import SwiftUI

struct DotMatrix: View {
    var height: Int
    var width: Int
    init(_ width: Int = 300, _ height: Int =  500) {
        self.height = height/20
        self.width = width/20
    }
    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 0) {
                ForEach(0..<height, id: \.self){ n in
                    HStack(spacing: 0) {
                        ForEach(0..<width, id: \.self){ n in
                            Circle()
                                .frame(width: 1.5, height: 1.5)
                                .padding(13.5)
                        }
                    }
                }
            }
            .drawingGroup()
        }
    }
}

struct DotMatrix_Previews: PreviewProvider {
    static var previews: some View {
        DotMatrix()
    }
}
