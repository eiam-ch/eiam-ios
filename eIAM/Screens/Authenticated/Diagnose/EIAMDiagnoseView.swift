//
//  EIAMDiagnoseView.swift
//  eIAM
//
//  Created by Bastian Morath on 29.04.22.
//  Copyright © 2022 Ubique Innovation AG. All rights reserved.
//

import SwiftUI

struct EIAMDiagnoseView: View {
    @EnvironmentObject private var authenticationModel: EIAMAuthenticationModel

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image.icClose
            }
            .padding(.trailing, 21)
            .padding(.top, Padding.medium)
            VStack(alignment: .center, spacing: 20) {
                VSpacer(31)
                Text(UBLocalized.diagnose_title)
                    .eiam_style(.title)
                ScrollView(showsIndicators: false) {
                    EIAMActionsView()
                    VSpacer(31)
                    Text("Information")
                        .eiam_style(.title)
                    EIAMInformationsView()
                    VSpacer(20)
                    EIAMTokensView()
                    VSpacer(20)
                    EIAMConfigurationsView()
                    VSpacer(30)
                    Spacer()
                }
            }
        }
        .padding(.top, 14)
        .frame(maxWidth: .infinity)
        .background(Color.eiam_PaperWhite)
        .ignoresSafeArea()
    }
}

struct EIAMDiagnoseView_Previews: PreviewProvider {
    static var previews: some View {
        EIAMDiagnoseView()
    }
}
