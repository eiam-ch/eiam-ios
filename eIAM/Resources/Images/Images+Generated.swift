// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import SwiftUI
import UIKit

// swiftlint:disable superfluous_disable_command file_length implicit_return

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
extension UIImage {
    static var icCheck: UIImage { UIImage.m("icCheck")! }
    static var icChevron: UIImage { UIImage.m("icChevron")! }
    static var icClose: UIImage { UIImage.m("icClose")! }
    static var icDiagnose: UIImage { UIImage.m("icDiagnose")! }
    static var icExternalLink: UIImage { UIImage.m("icExternalLink")! }
    static var icInfo: UIImage { UIImage.m("icInfo")! }
    static var icSchweiz: UIImage { UIImage.m("icSchweiz")! }
    static var logo: UIImage { UIImage.m("logo")! }
}

// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
extension Image {
    static var icCheck: Image { Image.m("icCheck")! }
    static var icChevron: Image { Image.m("icChevron")! }
    static var icClose: Image { Image.m("icClose")! }
    static var icDiagnose: Image { Image.m("icDiagnose")! }
    static var icExternalLink: Image { Image.m("icExternalLink")! }
    static var icInfo: Image { Image.m("icInfo")! }
    static var icSchweiz: Image { Image.m("icSchweiz")! }
    static var logo: Image { Image.m("logo")! }
}

// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

extension UIImage {
    static func m(_ name: String) -> UIImage? {
        UIImage(named: name, in: nil, compatibleWith: nil)
    }
}

extension Image {
    static func m(_ name: String) -> Image? {
        Image(name)
    }
}
