//
//  EIAMTokenDetailView.swift
//  eIAM
//
//  Created by Bastian Morath on 02.05.22.
//  Copyright © 2022 Ubique Innovation AG. All rights reserved.
//

import SwiftUI

struct EIAMTokenDetailView: View {
    var token: Token

    @Environment(\.presentationMode) private var presentationMode
    @State private var selectedIndex = 0

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image.icClose
            }
            .padding(.trailing, 5)
            VStack(alignment: .center) {
                VSpacer(15)

                Text("Detail")
                    .eiam_style(.title)
                VSpacer(20)

                VStack {
                    Picker("Encoding", selection: $selectedIndex, content: {
                        Text(DecodingStrategies.raw.title).tag(0)
                        Text(DecodingStrategies.b64Decode.title).tag(1)
                    })
                    .pickerStyle(SegmentedPickerStyle()) // <1>
                    ScrollView(showsIndicators: false) {
                        if selectedIndex == 0 {
                            Text(token.decode(strategy: .raw))
                        } else {
                            Text(token.decode(strategy: .b64Decode))
                        }
                    }
                }
            }
        }
        .padding(Padding.medium)
        .padding(.top, 14)
        .frame(maxWidth: .infinity)
    }
}
