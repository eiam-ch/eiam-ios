//
//  Spacers.swift
//  EIAM
//
//  Created by Matthias Felix on 03.02.22.
//  Copyright © 2022 Ubique Innovation AG. All rights reserved.
//

import SwiftUI

enum Padding {
    /// A padding of 5 pixels
    static let small: CGFloat = 5

    /// A padding of 16 pixels
    static let medium: CGFloat = 16

    /// A padding of 30 pixels
    static let large: CGFloat = 30
}

struct VSpacer: View {
    let height: CGFloat

    init(_ height: CGFloat) {
        self.height = height
    }

    var body: some View {
        Spacer()
            .frame(height: height)
    }
}

struct HSpacer: View {
    let width: CGFloat

    init(_ width: CGFloat) {
        self.width = width
    }

    var body: some View {
        Spacer()
            .frame(width: width)
    }
}
