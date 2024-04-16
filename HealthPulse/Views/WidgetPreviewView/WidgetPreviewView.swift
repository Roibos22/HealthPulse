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
            
            Text(String(format: "%.0f%%", healthGoal.actualProgress * 100))

        }
    }
}

struct ChartView: View {
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
        //.frame(width: 200, height: 200)
    }
}




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
                ChartView(healthGoal: healthGoal)
                //CircularProgressView(healthGoal: healthGoal, actualProgressColor: .green, expectedProgressColor: .red)
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
                    //.background(.blue)
                    
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
                    //.background(.blue)

                }
                
                
                
            }
            .padding(10)
            .frame(width: 170, height: 170)
            .background(Color(.systemBackground)) // Use system background color
            .cornerRadius(20) // Rounded corners for the widget-like appearance
            .shadow(color: .gray, radius: 5, x: 0, y: 2) // Shadow for depth
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray, lineWidth: 1) // Gray outline
            )
            
            VStack {
                
                
                
//                HStack {
//                    Text(String(format: "%.1f km", healthGoal.doneUnits - healthGoal.expectedUnits))
//                    Spacer()
//                    Text(String(format: "%.1f %%", healthGoal.actualProgress * 100))
//                }
                
            }
            
        }
        

    }
}

#Preview {
        WidgetPreView(healthGoal: sampleHealthGoal)
}

