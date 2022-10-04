//
//  Token.swift
//  eIAM
//
//  Created by Bastian Morath on 02.05.22.
//  Copyright © 2022 Ubique Innovation AG. All rights reserved.
//

import Foundation

enum DecodingStrategies: String, CaseIterable {
    case raw
    case b64Decode

    var title: String {
        switch self {
            case .raw:
                return "Raw"
            case .b64Decode:
                return "Base64 Decoded"
        }
    }
}

extension Token: Hashable, Identifiable {
    var id: Self { self }
}

enum Token {
    case access(token: String)
    case refresh(token: String)
    case id(token: String)

    func decode(strategy: DecodingStrategies) -> String {
        func base64Decode(_ token: String) -> String {
            token
                .split(separator: ".")
                .map {
                    guard let decoded = String($0).base64Decoded() else { return "Unable to Decode:\n\($0)" }

                    let options: JSONSerialization.WritingOptions
                    if #available(iOS 11.0, *) {
                        options = [.prettyPrinted, .sortedKeys]
                    } else {
                        options = [.prettyPrinted]
                    }

                    guard let jsonData = decoded.data(using: .utf8),
                          let dict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                          let data = try? JSONSerialization.data(withJSONObject: dict, options: options)
                    else {
                        return decoded
                    }
                    return String(data: data, encoding: .utf8) ?? decoded
                }
                .joined(separator: "\n\n")
        }
        switch self {
            case let .access(token: token):
                switch strategy {
                    case .raw:
                        return token
                    case .b64Decode:
                        return base64Decode(token)
                }
            case let .refresh(token: token):
                switch strategy {
                    case .raw:
                        return token
                    case .b64Decode:
                        return base64Decode(token)
                }
            case let .id(token: token):
                switch strategy {
                    case .raw:
                        return token
                    case .b64Decode:
                        return base64Decode(token)
                }
        }
    }
}
