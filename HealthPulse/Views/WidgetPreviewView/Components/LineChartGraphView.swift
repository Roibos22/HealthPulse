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
                .chartXScale(domain: healthGoal.startDate ... healthGoal.endDate)
                .chartYScale(domain: 0 ... healthGoal.goalUnits)
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
                .chartXScale(domain: healthGoal.startDate ... healthGoal.endDate)
                .chartYScale(domain: 0 ... healthGoal.goalUnits)

                Chart() {
                    LineMark(
                        x: .value("Date", healthGoal.startDate),
                        y: .value("Units", 0.0)
                    )
                    LineMark(
                        x: .value("Date", healthGoal.endDate),
                        y: .value("Units", healthGoal.goalUnits)
                    )
                    
                }
                .chartXScale(domain: healthGoal.startDate ... healthGoal.endDate)
                .chartYScale(domain: 0 ... healthGoal.goalUnits)
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
