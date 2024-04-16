//
//  HealthGoal.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 15.04.24.
//

import Foundation
import SwiftUI

struct HealthDataPoint: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date
    var units: Double
    var unitsAcc: Double
}

enum GoalType: Codable {
    case running
}

enum GraphType: Codable {
    case circle
    case lineChart
}

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

struct HealthGoal: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var goalType: GoalType
    var startDate: Date
    var endDate: Date
    var doneUnits: Double
    var goalUnits: Double
    var actualProgress: Double
    var expectedProgress: Double
    var expectedUnits: Double
    var data: [HealthDataPoint]
    var graphType: GraphType
    var colorSet: WidgetColorSet
    
    func updateCompletion() -> HealthGoal {
        return HealthGoal(id: id, title: title, goalType: goalType, startDate: startDate, endDate: endDate, doneUnits: doneUnits, goalUnits: goalUnits, actualProgress: actualProgress, expectedProgress: expectedProgress, expectedUnits: expectedUnits, data: data, graphType: .circle, colorSet: .black)
    }
}

let sampleDataPoints: [HealthDataPoint] = [
//    HealthDataPoint(date: Date().addingTimeInterval(-86400 * 7), units: 0, unitsAcc: 0),
    HealthDataPoint(date: Date().addingTimeInterval(-86400 * 7), units: 7.500, unitsAcc: 7.500),
    HealthDataPoint(date: Date().addingTimeInterval(-86400 * 3), units: 5.600, unitsAcc: 13.100),
    HealthDataPoint(date: Date().addingTimeInterval(-86400 * 2), units: 8.300, unitsAcc: 21.400),
    HealthDataPoint(date: Date().addingTimeInterval(86400 * 1), units: 9.400, unitsAcc: 30.800)
]

let sampleHealthGoal = HealthGoal(
    title: "Daily Step Goal",
    goalType: .running,
    startDate: Date().addingTimeInterval(-86400 * 7),  // Start date 7 days ago
    endDate: Date().addingTimeInterval(86400 * 7),     // End date 7 days from now
    doneUnits: 30.8,
    goalUnits: 50.0,
    actualProgress: 0.308,
    expectedProgress: 0.3,
    expectedUnits: 30.0,
    data: sampleDataPoints, 
    graphType: .circle,
    colorSet: .black
)
