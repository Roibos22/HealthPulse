//
//  LineChartGraphView.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 17.04.24.
//

import SwiftUI
import Charts

struct LineChartGraphView: View {
    let healthGoal: HealthGoal
    
    // if today >= 75% of goal range
        // -> xscale = goal.endDate
    // else
        // -> scale = passedTime * 1.5
    
    var scaleEnd: Date!
    var scaleEndExpectedUnits: Double!

    init(healthGoal: HealthGoal) {
        self.healthGoal = healthGoal
        
        let passedTime: TimeInterval = Date().timeIntervalSince(healthGoal.startDate)
        let goalInterval: TimeInterval = healthGoal.endDate.timeIntervalSince(healthGoal.startDate)
        
        if passedTime < 0.75 * goalInterval {
            scaleEnd = healthGoal.startDate + (passedTime * 1.2) // Add time to start date
        } else {
            scaleEnd = healthGoal.endDate
        }
        
        let unitsPerDay: Double = healthGoal.goalUnits / goalInterval
        scaleEndExpectedUnits = (scaleEnd?.timeIntervalSince(healthGoal.startDate) ?? 0.0) * unitsPerDay
        
        print(scaleEndExpectedUnits)
    }
    
    
    var body: some View {
        
        VStack {
            ZStack {
                Chart(healthGoal.data) { dataPoint in
                    LineMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Units", dataPoint.unitsAcc)
                    )
                    .interpolationMethod(.monotone)
                }
                .chartXScale(domain: healthGoal.startDate ... scaleEnd)
                .chartYScale(domain: 0 ... scaleEndExpectedUnits)
                .foregroundColor(.green)
                
                Chart(healthGoal.data) { dataPoint in
                    AreaMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Units", dataPoint.unitsAcc)
                    )
                    .interpolationMethod(.monotone)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.green, .clear]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .chartXScale(domain: healthGoal.startDate ... scaleEnd)
                .chartYScale(domain: 0 ... scaleEndExpectedUnits)

                Chart() {
                    LineMark(
                        x: .value("Date", healthGoal.startDate),
                        y: .value("Units", 0.0)
                    )
                    LineMark(
                        x: .value("Date", scaleEnd),
                        y: .value("Units", scaleEndExpectedUnits)
                    )
                    
                }
                .chartXScale(domain: healthGoal.startDate ... scaleEnd)
                .chartYScale(domain: 0 ... scaleEndExpectedUnits)
                .foregroundColor(.gray).opacity(0.5)

            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .chartLegend(.hidden)
        }
    }
}


#Preview {
    WidgetPreView(healthGoal: sampleHealthGoal)
}
