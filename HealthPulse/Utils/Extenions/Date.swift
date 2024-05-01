//
//  Date.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 01.05.24.
//

import Foundation

extension Date {
    
    static var firstDayOfTheYear: Date {
        let calendar = Calendar.current
        let yearComponent = calendar.dateComponents([.year], from: Date())
        var firstDayComponents = DateComponents()
        firstDayComponents.year = yearComponent.year
        firstDayComponents.month = 1
        firstDayComponents.day = 1
        return calendar.date(from: firstDayComponents) ?? Date()
    }
    
    static var lastDayOfTheYear: Date {
        let calendar = Calendar.current
        let yearComponent = calendar.dateComponents([.year], from: Date())
        var lastDayComponents = DateComponents()
        lastDayComponents.year = yearComponent.year
        lastDayComponents.month = 12
        lastDayComponents.day = 31
        return calendar.date(from: lastDayComponents) ?? Date()
    }
}
