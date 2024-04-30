//
//  GoalDetailViewViewModel.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 15.04.24.
//

import Foundation
import SwiftData
import WidgetKit

class GoalDetailViewViewModel: ObservableObject {
    
    private var healthDataManager: HealthDataManager
    let healthGoalsPath = FileManager.documentsDirectory.appendingPathComponent("HealthGoals")

    @Published var healthGoals: [HealthGoal]
    @Published var selectedHealthGoal: HealthGoal
    @Published var numberString: String = ""
    @Published var showGoalMissing: Bool = true
    @Published var showMenuSheet: Bool = false

    init(healthDataManager: HealthDataManager = HealthDataManager()) {
        self.healthDataManager = healthDataManager
        self.healthGoals = []
        self.selectedHealthGoal = HealthGoal(title: "Goal", goalType: .running, startDate: Date(), endDate: Date(), doneUnits: 0, goalUnits: 0, unitSelection: .kilometers, actualProgress: 0, expectedProgress: 0, expectedUnits: 0, data: [], graphType: .circle, colorSet: .black)
        loadHealthGoals()
    }
}

// #MARK: FUNCTIONS

extension GoalDetailViewViewModel {
    
    func updateData() {
        if let index = healthGoals.firstIndex(where: {$0.id == selectedHealthGoal.id}) {
            healthGoals[index] = selectedHealthGoal.updateCompletion()
        } else {
            print("Error while updating")
        }
        save()
        updateGoalMissingView()
        updateHealthGoals()
    }
}

// #MARK: PRIVATE FUNCTIONS

extension GoalDetailViewViewModel {
    
    private func loadHealthGoals() {
        let defaultGoal = HealthGoal(title: "Goal", goalType: .running, startDate: Date(), endDate: Date(), doneUnits: 0, goalUnits: 0, unitSelection: .kilometers, actualProgress: 0, expectedProgress: 0, expectedUnits: 0, data: [], graphType: .circle, colorSet: .black)
        do {
            let data = try Data(contentsOf: healthGoalsPath)
            healthGoals = try JSONDecoder().decode([HealthGoal].self, from: data)
        } catch {
            addData(healtGoal: defaultGoal)
        }
        selectedHealthGoal = healthGoals.first(where: { $0.goalType == .running }) ?? defaultGoal
        print(selectedHealthGoal.colorSet)
        updateData()
    }
    
    private func addData(healtGoal: HealthGoal) {
        healthGoals.append(healtGoal)
        save()
    }
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(healthGoals)
            try data.write(to: healthGoalsPath, options: [.atomicWrite, .completeFileProtection])
            print("Data saved.")
            print(selectedHealthGoal.colorSet)
        } catch {
            print("Unable to save data.")
            print(error)
        }
    }
    
    private func updateGoalMissingView() {
        if selectedHealthGoal.goalUnits == 0.0 {
            showGoalMissing = true
        } else {
            showGoalMissing = false
        }
    }
    
    private func updateHealthGoals() {
        fetchDistance()
        fetchWorkouts()
    }
    
    private func saveToUserDefaults() {
        UserDefaults(suiteName: "group.lmg.runningGoal")!.setCodableObject(selectedHealthGoal, forKey: "healthGoal")
    }
    
    private func fetchWorkouts() {
        healthDataManager.fetchWorkouts(healthGoal: selectedHealthGoal, startDate: selectedHealthGoal.startDate, endDate: selectedHealthGoal.endDate) { [weak self] workouts, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching workouts: \(error.localizedDescription)")
                } else {
                    self?.selectedHealthGoal.data = workouts
                    self?.calculateHealthGoalStatistics()
                    self?.saveToUserDefaults()
                }
            }
        }
    }
    
    private func fetchDistance() {
        if selectedHealthGoal.unitSelection == .kilometers {
            healthDataManager.fetchRunningDistanceKm(startDate: selectedHealthGoal.startDate, endDate: selectedHealthGoal.endDate) { [weak self] distance, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error fetching distance: \(error.localizedDescription)")
                    } else {
                        self?.selectedHealthGoal.doneUnits = distance
                        self?.calculateHealthGoalStatistics()
                        self?.saveToUserDefaults()
                    }
                }
            }
        } else if selectedHealthGoal.unitSelection == .miles {
            healthDataManager.fetchRunningDistanceMi(startDate: selectedHealthGoal.startDate, endDate: selectedHealthGoal.endDate) { [weak self] distance, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error fetching distance: \(error.localizedDescription)")
                    } else {
                        self?.selectedHealthGoal.doneUnits = distance
                        self?.calculateHealthGoalStatistics()
                        self?.saveToUserDefaults()
                    }
                }
            }
        }
    }
    
    private func calculateHealthGoalStatistics() {
        selectedHealthGoal.actualProgress = {
            if selectedHealthGoal.doneUnits == 0 || selectedHealthGoal.goalUnits == 0 {
                return 0.0
            } else {
                return selectedHealthGoal.doneUnits / selectedHealthGoal.goalUnits
            }
        } ()
        selectedHealthGoal.expectedProgress = {
            if selectedHealthGoal.doneUnits == 0 || selectedHealthGoal.goalUnits == 0 {
                return 0.0
            } else {
                let totalDuration = selectedHealthGoal.endDate.timeIntervalSince(selectedHealthGoal.startDate) / (60 * 60 * 24) // Convert to days
                let passedDuration = Date().timeIntervalSince(selectedHealthGoal.startDate) / (60 * 60 * 24) // Convert to days
                let expectedProgressPerDay = selectedHealthGoal.goalUnits / totalDuration
                let result = (expectedProgressPerDay * passedDuration) / selectedHealthGoal.goalUnits
                return result
            }
        } ()
        selectedHealthGoal.expectedUnits = {
            let totalDuration = selectedHealthGoal.endDate.timeIntervalSince(selectedHealthGoal.startDate) / (60 * 60 * 24) // Convert to days
               let passedDuration = Date().timeIntervalSince(selectedHealthGoal.startDate) / (60 * 60 * 24) // Convert to days
               let expectedProgressPerDay = selectedHealthGoal.goalUnits / totalDuration
            let result = (expectedProgressPerDay * passedDuration)
            return result
        } ()
    }
}
