//
//  EIAMCapsuleButton.swift
//  eIAM
//
//  Created by Bastian Morath on 27.04.22.
//  Copyright © 2022 Ubique Innovation AG. All rights reserved.
//

import SwiftUI

struct EIAMCapsuleButton: View {
    var text: String
    var touchUpCallback: () -> Void
    var body: some View {
        Button {
            touchUpCallback()
        } label: {
            Text(text)
                .foregroundColor(.white)
                .eiam_style(.titleLarge)
                .frame(height: 48)
                .padding(.horizontal, 25)
        }
        .buttonStyle(EIAMPrimaryButtonStyle())
    }
}

struct EIAMPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(
                    cornerRadius: 48,
                    style: .continuous
                )
                .fill(configuration.isPressed ? Color.eiam_CopenBlue : Color.eiam_FadingNight)
            )
    }
}

struct EIAMCapsuleButton_Previews: PreviewProvider {
    static var previews: some View {
        EIAMCapsuleButton(text: "Login starten", touchUpCallback: {
        })
    }
}
