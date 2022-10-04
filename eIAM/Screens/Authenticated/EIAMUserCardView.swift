//
//  EIAMUserCardView.swift
//  eIAM
//
//  Created by Bastian Morath on 29.04.22.
//  Copyright © 2022 Ubique Innovation AG. All rights reserved.
//

import SwiftUI

struct EIAMUserCardView: View {
    @EnvironmentObject private var authenticationModel: EIAMAuthenticationModel

    var body: some View {
        ZStack(alignment: .top) {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    VSpacer(25)
                    if let firstName = authenticationModel.user.firstName, let lastName = authenticationModel.user.lastName {
                        Text(firstName + " " + lastName)
                            .foregroundColor(Color.eiam_OxfordBlue)
                            .eiam_style(.title)
                    } else {
                        Text("Name: -")
                            .foregroundColor(Color.eiam_OxfordBlue)
                            .eiam_style(.title)
                    }
                    if let email = authenticationModel.user.email {
                        Text(email)
                            .eiam_style(.textLight)
                    } else {
                        Text("Email: -")
                            .eiam_style(.textLight)
                    }
                    VSpacer(24)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(20)

                EIAMCapsuleButton(text: UBLocalized.authenticated_logout_button_title) {
                    authenticationModel.logout()
                }
                .offset(x: 0, y: 24)
            }
            EIAMCircleView(configuration: .text(StagingEnvironment.current.description))
                .offset(x: 0, y: -30)
        }
        .padding(.top, 30)
        .padding(.bottom, 24)
    }
}

struct EIAMUserCardView_Previews: PreviewProvider {
    static var previews: some View {
        EIAMUserCardView()
    }
}
