//
//  HealthGoal.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 15.04.24.
//

import Foundation

struct HealthDataPoint: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date
    var units: Double
}

enum GoalType: Codable {
    case running
}

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
    
    func updateCompletion() -> HealthGoal {
        return HealthGoal(id: id, title: title, goalType: goalType, startDate: startDate, endDate: endDate, doneUnits: doneUnits, goalUnits: goalUnits, actualProgress: actualProgress, expectedProgress: expectedProgress, expectedUnits: expectedUnits, data: data)
    }
}

let sampleDataPoints: [HealthDataPoint] = [
    HealthDataPoint(date: Date().addingTimeInterval(-86400 * 4), units: 7500),
    HealthDataPoint(date: Date().addingTimeInterval(-86400 * 3), units: 5600),
    HealthDataPoint(date: Date().addingTimeInterval(-86400 * 2), units: 8300),
    HealthDataPoint(date: Date().addingTimeInterval(-86400 * 1), units: 9400)
]

let sampleHealthGoal = HealthGoal(
    title: "Daily Step Goal",
    goalType: .running,
    startDate: Date().addingTimeInterval(-86400 * 4),  // Start date 4 days ago
    endDate: Date().addingTimeInterval(86400 * 3),     // End date 3 days from now
    doneUnits: 100.0,
    goalUnits: 1000.0,
    actualProgress: 0.1,
    expectedProgress: 0.3,
    expectedUnits: 30.0,
    data: sampleDataPoints
)
