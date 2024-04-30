//
//  WidgetSetupView.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 30.04.24.
//

import SwiftUI


struct WidgetSetupView: View {
    @ObservedObject var vm: GoalDetailViewViewModel

    var body: some View {
        VStack {
            HStack {
                Text("Graph")
                    .bold()
                Spacer()
                Picker("Graph", selection: $vm.selectedHealthGoal.graphType) {
                    Text("Chart").tag(GraphType.lineChart)
                    Text("Circle").tag(GraphType.circle)
                }
                .pickerStyle(.segmented)
                .onChange(of: vm.selectedHealthGoal.graphType) { _ in vm.updateData() }
                .frame(width: 200)
            }
            .padding(.vertical)
            
            HStack {
                Text("Color")
                    .bold()
                Spacer()
                ForEach(widgetColorSets, id: \.self) { set in
                    Circle()
                        .foregroundColor(set.background)
                        .frame(width: 30, height: 30)
                        .overlay(
                            Image(systemName: "checkmark")
                                .foregroundColor(set.foreground)
                                .opacity(set == vm.selectedHealthGoal.colorSet ? 1.0 : 0.0)
                        )
                        .overlay(
                            Circle()
                                .stroke(set.foreground, lineWidth: 1)
                        )
                        .onTapGesture {
                            withAnimation {
                                vm.selectedHealthGoal.colorSet = set
                            }
                            vm.updateData()
                        }
                }
            }
        }
        .padding(.bottom, 200)
    }
}

#Preview {
    WidgetSetupView(vm: GoalDetailViewViewModel())
}
