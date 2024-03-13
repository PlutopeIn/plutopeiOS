import Foundation

struct InputConfig {
    static var projectId: String {
//        guard let projectId = config(for: "740207e4a6f01a1c9c11fe9806a2c6a7"), !projectId.isEmpty else {
//            fatalError("PROJECT_ID is either not defined or empty in Configuration.xcconfig")
//        }
        let projectId = "740207e4a6f01a1c9c11fe9806a2c6a7"
        return projectId
    }

    static var sentryDsn: String? {
        return config(for: "WALLETAPP_SENTRY_DSN")
    }

    static var mixpanelToken: String? {
        return config(for: "MIXPANEL_TOKEN")
    }
    
    private static func config(for key: String) -> String? {
        return Bundle.main.object(forInfoDictionaryKey: key) as? String
    }

}

