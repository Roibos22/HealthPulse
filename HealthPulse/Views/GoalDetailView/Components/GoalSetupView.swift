//
//  GoalSetupView.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 30.04.24.
//

import SwiftUI

struct GoalSetupView: View {
    @ObservedObject var vm: GoalDetailViewViewModel
    @FocusState private var focusItem: Bool
    
    var body: some View {
        VStack {
            HStack {
                HStack{
                    TextField("Enter Goal", text: $vm.numberString)
                        .keyboardType(.numberPad)
                        .focused($focusItem)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.2))
                        )
                        .multilineTextAlignment(.center)
                }
                Spacer()
                HStack {
                    Picker("Unit", selection: $vm.selectedHealthGoal.unitSelection) {
                        Text("mi").tag(UnitSelection.miles)
                        Text("km").tag(UnitSelection.kilometers)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: vm.selectedHealthGoal.unitSelection) { _ in vm.updateData() }
                }
            }
            .padding(.bottom, 10)

            HStack(alignment: .center) {
                ZStack {
                    Text("Start")
                        .bold()
                        .padding(.bottom, 60)
                    DatePicker("", selection: $vm.selectedHealthGoal.startDate, in: ...vm.selectedHealthGoal.endDate, displayedComponents: .date)
                        .onChange(of: vm.selectedHealthGoal.startDate) { _ in vm.updateData() }
                        .labelsHidden()
                }
                
                Spacer()
                Image(systemName: "arrow.right")
                Spacer()
                
                ZStack {
                    Text("End")
                        .bold()
                        .padding(.bottom, 60)
                    DatePicker("", selection: $vm.selectedHealthGoal.endDate, in: vm.selectedHealthGoal.startDate...Calendar.current.date(byAdding: .year, value: 10, to: Date())!, displayedComponents: .date)
                        .onChange(of: vm.selectedHealthGoal.endDate) { _ in vm.updateData() }
                        .labelsHidden()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    focusItem = false
                    vm.selectedHealthGoal.goalUnits = Double(vm.numberString) ?? 0.0
                    vm.updateData()
                }
            }
        }
    }
}

#Preview {
    GoalSetupView(vm: GoalDetailViewViewModel())
}
