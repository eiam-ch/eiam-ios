//
//  EIAMApp.swift
//  eIAM
//
//  Created by Bastian Morath on 27.04.22.
//

import SwiftUI

@main
struct EIAMApp: App {
    @ObservedObject private var authenticationModel = EIAMAuthenticationModel.instance

    var body: some Scene {
        WindowGroup {
            EIAMAppEnvironment {
                ZStack {
                    Color.eiam_PaperWhite
                    VStack(spacing: 0) {
                        EIAMNavigationBar()
                        ScrollView {
                            if case .loggedIn = authenticationModel.authState {
                                EIAMAuthenticatedView()
                            } else {
                                EIAMUnauthenticatedView()
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}
