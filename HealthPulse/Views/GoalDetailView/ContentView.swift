//
//  ContentView.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 15.04.24.
//

import SwiftUI
import WidgetKit

struct GoalDetailView: View {
    @EnvironmentObject var manager: HealthDataManager
    @ObservedObject var vm: GoalDetailViewViewModel
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    GoalSetupView(vm: vm)
                    if (vm.showGoalMissing) {
                        goalMissingView
                    } else {
                        Text("Widget Preview")
                            .font(.title2)
                            .bold()
                        WidgetPreView(healthGoal: vm.selectedHealthGoal)
                            .padding(10)
                            .frame(width: UIScreen.widgetWidth, height: UIScreen.widgetWidth)
                            .background(vm.selectedHealthGoal.colorSet.background)
                            .cornerRadius(20)
                        WidgetSetupView(vm: vm)
                    }
                }
                .ignoresSafeArea()
                .padding(.vertical, 20)
                .padding(.horizontal, 30)
            }
            .background(colorScheme == .dark ? backgroundColorDark : backgroundColorLight)
            .navigationTitle("Your Running Goal")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        vm.showMenuSheet.toggle()
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                }
            }
        }
        .sheet(isPresented: $vm.showMenuSheet) {
              MenuView()
                .padding()
        }
        .onAppear {
            vm.numberString = vm.selectedHealthGoal.goalUnits.trimmedString()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
}

extension GoalDetailView {
    var goalMissingView: some View {
        ZStack {
            Circle()
                .frame(width: 200)
                .opacity(0.2)
            VStack(alignment: .center) {
                Image(systemName: "calendar.badge.plus")
                    .font(.largeTitle)
                Text("Please enter goal information")
                    .multilineTextAlignment(.center)
                    .bold()
                    .padding(5)
            }
            .frame(width: 200)
        }
    }
}

#Preview {
    NavigationView {
        GoalDetailView(vm: GoalDetailViewViewModel())
    }
}

