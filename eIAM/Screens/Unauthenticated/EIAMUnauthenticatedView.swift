//
//  EIAMUnauthenticatedView.swift
//  eIAM
//
//  Created by Bastian Morath on 27.04.22.
//  Copyright © 2022 Ubique Innovation AG. All rights reserved.
//

import SwiftUI

struct EIAMUnauthenticatedView: View {
    @EnvironmentObject private var authenticationModel: EIAMAuthenticationModel
    @State var showEnvironmentSelection = false
    var body: some View {
        VStack(spacing: 0) {
            VSpacer(24)
            Image.logo
            Text(UBLocalized.home_title)
                .eiam_style(.textLight)
            Text(UBLocalized.home_subtitle)
                .multilineTextAlignment(.center)
                .eiam_style(.title)
            VSpacer(Padding.medium)

            Text(UBLocalized.home_description)
                .multilineTextAlignment(.center)
                .eiam_style(.textLight)
            VSpacer(Padding.medium)

            if showEnvironmentSelection {
                EIAMStagingEnvironmentSelectionView { env in
                    authenticationModel.setEnvironment(environment: env) {
                        authenticationModel.login()
                    }
                }
                .transition(.backslide)
                .animation(.easeInOut(duration: 0.2))
                if case let EIAMAuthenticationModel.AuthState.error(message) = authenticationModel.authState {
                    VSpacer(10)
                    Text(message)
                        .foregroundColor(.eiam_TomatoRed)

                        .eiam_style(.textLight)
                }
            } else {
                EIAMCapsuleButton(text: UBLocalized.home_login_button_title) {
                    showEnvironmentSelection = true
                }
            }

            Spacer()
        }

        .padding(.horizontal, Padding.large)
    }
}

private extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading)
        )
    }
}

struct EIAMUnauthenticatedView_Previews: PreviewProvider {
    static var previews: some View {
        EIAMUnauthenticatedView()
    }
}
