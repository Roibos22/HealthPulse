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
    
    @State private var showMenuSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    GoalSetupView(vm: vm)
                    WidgetPreView(healthGoal: vm.selectedHealthGoal)
                    WidgetSetupView(vm: vm)
                }
                .ignoresSafeArea()
                .padding(.vertical, 20)
                .padding(.horizontal, 20)
            }
            .navigationTitle("Your Running Goal")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showMenuSheet.toggle()
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                }
            }
        }
        
        .sheet(isPresented: $showMenuSheet) {
              SettingsView()
                .padding()
        }
        .onAppear {
            vm.numberString = String(vm.selectedHealthGoal.goalUnits)
        }
    }
}

struct GoalSetupView: View {
    @ObservedObject var vm: GoalDetailViewViewModel
    @FocusState private var focusItem: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                // ENTER GOAL UNITS TEXTFIELD
                HStack{
                    TextField("Enter Goal", text: $vm.numberString)
                        .keyboardType(.decimalPad)
                        .focused($focusItem)
                        .frame(width: 120)
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.2))
                        )
                        .multilineTextAlignment(.center)
                }
                Spacer()
                
                // GOAL UNITS SELECTOR
                HStack {
                    Picker("Unit", selection: $vm.selectedUnit) {
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
                
                // START DATE PICKER
                ZStack {
                    Text("Start")
                        .bold()
                        .padding(.bottom, 60)
                    DatePicker("", selection: $vm.selectedHealthGoal.startDate, in: ...vm.selectedHealthGoal.endDate, displayedComponents: .date)
                        .onChange(of: vm.selectedHealthGoal.startDate) { _ in vm.updateData() }
                        .labelsHidden()
                }
                Spacer()
                
                // END DATE PICKER
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

struct WidgetSetupView: View {
    @ObservedObject var vm: GoalDetailViewViewModel

    var body: some View {
        VStack {
            
            // GRAPH SELECTOR
            HStack {
                Text("Graph")
                    .bold()
                Spacer()
                Picker("Graph", selection: $vm.selectedHealthGoal.graphType) {
                    Text("Chart").tag(GraphType.lineChart)
                    Text("Circle").tag(GraphType.circle)
                }
                .pickerStyle(.segmented)
                .frame(width: 200)
            }
            .padding(.vertical)
            
            // COLOR PICKER
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
                        }
                }
            }
        }
        .padding(.bottom, 200)
    }
}

#Preview {
    NavigationView {
        GoalDetailView(vm: GoalDetailViewViewModel())
    }
}

