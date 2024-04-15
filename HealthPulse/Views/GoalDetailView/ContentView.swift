//
//  ContentView.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 15.04.24.
//

import SwiftUI

struct GoalDetailView: View {

    @EnvironmentObject var manager: HealthDataManager
    @ObservedObject var vm: GoalDetailViewViewModel
    @FocusState private var focusItem: Bool

    @State private var numberString: String = ""

    var body: some View {
        NavigationView {
            ScrollView {
                    VStack {
                        HStack {
                            Text("Goal")
                            Spacer()
                            TextField("Goal", text: $numberString)
                                .keyboardType(.decimalPad) // Optional: Set keyboard for decimals
                                .focused($focusItem)
                                .frame(width: 50)
                        }
                        
                            
                        DatePicker(selection: $vm.selectedHealthGoal.startDate, in: ...vm.selectedHealthGoal.endDate, displayedComponents: .date) { Text("Start") }
                            .onChange(of: vm.selectedHealthGoal.startDate) { _ in
                                vm.updateData()
                            }
                        DatePicker(selection: $vm.selectedHealthGoal.endDate, in: vm.selectedHealthGoal.startDate...Calendar.current.date(byAdding: .year, value: 10, to: Date())!, displayedComponents: .date) { Text("End") }
                            .onChange(of: vm.selectedHealthGoal.endDate) { _ in
                                vm.updateData()
                            }
                    }
                    .frame(width: 300)
                
                
                WidgetPreView(healthGoal: vm.selectedHealthGoal)
                
                Spacer()
                
                HStack {
                    Text(String(format: "%.3f", vm.selectedHealthGoal.doneUnits))
                    Text("km")
                }
                Spacer()
                
                VStack {
                    HStack {
                        Text("goal: ")
                        Text(String(format: "%.3f", vm.selectedHealthGoal.goalUnits))
                    }
                    HStack {
                        Text("done: ")
                        Text(String(format: "%.3f", vm.selectedHealthGoal.doneUnits))
                    }
                    HStack {
                        Text("ac pr: ")
                        Text(String(format: "%.3f", vm.selectedHealthGoal.actualProgress))
                    }
                    HStack {
                        Text("ex pr: ")
                        Text(String(format: "%.3f", vm.selectedHealthGoal.expectedProgress))
                    }

                }
            }
            .navigationTitle("Running Goal")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        focusItem = false
                        vm.selectedHealthGoal.goalUnits = Double(numberString) ?? 0.0
                        vm.updateData()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Load") {
                        vm.loadHealthGoals()
                    }
                }
            }
        }
        .onAppear {
            //vm.loadHealthGoals()
            numberString = String(vm.selectedHealthGoal.goalUnits)
            //vm.updateData()
        }
        .padding()
    }
}

#Preview {
    let manager = HealthDataManager()
    return GoalDetailView(vm: GoalDetailViewViewModel())
                //.environmentObject(manager)
}

