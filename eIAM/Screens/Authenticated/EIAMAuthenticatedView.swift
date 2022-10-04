//
//  EIAMAuthenticatedView.swift
//  eIAM
//
//  Created by Bastian Morath on 27.04.22.
//  Copyright © 2022 Ubique Innovation AG. All rights reserved.
//

import SwiftUI

struct EIAMAuthenticatedView: View {
    @EnvironmentObject private var authenticationModel: EIAMAuthenticationModel

    @ObservedObject private var demoBackend = DemoBackend.instance

    var body: some View {
        VStack(spacing: 16) {
            VSpacer(26)
            Image.icCheck
            Text(UBLocalized.authenticated_title)
                .eiam_style(.textLight)
            EIAMUserCardView()
                .padding(.horizontal, 15)

            EIAMDiagnoseCardView()
                .padding(.horizontal, 15)
        }
        .background(Color.eiam_PaperWhite)
        .alert(isPresented: $demoBackend.showReLoginPopup) {
            Alert(
                title: Text("Session expired"),
                message: Text("Please log in again"),
                primaryButton: .default(Text("Login"), action: {
                    demoBackend.reLoginPopUpCallback?(true)
                }),
                secondaryButton: .cancel {
                    demoBackend.reLoginPopUpCallback?(false)
                }
            )
        }
    }
}

struct EIAMAuthenticatedView_Previews: PreviewProvider {
    static var previews: some View {
        EIAMAuthenticatedView()
    }
}
