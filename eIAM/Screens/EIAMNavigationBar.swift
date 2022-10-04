//
//  EIAMNavigationBar.swift
//  eIAM
//
//  Created by Bastian Morath on 29.04.22.
//  Copyright © 2022 Ubique Innovation AG. All rights reserved.
//

import SwiftUI

struct EIAMNavigationBar: View {
    @State private var showInfoView = false
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Spacer()
                    Image.icSchweiz
                    Spacer()
                }
                HStack {
                    Spacer()
                    Button {
                        showInfoView = true
                    } label: {
                        Image.icInfo
                            .padding(.trailing, 21)
                    }
                }
            }
            .frame(height: 45)
            .background(Color.white)
            Color.eiam_TomatoRed
                .frame(height: 4)
        }
        .sheet(isPresented: $showInfoView) {
            EIAMInformationView()
        }
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        EIAMNavigationBar()
    }
}
