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
    
    init(healthGoal: HealthGoal) {
        self.healthGoal = healthGoal
        differenceToExpected =  healthGoal.expectedUnits - healthGoal.doneUnits
    }
    
    var body: some View {
        VStack {
            Text("Widget Preview")
                .font(.title2)
                .bold()
            
            ZStack {
                Spacer()
                VStack {
                    if healthGoal.graphType == .circle {
                        CircleGraphView(healthGoal: healthGoal)
                    } else {
                        LineChartGraphView(healthGoal: healthGoal)
                    }
                }
                .padding(5)
                .frame(height: 80)
                .frame(maxWidth: .infinity)
                
                VStack {
                    HStack {
                        Image(systemName: "figure.run")
                            .font(.title)
                        Text(String(format: "%.0f km", healthGoal.goalUnits))
                            .bold()
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Text(String(format: "%.1f km", healthGoal.doneUnits))
                        Spacer()
                        Text(String(format: "%.1f km", differenceToExpected))
                            .foregroundColor(differenceToExpected >= 0 ? .green : .red)
                    }
                    .font(.subheadline)
                    .bold()
                    .padding(.bottom, 5)
                }
                .foregroundColor(healthGoal.colorSet.foreground)
            }
            .padding(10)
            .frame(width: 170, height: 170)
            .background(healthGoal.colorSet.background)
            .cornerRadius(20) // Rounded corners for the widget-like appearance
            //.shadow(color: .gray, radius: 5, x: 0, y: 2) // Shadow for depth
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 1) // Gray outline
            )
        }        
    }
}

#Preview {
        WidgetPreView(healthGoal: sampleHealthGoal)
}

