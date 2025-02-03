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
                lineChart
                areaChart
                goalLineChart
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .chartLegend(.hidden)
        }
    }
    
    private var lineChart: some View {
        Chart(healthGoal.data) { dataPoint in
            LineMark(
                x: .value("Date", dataPoint.date),
                y: .value("Units", dataPoint.unitsAcc)
            )
            .interpolationMethod(.monotone)
        }
        .chartXScale(domain: healthGoal.startDate ... healthGoal.endDate)
        .chartYScale(domain: 0 ... max(healthGoal.goalUnits, healthGoal.doneUnits))
        .foregroundColor(.green)
    }
    
    private var areaChart: some View {
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
        .chartYScale(domain: 0 ... max(healthGoal.goalUnits, healthGoal.doneUnits))
    }
    
    private var goalLineChart: some View {
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
        .chartYScale(domain: 0 ... max(healthGoal.goalUnits, healthGoal.doneUnits))
        .foregroundColor(.gray).opacity(0.5)
    }
}


#Preview {
    WidgetPreView(healthGoal: sampleHealthGoal)
}
