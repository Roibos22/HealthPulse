//
//  WidgetPreviewView.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 15.04.24.
//

import SwiftUI
import Charts

struct CircularProgressView: View {
    let healthGoal: HealthGoal
    let actualProgressColor: Color
    let expectedProgressColor: Color
    let strokeWidth: CGFloat = 15
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: strokeWidth) // Adjust line width as needed
                .opacity(0.3) // Set background circle opacity (optional)
                .foregroundColor(Color.gray) // Adjust background circle color (optional)
            
            Circle()
                .trim(from: 0.0, to: healthGoal.expectedProgress)
                .stroke(style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .foregroundColor(expectedProgressColor)
                .rotationEffect(Angle(degrees: -90))
            
            Circle()
                .trim(from: 0.0, to: healthGoal.actualProgress)
                .stroke(style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .foregroundColor(actualProgressColor)
                .rotationEffect(Angle(degrees: -90))

        }
    }
}
struct WidgetPreView: View {
    
    var healthGoal: HealthGoal
    
    var body: some View {
        VStack {
            Text("Running Goal")
                .bold()
            Spacer()
            CircularProgressView(healthGoal: healthGoal, actualProgressColor: .green, expectedProgressColor: .red)
                .padding(5)
            HStack {
                Text(String(format: "%.1f km", healthGoal.doneUnits - healthGoal.expectedUnits))
                Spacer()
                Text(String(format: "%.1f %%", healthGoal.actualProgress * 100))
            }
            HStack {
                Text(String(format: "%.1f", healthGoal.doneUnits))
                Text("/")
                Text(String(format: "%.0f", healthGoal.goalUnits))
                Text("km")
            }
        }
        .padding()
        .frame(width: 170, height: 170)
        .background(Color(.systemBackground)) // Use system background color
        .cornerRadius(20) // Rounded corners for the widget-like appearance
        .shadow(color: .gray, radius: 5, x: 0, y: 2) // Shadow for depth
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray, lineWidth: 1) // Gray outline
        )
        .padding()
    }
}

#Preview {
        WidgetPreView(healthGoal: sampleHealthGoal)
}

