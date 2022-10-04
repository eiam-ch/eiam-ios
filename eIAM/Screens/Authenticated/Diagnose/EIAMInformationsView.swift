//
//  EIAMInformationsView.swift
//  eIAM
//
//  Created by Bastian Morath on 02.05.22.
//  Copyright © 2022 Ubique Innovation AG. All rights reserved.
//

import SwiftUI

struct EIAMInformationsView: View {
    @EnvironmentObject private var authenticationModel: EIAMAuthenticationModel

    var body: some View {
        if let email = authenticationModel.user.email {
            EIAMSingleEntryView(text: "User: \(email)")
        } else {
            EIAMSingleEntryView(text: "User: N/A")
        }
    }
}

struct EIAMInformationsView_Previews: PreviewProvider {
    static var previews: some View {
        EIAMInformationsView()
    }
}
