//
//  EIAMSingleEntryView.swift
//  eIAM
//
//  Created by Bastian Morath on 02.05.22.
//  Copyright © 2022 Ubique Innovation AG. All rights reserved.
//

import SwiftUI

struct EIAMSingleEntryView: View {
    var text: String
    var body: some View {
        HStack {
            Text(text)
                .padding(.horizontal, Padding.medium)
                .padding(.vertical, Padding.small)
            Spacer()
        }
        .frame(minHeight: 43)
        .background(Color.white)
        .frame(maxWidth: .infinity)
    }
}

struct EIAMSingleEntryView_Previews: PreviewProvider {
    static var previews: some View {
        EIAMSingleEntryView(text: "Test")
    }
}
