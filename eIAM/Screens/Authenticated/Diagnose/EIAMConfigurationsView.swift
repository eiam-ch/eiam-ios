//
//  EIAMConfigurationView.swift
//  eIAM
//
//  Created by Bastian Morath on 02.05.22.
//  Copyright © 2022 Ubique Innovation AG. All rights reserved.
//

import SwiftUI

struct EIAMConfigurationsView: View {
    @EnvironmentObject private var authenticationModel: EIAMAuthenticationModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("CONFIGURATION")
                .padding(.leading, Padding.medium)
            VSpacer(8)

            VStack(alignment: .leading, spacing: 3) {
                Group {
                    VSpacer(8)
                    TitleSubtitleView(title: "Client ID", subtitle: authenticationModel.authorizationService.configuration.clientID)
                    Divider()
                    TitleSubtitleView(title: "Client Secret", subtitle: authenticationModel.authorizationService.configuration.clientSecret)
                    Divider()
                    TitleSubtitleView(title: "Discovery", subtitle: authenticationModel.authorizationService.configuration.discovery.absoluteString)
                    Divider()
                    TitleSubtitleView(title: "Redirect URI", subtitle: authenticationModel.authorizationService.configuration.redirectURI.absoluteString)
                    VSpacer(8)
                }
                .padding(.leading, Padding.medium)
            }
            .background(Color.white)
        }
    }
}

struct EIAMConfigurationsView_Previews: PreviewProvider {
    static var previews: some View {
        EIAMConfigurationsView()
    }
}
