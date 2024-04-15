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

enum GraphSelection {
  case circle
  case chart
}

struct GoalDetailView: View {

    @EnvironmentObject var manager: HealthDataManager
    @ObservedObject var vm: GoalDetailViewViewModel
    @FocusState private var focusItem: Bool
    @State private var selectedUnit: UnitSelection = .miles // Default selection
    @State private var selectedGraph: GraphSelection = .circle // Default selection
    let colorOptions: [Color] = [.red, .green, .blue, .orange, .purple]
    @State private var selectedColor: Color = .red // Initial selected color

    @State private var numberString: String = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
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
                            ZStack {
                                Text("Start")
                                    .bold()
                                    .padding(.bottom, 60)
                                DatePicker("", selection: $vm.selectedHealthGoal.startDate, in: ...vm.selectedHealthGoal.endDate, displayedComponents: .date)
                                    .onChange(of: vm.selectedHealthGoal.startDate) { _ in vm.updateData() }
                                    .labelsHidden()
                            }
                            Spacer()
                            ZStack {
                                Text("End")
                                    .bold()
                                    .padding(.bottom, 60)
                                DatePicker("", selection: $vm.selectedHealthGoal.endDate, in: vm.selectedHealthGoal.startDate...Calendar.current.date(byAdding: .year, value: 10, to: Date())!, displayedComponents: .date)
                                    .onChange(of: vm.selectedHealthGoal.endDate) { _ in vm.updateData() }
                                    .labelsHidden()
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    WidgetPreView(healthGoal: vm.selectedHealthGoal)
                    
                    VStack {
                        HStack {
                            Text("Graph")
                                .bold()
                            Spacer()
                            Picker("Graph", selection: $selectedGraph) {
                                Text("Chart").tag(GraphSelection.chart)
                                Text("Circle").tag(GraphSelection.circle)
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 200)
                        }
                        .padding(.vertical)
                        
                        HStack {
                            Text("Color")
                                .bold()
                            Spacer()
                            ForEach(colorOptions, id: \.self) { color in
                                Circle()
                                    .foregroundColor(color)
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Circle()
                                            .stroke(color, lineWidth: 7) // White stroke for all circles
                                            .opacity(color == selectedColor ? 1.0 : 0.0) // Hide stroke for non-selected
                                    )
                                    .onTapGesture {
                                        withAnimation {
                                            selectedColor = color
                                        }
                                    }
                            }
                        }
                    }
                    .padding(.bottom, 200)
     
//                    Spacer()
//                    
//                    HStack {
//                        Text(String(format: "%.3f", vm.selectedHealthGoal.doneUnits))
//                        Text("km")
//                    }
//                    Spacer()
//                    
//                    VStack {
//                        HStack {
//                            Text("goal: ")
//                            Text(String(format: "%.3f", vm.selectedHealthGoal.goalUnits))
//                        }
//                        HStack {
//                            Text("done: ")
//                            Text(String(format: "%.3f", vm.selectedHealthGoal.doneUnits))
//                        }
//                        HStack {
//                            Text("ac pr: ")
//                            Text(String(format: "%.3f", vm.selectedHealthGoal.actualProgress))
//                        }
//                        HStack {
//                            Text("ex pr: ")
//                            Text(String(format: "%.3f", vm.selectedHealthGoal.expectedProgress))
//                        }
//                        
//                    }
                }
                .ignoresSafeArea()
                .padding(.vertical, 20)
                .padding(.horizontal, 20)
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
    }
}

#Preview {
    return GoalDetailView(vm: GoalDetailViewViewModel())
}

