//
//  EIAMAppEnvironment.swift
//  eIAM
//
//  Created by Bastian Morath on 03.05.22.
//  Copyright © 2022 Ubique Innovation AG. All rights reserved.
//

import SwiftUI

struct EIAMAppEnvironment<Content: View>: View {
    @StateObject private var authenticationViewModel = EIAMAuthenticationModel.instance

    var content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .environmentObject(authenticationViewModel)
            .eiam_style(.textRegular)
    }
}
