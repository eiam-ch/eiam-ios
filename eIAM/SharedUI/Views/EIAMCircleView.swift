//
//  EIAMCircleView.swift
//  eIAM
//
//  Created by Bastian Morath on 27.04.22.
//  Copyright © 2022 Ubique Innovation AG. All rights reserved.
//

import SwiftUI

struct EIAMCircleView: View {
    enum Configuration {
        case text(String)
        case icon(Image)
    }

    var configuration: Configuration

    var body: some View {
        GeometryReader { g in
            HStack {
                Spacer()
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
                    switch configuration {
                        case let .text(string):
                            Text(string)
                                .font(Font(LabelType.titleLarge.font.withSize(min(g.size.height, g.size.width) * 0.25)))
                                .eiam_style(.titleLarge)
                        case let .icon(image):
                            image
                    }
                }
                Spacer()
            }
        }
        .frame(height: 60)
    }
}

struct EIAMCircleView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EIAMCircleView(configuration: .text("PROD"))
            EIAMCircleView(configuration: .text("REF"))

            EIAMCircleView(configuration: .icon(.icSchweiz))
        }
    }
}
