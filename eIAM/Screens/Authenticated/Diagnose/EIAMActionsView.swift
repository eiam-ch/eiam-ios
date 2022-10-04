//
//  EIAMActionsView.swift
//  eIAM
//
//  Created by Bastian Morath on 02.05.22.
//  Copyright © 2022 Ubique Innovation AG. All rights reserved.
//

import SwiftUI

struct EIAMActionsView: View {
    @EnvironmentObject private var authenticationModel: EIAMAuthenticationModel

    @ObservedObject private var demoBackend = DemoBackend.instance

    @State private var userInfoIsLoading = false
    @State private var refreshTokenIsLoading = false
    @State private var testRequestIsLoading = false

    @State private var showTestRequestAlert = false
    @State private var testRequestMessage = ""

    @State private var showUserInfoErrorAlert = false
    @State private var userInfoRequestErrorString = ""

    @State private var showRefreshTokenErrorAlert = false
    @State private var refreshTokenErrorString = ""

    @State var userInfoToken: Token?

    var body: some View {
        VStack(alignment: .leading) {
            Text("ACTIONS")
                .padding(.leading, Padding.medium)
            VSpacer(8)

            VStack(alignment: .leading) {
                VSpacer(8)
                if userInfoIsLoading {
                    LoadingView()
                } else {
                    EIAMButton(title: "UserInfo Request") {
                        userInfoIsLoading = true
                        // We add an artificial delay for better UX
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            loadUserInfoToken()
                            userInfoIsLoading = false
                        }
                    }
                    .alert(isPresented: $showUserInfoErrorAlert) {
                        Alert(
                            title: Text("Error"),
                            message: Text(userInfoRequestErrorString),
                            dismissButton: .default(Text("Close"), action: {
                            })
                        )
                    }
                    .sheet(item: $userInfoToken, content: { token in
                        EIAMTokenDetailView(token: token)
                    })
                }

                Divider()
                    .padding(.leading, Padding.medium)
                if refreshTokenIsLoading {
                    LoadingView()
                } else {
                    EIAMButton(title: "Refresh Token") {
                        refreshTokenIsLoading = true
                        // We add an artificial delay for better UX
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            authenticationModel.updateAccessToken(forceRefresh: true, isDiagnose: true) { result in
                                switch result {
                                    case let .failure(error):
                                        refreshTokenErrorString = error.localizedDescription
                                        showRefreshTokenErrorAlert = true
                                    default:
                                        break
                                }
                            }
                            refreshTokenIsLoading = false
                        }
                    }
                    .alert(isPresented: $showRefreshTokenErrorAlert) {
                        Alert(
                            title: Text("Error"),
                            message: Text(refreshTokenErrorString),
                            dismissButton: .default(Text("Close"), action: {
                            })
                        )
                    }
                }

                Divider()
                    .padding(.leading, Padding.medium)
                if testRequestIsLoading {
                    LoadingView()
                } else {
                    EIAMButton(title: "Test Request") {
                        testRequestIsLoading = true
                        authenticationModel.makeTestRequest { result in
                            var messageString = ""
                            switch result {
                                case let .success(response):
                                    messageString = response.message
                                case let .failure(error):
                                    messageString = "Error: \(error.description)"
                            }
                            // We add an artificial delay for better UX
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                testRequestIsLoading = false
                                testRequestMessage = messageString
                                showTestRequestAlert = true
                            }
                        }
                    }
                    .alert(isPresented: $showTestRequestAlert) {
                        Alert(
                            title: Text("Response"),
                            message: Text(testRequestMessage),
                            dismissButton: .default(Text("Close"), action: {
                            })
                        )
                    }
                }

                VSpacer(8)
                    .alert(isPresented: $demoBackend.showReLoginPopup) {
                        Alert(
                            title: Text("Session expired"),
                            message: Text("Please log in again"),
                            primaryButton: .default(Text("Login"), action: {
                                demoBackend.reLoginPopUpCallback?(true)
                            }),
                            secondaryButton: .cancel {
                                demoBackend.reLoginPopUpCallback?(false)
                            }
                        )
                    }
            }
            .background(Color.white)
        }
    }

    private func loadUserInfoToken() {
        authenticationModel.loadUserInfo { result in
            switch result {
                case let .success(data):
                    let b64Decoded = String(data: data, encoding: .utf8)?.base64Encoded()
                    DispatchQueue.main.async {
                        userInfoToken = .access(token: b64Decoded ?? "N/A")
                    }
                case let .failure(error):
                    userInfoRequestErrorString = error.localizedDescription
                    showUserInfoErrorAlert = true
            }
        }
    }
}

private struct EIAMButton: View {
    var title: String
    var enabled: Bool = true
    var touchUpCallback: () -> Void

    var body: some View {
        Button {
            touchUpCallback()
        } label: {
            Text(title)
                .foregroundColor(enabled ? Color.eiam_FadingNight : .gray)
                .eiam_style(.titleLarge)
                .foregroundColor(Color.eiam_TomatoRed)
        }
        .disabled(!enabled)
        .padding(.leading, Padding.medium)
    }
}

private struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: Color.eiam_FadingNight))
            .padding(.leading, Padding.medium)
            .frame(height: 28)
    }
}

struct EIAMActionsView_Previews: PreviewProvider {
    static var previews: some View {
        EIAMActionsView()
    }
}
