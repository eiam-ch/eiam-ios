import Foundation

enum StagingEnvironment: Int, Codable {
    case ref, abn, prod

    @UBKeychainStored(key: "ch.eiam.selectedEnviroment", defaultValue: .ref, accessibility: .afterFirstUnlock)
    static var current: StagingEnvironment

    var configuration: EIAMConfiguration {
        switch self {
            case .ref:
                return EIAMConfiguration.ref
            case .abn:
                return EIAMConfiguration.abn
            case .prod:
                return EIAMConfiguration.prod
        }
    }

    var testRequestUrl: URL {
        switch self {
            case .ref:
                return URL(string: "https://eiam-demo-dev.ubique.ch/demo/hello")!
            case .abn:
                return URL(string: "https://eiam-demo-abn.ubique.ch/demo/hello")!
            case .prod:
                return URL(string: "https://eiam-demo-prod.ubique.ch/demo/hello")!
        }
    }

    var description: String {
        switch self {
            case .ref:
                return "REF"
            case .abn:
                return "ABN"
            case .prod:
                return "PROD"
        }
    }
}

extension EIAMConfiguration {
    static let ref = EIAMConfiguration(discovery: URL(string: "https://identity-eiam-r.eiam.admin.ch/realms/bund_bk-picardapp/")!,
                                       clientID: "BK-picardapp",
                                       clientSecret: "0c65369b-1f2e-410d-b9b5-1cd72a5e0da9",
                                       redirectURI: URL(string: "eiam://redirect/")!)

    static let abn = EIAMConfiguration(discovery: URL(string: "https://identity-eiam-a.eiam.admin.ch/realms/bund_bk-picardapp/")!,
                                       clientID: "BK-picardapp",
                                       clientSecret: "46a2c46a-8592-4f77-ab48-06fd9963ce8f",
                                       redirectURI: URL(string: "eiam://redirect/")!)

    static let prod = EIAMConfiguration(discovery: URL(string: "https://identity-eiam.eiam.admin.ch/realms/bund_bk-picardapp/")!,
                                        clientID: "BK-picardapp",
                                        clientSecret: "c43b8664-8b53-4165-8d0e-aee719b40bd7",
                                        redirectURI: URL(string: "eiam://redirect/")!)
}
