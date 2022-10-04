//
//  LabelType.swift
//  EIAM
//
//  Created by Matthias Felix on 19.01.22.
//  Copyright © 2022 Ubique Innovation AG. All rights reserved.
//

import Foundation
import SwiftUI
import UBUserInterface
import UIKit

private enum FontNames {
    static let regular = "Inter-Regular"
    static let semiBold = "Inter-SemiBold"
    static let light = "Inter-Light"
}

enum LabelType: UBLabelType {
    /// 16px
    case title
    /// 18px
    case titleLarge
    /// 16px
    case textRegular
    /// 16px
    case textLight
    /// 24px
    case buttonLarge

    var font: UIFont {
        switch self {
            case .title:
                return UIFont(name: FontNames.semiBold, size: 16)!
            case .titleLarge:
                return UIFont(name: FontNames.semiBold, size: 18)!
            case .textRegular:
                return UIFont(name: FontNames.regular, size: 16)!
            case .textLight:
                return UIFont(name: FontNames.light, size: 16)!
            case .buttonLarge:
                return UIFont(name: FontNames.semiBold, size: 24)!
        }
    }

    var textColor: UIColor {
        switch self {
            case .buttonLarge:
                return .eiam_FadingNight
            default:
                return .eiam_CopenBlue
        }
    }

    var lineSpacing: CGFloat {
        return 26 / 17
    }

    var letterSpacing: CGFloat? { nil }

    var isUppercased: Bool { false }

    var hyphenationFactor: Float { 1 }

    var lineBreakMode: NSLineBreakMode { .byWordWrapping }
}

// UIKit Label
class EIAMLabel: UBLabel<LabelType> {
}

// Extension for SwiftUI
extension View {
    func eiam_style(_ labelType: LabelType,
                    color: Color? = nil,
                    numberOfLines: Int? = nil,
                    textAlignment: TextAlignment = .leading) -> some View {
        return self
            .font(Font(labelType.font))
            .lineSpacing(labelType.font.pointSize * labelType.lineSpacing - labelType.font.lineHeight)
            .padding(.vertical, (labelType.font.pointSize * labelType.lineSpacing - labelType.font.lineHeight) / 2)
            .foregroundColor(color ?? Color(labelType.textColor))
            .lineLimit(numberOfLines)
            .multilineTextAlignment(textAlignment)
    }
}
