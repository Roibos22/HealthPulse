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
        case .white: return widgetBackroundColorWhite
        case .gray: return widgetBackroundColorGray
        case .black: return widgetBackroundColorBlack
        case .blue: return widgetBackroundColorBlue
        case .yellow: return widgetBackroundColorYellow
        case .red: return widgetBackroundColorRed
        }
    }
    
    var foreground: Color {
        switch self {
        case .white: return widgetForegroundColorBlack
        case .gray: return widgetForegroundColorWhite
        case .black: return widgetForegroundColorWhite
        case .blue: return widgetForegroundColorBlack
        case .yellow: return widgetForegroundColorBlack
        case .red: return widgetForegroundColorBlack
        }
    }
    
    var positive: Color {
        switch self {
        case .white: return widgetForegroundColorGreen
        case .gray: return widgetForegroundColorGreen
        case .black: return widgetForegroundColorGreen
        case .blue: return widgetForegroundColorGreen
        case .yellow: return widgetForegroundColorGreenDark
        case .red: return widgetForegroundColorGreen
        }
    }
    
    var negative: Color {
        switch self {
        case .white: return widgetForegroundColorRed
        case .gray: return widgetForegroundColorRed
        case .black: return widgetForegroundColorRed
        case .blue: return widgetForegroundColorRed
        case .yellow: return widgetForegroundColorRedDark
        case .red: return widgetBackroundColorYellow
        }
    }
}
let widgetColorSets: [WidgetColorSet] = [.white, .gray, .black, .blue, .yellow, .red]
