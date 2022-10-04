//
//  EIAMInformationView.swift
//  eIAM
//
//  Created by Bastian Morath on 29.04.22.
//  Copyright © 2022 Ubique Innovation AG. All rights reserved.
//

import SwiftUI

struct EIAMInformationView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var showSafari = false
    @Environment(\.openURL) var openURL

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

                Text(UBLocalized.information_title)
                    .eiam_style(.title)
                VSpacer(20)

                ScrollView(showsIndicators: false) {
                    VSpacer(18)

                    Text(UBLocalized.information_text_top)
                    VSpacer(25)
                    WebView(videoID: "6rWNYl6cgA8")
                        .frame(height: 200)
                        .cornerRadius(4)
                    VSpacer(25)

                    Text(UBLocalized.information_text_bottom)
                    HStack {
                        Button {
                            showSafari = true
                        } label: {
                            HStack(spacing: 0) {
                                Image.icExternalLink
                                Text(UBLocalized.Information_url_title)
                                    .eiam_style(.title)
                            }
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .padding(Padding.medium)
        .padding(.top, 14)
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $showSafari) {
            SafariView(url: URL(string: UBLocalized.Information_url_link)!)
        }
    }
}

struct EIAMInformationView_Previews: PreviewProvider {
    static var previews: some View {
        EIAMInformationView()
    }
}
