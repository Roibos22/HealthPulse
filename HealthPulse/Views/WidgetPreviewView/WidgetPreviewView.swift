//
//  WidgetPreviewView.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 15.04.24.
//

import SwiftUI
import Charts

struct WidgetPreView: View {
    
    var healthGoal: HealthGoal
    var differenceToExpected: Double
    var betterThanExpected: Bool
    
    init(healthGoal: HealthGoal) {
        self.healthGoal = healthGoal
        differenceToExpected = healthGoal.doneUnits - healthGoal.expectedUnits
        if differenceToExpected >= 0 {
            betterThanExpected = true
        } else {
            betterThanExpected = false
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                Spacer()
                VStack {
                    if healthGoal.graphType == .circle {
                        CircleGraphView(healthGoal: healthGoal)
                    } else {
                        LineChartGraphView(healthGoal: healthGoal)
                    }
                }
                .padding(.vertical, 35)
                
                VStack {
                    HStack {
                        Image(systemName: "figure.run")
                            .font(.title2)
                        Text(String(format: "%.0f \(healthGoal.unitSelection.abbreviation)", healthGoal.goalUnits))
                            .bold()
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Text(String(format: "%.1f", healthGoal.doneUnits))
                        Spacer()
                        Text(String(format: "%.1f", differenceToExpected))
                            .foregroundColor(betterThanExpected ? healthGoal.colorSet.positive : healthGoal.colorSet.negative)
                    }
                    .bold()
                }
                .foregroundColor(healthGoal.colorSet.foreground)
            }
            .background(healthGoal.colorSet.background)
        }        
    }
}

#Preview {
        WidgetPreView(healthGoal: sampleHealthGoal)
}

