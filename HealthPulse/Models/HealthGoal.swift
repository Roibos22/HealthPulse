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
    var unitsAcc: Double
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
    data: sampleDataPoints
)
