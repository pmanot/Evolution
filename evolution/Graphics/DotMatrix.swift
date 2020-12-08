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
    var circleSize: CGFloat = 1.5
    init(_ circleSize: CGFloat = 1.5, _ width: Int = 300, _ height: Int =  500) {
        self.height = height/80
        self.width = width/80
        self.circleSize = circleSize
    }
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<height, id: \.self){ n in
                HStack(spacing: 0) {
                    ForEach(0..<width, id: \.self){ n in
                        HStack(spacing: 0) {
                            VStack(spacing: 0) {
                                Group {
                                    Image(systemName: "circle").resizable()
                                        .antialiased(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        .frame(width: circleSize, height: circleSize)
                                        .frame(width: 30, height: 30)
                                    Image(systemName: "circle").resizable()
                                        .antialiased(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        .frame(width: circleSize, height: circleSize)
                                        .frame(width: 30, height: 30)
                                    Image(systemName: "circle").resizable()
                                        .antialiased(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        .frame(width: circleSize, height: circleSize)
                                        .frame(width: 30, height: 30)
                                    Image(systemName: "circle").resizable()
                                        .antialiased(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        .frame(width: circleSize, height: circleSize)
                                        .frame(width: 30, height: 30)
                                }
                            }
                            VStack(spacing: 0) {
                                Group {
                                    Image(systemName: "circle").resizable()
                                        .antialiased(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        .frame(width: circleSize, height: circleSize)
                                        .frame(width: 30, height: 30)
                                    Image(systemName: "circle").resizable()
                                        .antialiased(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        .frame(width: circleSize, height: circleSize)
                                        .frame(width: 30, height: 30)
                                    Image(systemName: "circle").resizable()
                                        .antialiased(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        .frame(width: circleSize, height: circleSize)
                                        .frame(width: 30, height: 30)
                                    Image(systemName: "circle").resizable()
                                        .antialiased(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        .frame(width: circleSize, height: circleSize)
                                        .frame(width: 30, height: 30)
                                }
                            }
                            VStack(spacing: 0) {
                                Group {
                                    Image(systemName: "circle").resizable()
                                        .antialiased(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        .frame(width: circleSize, height: circleSize)
                                        .frame(width: 30, height: 30)
                                    Image(systemName: "circle").resizable()
                                        .antialiased(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        .frame(width: circleSize, height: circleSize)
                                        .frame(width: 30, height: 30)
                                    Image(systemName: "circle").resizable()
                                        .antialiased(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        .frame(width: circleSize, height: circleSize)
                                        .frame(width: 30, height: 30)
                                    Image(systemName: "circle").resizable()
                                        .antialiased(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        .frame(width: circleSize, height: circleSize)
                                        .frame(width: 30, height: 30)
                                }
                            }
                            VStack(spacing: 0) {
                                Group {
                                    Image(systemName: "circle").resizable()
                                        .antialiased(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        .frame(width: circleSize, height: circleSize)
                                        .frame(width: 30, height: 30)
                                    Image(systemName: "circle").resizable()
                                        .antialiased(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        .frame(width: circleSize, height: circleSize)
                                        .frame(width: 30, height: 30)
                                    Image(systemName: "circle").resizable()
                                        .antialiased(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        .frame(width: circleSize, height: circleSize)
                                        .frame(width: 30, height: 30)
                                    Image(systemName: "circle").resizable()
                                        .antialiased(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        .frame(width: circleSize, height: circleSize)
                                        .frame(width: 30, height: 30)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct DotMatrix_Previews: PreviewProvider {
    static var previews: some View {
        DotMatrix()
    }
}
