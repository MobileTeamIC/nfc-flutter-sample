//
//  AppDelegate+Extension.swift
//  Runner
//
//  Created by Tran Thai Quyen on 25/8/25.
//

import Foundation
extension AppDelegate {
    /// Convert string to boolean
    func convertToBool(_ value: String?) -> Bool {
        guard let value = value?.lowercased() else { return false }
        
        switch value {
        case "true", "1", "yes", "on":
            return true
        case "false", "0", "no", "off":
            return false
        default:
            return false
        }
    }

    func convertLanguageSdk(_ value: String?) -> String {
        guard let value = value?.lowercased() else { return "icekyc_vi" }

        switch value {
        case "icekyc_vi":
            return "icekyc_vi"
        case "icekyc_en":
            return "icekyc_en"
        default:
            return "icekyc_vi"
        }
    }
} 
