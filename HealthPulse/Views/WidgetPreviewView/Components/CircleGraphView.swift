//
//  CircleGraphView.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 17.04.24.
//

import Foundation
import SwiftUI

struct CircleGraphView: View {
    let healthGoal: HealthGoal
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
                .foregroundColor(healthGoal.colorSet.negative)
                .rotationEffect(Angle(degrees: -90))
            
            Circle()
                .trim(from: 0.0, to: healthGoal.actualProgress)
                .stroke(style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .foregroundColor(healthGoal.colorSet.positive)
                .rotationEffect(Angle(degrees: -90))
            
            Text(String(format: "%.0f%%", healthGoal.actualProgress * 100))
                .foregroundColor(healthGoal.colorSet.foreground)

        }
    }
}

#Preview {
    WidgetPreView(healthGoal: sampleHealthGoal)
}
