//
//  GoalSetupView.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 15.04.24.
//

import SwiftUI

struct GoalSetupView: View {
    @ObservedObject var vm: GoalDetailViewViewModel
    @FocusState private var focusItem: Bool
    @State var isShowingWorkAround = true

    var body: some View {
        VStack {
            HStack {
                GoalInputField(vm: vm, focusItem: $focusItem)
                Spacer()
                UnitPicker(vm: vm)
            }
            .padding(.bottom, 10)
            DatePickers(vm: vm)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Done") {
                    focusItem = false
                    vm.selectedHealthGoal.goalUnits = Double(vm.numberString) ?? 0.0
                    vm.updateData()
                }
            }
        }
        .sheet(isPresented: $isShowingWorkAround) {
            if #available(iOS 16.4, *) {
                TemporarySheet {
                    self.isShowingWorkAround = false
                } resetCallback: {
                    self.isShowingWorkAround = false
                }
                .presentationBackground(.clear)
            } else {
                TemporarySheet {
                    self.isShowingWorkAround = false
                } resetCallback: {
                    self.isShowingWorkAround = false
                }
            }

        }
    }
}

// Needed to add this, as Apple has a bug in ToolBar visibility. This is a workaround. (https://developer.apple.com/forums/thread/736040)
struct TemporarySheet: View {
    let dismissCallback: (() -> Void)
    let resetCallback: (() -> Void)
    var body: some View {
        Text("").onAppear {
            self.dismissCallback()
        }.onDisappear {
            self.resetCallback()
        }
    }
}

struct GoalInputField: View {
    @ObservedObject var vm: GoalDetailViewViewModel
    @FocusState.Binding var focusItem: Bool

    var body: some View {
        HStack {
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
                .submitLabel(.done)
        }
    }
}

struct UnitPicker: View {
    @ObservedObject var vm: GoalDetailViewViewModel

    var body: some View {
        Picker("Unit", selection: $vm.selectedHealthGoal.unitSelection) {
            Text("mi").tag(UnitSelection.miles)
            Text("km").tag(UnitSelection.kilometers)
        }
        .pickerStyle(.segmented)
        .onChange(of: vm.selectedHealthGoal.unitSelection) { _ in vm.updateData() }
    }
}

struct DatePickers: View {
    @ObservedObject var vm: GoalDetailViewViewModel

    var body: some View {
        let calendar = Calendar.current
        let endDateExclusive = calendar.date(byAdding: .day, value: -1, to: vm.selectedHealthGoal.endDate) ?? vm.selectedHealthGoal.endDate
        let startDateExclusive = calendar.date(byAdding: .day, value: 1, to: vm.selectedHealthGoal.startDate) ?? vm.selectedHealthGoal.endDate

        HStack(alignment: .center) {
            DatePickerView(
                label: "Start",
                date: $vm.selectedHealthGoal.startDate,
                range: Date.distantPast...endDateExclusive,
                onChange: vm.updateData
            )
            Spacer()
            Image(systemName: "arrow.right")
            Spacer()
            DatePickerView(
                label: "End",
                date: $vm.selectedHealthGoal.endDate,
                range: startDateExclusive...Calendar.current.date(byAdding: .year, value: 10, to: Date())!,
                onChange: vm.updateData
            )
        }
    }
}

struct DatePickerView: View {
    let label: String
    @Binding var date: Date
    let range: ClosedRange<Date>
    let onChange: () -> Void

    var body: some View {
        ZStack {
            Text(label)
                .bold()
                .padding(.bottom, 60)
            DatePicker("", selection: $date, in: range, displayedComponents: .date)
                .onChange(of: date) { _ in onChange() }
                .labelsHidden()
        }
    }
}

#Preview {
    GoalSetupView(vm: GoalDetailViewViewModel())
}
