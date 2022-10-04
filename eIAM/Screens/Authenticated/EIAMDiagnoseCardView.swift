//
//  EIAMDiagnoseCardView.swift
//  eIAM
//
//  Created by Bastian Morath on 29.04.22.
//  Copyright © 2022 Ubique Innovation AG. All rights reserved.
//

import SwiftUI

struct EIAMDiagnoseCardView: View {
    @State private var showDiagnoseView = false
    @EnvironmentObject private var authenticationModel: EIAMAuthenticationModel

    var body: some View {
        ZStack(alignment: .top) {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    VSpacer(25)
                    Text(UBLocalized.authenticated_diagnose_text)
                        .multilineTextAlignment(.center)
                        .eiam_style(.textLight)
                    VSpacer(24)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(20)

                EIAMCapsuleButton(text: UBLocalized.diagnose_title) {
                    showDiagnoseView = true
                }
                .offset(x: 0, y: 24)
            }
            EIAMCircleView(configuration: .icon(.icDiagnose))
                .offset(x: 0, y: -30)
        }
        .padding(.top, 30)
        .padding(.bottom, 24)
        .sheet(isPresented: $showDiagnoseView) {
            EIAMDiagnoseView()
        }
    }
}

struct EIAMDiagnoseCardView_Previews: PreviewProvider {
    static var previews: some View {
        EIAMDiagnoseCardView()
    }
}
