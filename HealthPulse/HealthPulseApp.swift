//
//  HealthPulseApp.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 15.04.24.
//

import SwiftUI

@main
struct HealthPulseApp: App {
    @StateObject var manager = HealthDataManager()
    @StateObject var vm = GoalDetailViewViewModel()

    var body: some Scene {
        WindowGroup {
            GoalDetailView(vm: vm)
                .environmentObject(manager)
        }
        .backgroundTask(.appRefresh("updateData")) {
            await vm.updateData()
        }
    }
}
