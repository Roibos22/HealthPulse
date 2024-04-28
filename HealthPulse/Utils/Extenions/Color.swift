//
//  Date.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 17.04.24.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue:  Double(b) / 255, opacity: Double(a) / 255)
    }
}


// App Backgroubd Colors
let backgroundColorLight: Color = Color(hex: "EFEFEF")
let backgroundColorDark: Color = Color(hex: "1C1C1C")

// Widget Background Colors
let widgetBackroundColorWhite: Color = Color(hex: "FFFFFF")
let widgetBackroundColorGray: Color = Color(hex: "2C2C2E")
let widgetBackroundColorBlack: Color = Color(hex: "000000")
let widgetBackroundColorBlue: Color = Color(hex: "287090")
let widgetBackroundColorYellow: Color = Color(hex: "FFBE0B")
let widgetBackroundColorRed: Color = Color(hex: "AE2012")

// Widget Foreground Colors
let widgetForegroundColorBlack: Color = Color(hex: "000000")
let widgetForegroundColorWhite: Color = Color(hex: "FFFFFF")
let widgetForegroundColorGreen: Color = Color(hex: "4cd964")
let widgetForegroundColorGreenDark: Color = Color(hex: "009933")
let widgetForegroundColorGreenLight: Color = Color(hex: "7fff99")
let widgetForegroundColorRed: Color = Color(hex: "ff3b30")
let widgetForegroundColorRedDark: Color = Color(hex: "cc0000")
let widgetForegroundColorRedLight: Color = Color(hex: "FB5050")
let widgetForegroundColorYellow: Color = Color(hex: "FFBE0B")
