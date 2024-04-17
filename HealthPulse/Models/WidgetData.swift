//
//  WidgetData.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 17.04.24.
//

import Foundation
import SwiftUI

enum WidgetColorSet: String, Codable {
    case white
    case gray
    case black
    case blue
    case yellow
    case red
    
    var background: Color {
        switch self {
        case .white: return Color(hex: "FFFFFF")
        case .gray: return Color(hex: "2C2C2E")
        case .black: return Color(hex: "000000")
        case .blue: return Color(hex: "2C7DA0")
        case .yellow: return Color(hex: "FFBE0B")
        case .red: return Color(hex: "AE2012")
        }
    }
    
    var foreground: Color {
        switch self {
        case .white: return Color(hex: "000000")
        case .gray: return Color(hex: "FFFFFF")
        case .black: return Color(hex: "FFFFFF")
        case .blue: return Color(hex: "000000")
        case .yellow: return Color(hex: "000000")
        case .red: return Color(hex: "000000")
        }
    }
    
    var positive: Color {
        switch self {
        case .white: return Color(hex: "4cd964")
        case .gray: return Color(hex: "4cd964")
        case .black: return Color(hex: "4cd964")
        case .blue: return Color(hex: "4cd964")
        case .yellow: return Color(hex: "4cd964")
        case .red: return Color(hex: "4cd964")
        }
    }
    
    var negative: Color {
        switch self {
        case .white: return Color(hex: "ff3b30")
        case .gray: return Color(hex: "ff3b30")
        case .black: return Color(hex: "ff3b30")
        case .blue: return Color(hex: "ff3b30")
        case .yellow: return Color(hex: "ff3b30")
        case .red: return Color(hex: "ff3b30")
        }
    }
}
let widgetColorSets: [WidgetColorSet] = [.white, .gray, .black, .blue, .yellow, .red]
