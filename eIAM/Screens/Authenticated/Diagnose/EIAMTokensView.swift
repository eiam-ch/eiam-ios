//
//  EIAMTokensView.swift
//  eIAM
//
//  Created by Bastian Morath on 02.05.22.
//  Copyright © 2022 Ubique Innovation AG. All rights reserved.
//

import SwiftUI

struct EIAMTokensView: View {
    @EnvironmentObject private var authenticationModel: EIAMAuthenticationModel

    @State private var clickedToken: Token?
    @State private var showTokenInfo = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("TOKENS")
                .padding(.leading, Padding.medium)
            VSpacer(8)

            VStack(alignment: .leading, spacing: 3) {
                switch authenticationModel.authState {
                    case let .loggedIn(tokens: tokens):
                        Group {
                            VSpacer(8)
                            TitleSubtitleButton(title: "Access-Token", subtitle: tokens.accessToken ?? "N/A") {
                                clickedToken = Token.access(token: tokens.accessToken ?? "N/A")
                                showTokenInfo = true
                            }
                            Divider()
                            TitleSubtitleButton(title: "Refresh-Token", subtitle: tokens.refreshToken ?? "N/A") {
                                clickedToken = Token.refresh(token: tokens.refreshToken ?? "N/A")
                                showTokenInfo = true
                            }
                            Divider()
                            TitleSubtitleButton(title: "ID-Token", subtitle: tokens.idToken ?? "N/A") {
                                clickedToken = Token.id(token: tokens.idToken ?? "N/A")
                                showTokenInfo = true
                            }
                            VSpacer(8)
                        }
                        .padding(.leading, Padding.medium)
                        .padding(.trailing, Padding.medium)
                    case let .error(message: message):
                        EIAMSingleEntryView(text: message)
                    default:
                        EmptyView()
                }
            }
            .background(Color.white)
        }
        .sheet(item: $clickedToken, content: { token in
            EIAMTokenDetailView(token: token)
        })
    }
}

private struct TitleSubtitleButton: View {
    var title: String
    var subtitle: String
    var touchUpCallback: () -> Void

    var body: some View {
        Button {
            touchUpCallback()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(title)
                        .eiam_style(.title)
                    Text(subtitle)
                        .lineLimit(4)
                    VSpacer(4)
                }
                Spacer()
                Image.icChevron
                    .renderingMode(.template)
                    .foregroundColor(Color.eiam_CopenBlue)
            }
        }
    }
}

struct EIAMTokensView_Previews: PreviewProvider {
    static var previews: some View {
        EIAMTokensView()
    }
}
