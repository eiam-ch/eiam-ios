import AppAuth
import Foundation

/// a wrapper object to make the OIDAuthState codable
struct CodableAuthState: Codable {
    public var authState: OIDAuthState?

    public init() {
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        if let data = try? container.decode(Data.self),
           let authState = NSKeyedUnarchiver.unarchiveObject(with: data) as? OIDAuthState {
            self.authState = authState
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        if let authState = authState {
            try container.encode(NSKeyedArchiver.archivedData(withRootObject: authState))
        }
    }
}
