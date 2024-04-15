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

    var body: some Scene {
        WindowGroup {
            GoalDetailView(vm: GoalDetailViewViewModel())
                .environmentObject(manager)
        }
    }
}
