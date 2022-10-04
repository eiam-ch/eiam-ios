import Foundation

extension String {
    var decodedJWT: String? {
        let components = split(separator: ".")
        if components.count == 3 {
            return String(components[1]).base64Decoded()
        } else {
            return nil
        }
    }

    var decodedJWTDict: [String: Any]? {
        guard
            let jsonString = decodedJWT,
            let data = jsonString.data(using: .utf8)
        else {
            return nil
        }

        return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    }

    func base64Encoded() -> String? {
        data(using: .utf8)?.base64EncodedString()
    }

    func base64Decoded() -> String? {
        var base64 = replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 += padding
        }

        if let data = Data(base64Encoded: base64, options: []),
           let str = String(data: data, encoding: String.Encoding.utf8) {
            return str
        }
        return nil
    }
}
