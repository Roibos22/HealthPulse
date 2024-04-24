//
//  Double.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 24.04.24.
//

import Foundation

extension Double {
    func trimmedString() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = Int.max
        formatter.groupingSeparator = ""
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
