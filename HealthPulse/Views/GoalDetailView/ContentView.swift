//
//  ContentView.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 15.04.24.
//

import SwiftUI

enum UnitSelection {
  case miles
  case kilometers
}

struct GoalDetailView: View {

    @EnvironmentObject var manager: HealthDataManager
    @ObservedObject var vm: GoalDetailViewViewModel
    @FocusState private var focusItem: Bool
    @State private var selectedUnit: UnitSelection = .miles // Default selection

    @State private var numberString: String = ""

    var body: some View {
        NavigationView {
            ScrollView {

                // Goal Information
                VStack {
                    
                    HStack {
                        Spacer()
                        HStack{
                            TextField("Enter Goal", text: $numberString)
                              .keyboardType(.decimalPad) // Optional: Set keyboard for decimals
                              .focused($focusItem)
                              .frame(width: 120)
                              .padding(5) // Add some padding between text and border
                              .background(
                                RoundedRectangle(cornerRadius: 8) // Set corner radius
                                  .fill(Color.gray.opacity(0.2)) // Set background color and opacity
                              )
                              .multilineTextAlignment(.center) // Center the text
                        }
                        Spacer()
                        HStack {
                            Picker("Unit", selection: $selectedUnit) {
                                Text("mi").tag(UnitSelection.miles)
                                Text("km").tag(UnitSelection.kilometers)
                              }
                            .pickerStyle(.segmented)
                            .frame(width: 120)
                        }
                        Spacer()
                    }
                    .padding(.bottom, 10)

                    HStack(alignment: .center) {
                        Spacer()
                        VStack {
                            Text("Start")
                                .bold()
                            DatePicker("", selection: $vm.selectedHealthGoal.startDate, in: ...vm.selectedHealthGoal.endDate, displayedComponents: .date)
                                .onChange(of: vm.selectedHealthGoal.startDate) { _ in vm.updateData() }
                                .labelsHidden()
                        }
                        Spacer()
                        VStack {
                            Text("End")
                                .bold()
                            DatePicker("", selection: $vm.selectedHealthGoal.endDate, in: vm.selectedHealthGoal.startDate...Calendar.current.date(byAdding: .year, value: 10, to: Date())!, displayedComponents: .date)
                                .onChange(of: vm.selectedHealthGoal.endDate) { _ in vm.updateData() }
                                .labelsHidden()
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 20)
                VStack {
                    Text("Widget Preview")
                        .font(.title2)
                        .bold()
                    WidgetPreView(healthGoal: vm.selectedHealthGoal)
                }
                .padding(.vertical)
                
                
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
            .navigationTitle("Your Running Goal")
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
    return GoalDetailView(vm: GoalDetailViewViewModel())
}

