//
//  EIAMStagingEnvironmentSelectionView.swift
//  eIAM
//
//  Created by Bastian Morath on 29.04.22.
//  Copyright © 2022 Ubique Innovation AG. All rights reserved.
//

import SwiftUI

struct EIAMStagingEnvironmentSelectionView: View {
    var didSelectEnvironmentCallback: (StagingEnvironment) -> Void

    var body: some View {
        VStack {
            StagingEnvironmentButton(environment: .ref) {
                didSelectEnvironmentCallback(.ref)
            }
            StagingEnvironmentButton(environment: .abn) {
                didSelectEnvironmentCallback(.abn)
            }
            StagingEnvironmentButton(environment: .prod) {
                didSelectEnvironmentCallback(.prod)
            }
        }
    }
}

struct StagingEnvironmentButton: View {
    var environment: StagingEnvironment
    var touchUpCallback: () -> Void

    var body: some View {
        Button {
            touchUpCallback()
        } label: {
            Text(environment.description)
                .eiam_style(.buttonLarge)
                .frame(height: 80)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(20)
        }
    }
}

struct EIAMStagingEnvironmentSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        EIAMStagingEnvironmentSelectionView { _ in }
    }
}
