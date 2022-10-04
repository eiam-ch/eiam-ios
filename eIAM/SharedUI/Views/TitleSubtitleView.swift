//
//  TitleSubtitleView.swift
//  eIAM
//
//  Created by Bastian Morath on 02.05.22.
//  Copyright © 2022 Ubique Innovation AG. All rights reserved.
//

import SwiftUI

struct TitleSubtitleView: View {
    var title: String
    var subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .eiam_style(.title)
            Text(subtitle)
        }
    }
}

struct TitleSubtitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleSubtitleView(title: "This is a title", subtitle: "This is a subtitle")
    }
}
