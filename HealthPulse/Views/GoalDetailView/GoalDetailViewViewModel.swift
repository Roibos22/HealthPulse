//
//  GoalDetailViewViewModel.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 15.04.24.
//

import Foundation
import SwiftData

class GoalDetailViewViewModel: ObservableObject {
    
    private var healthDataManager: HealthDataManager

    @Published var healthGoals: [HealthGoal]
    @Published var selectedHealthGoal: HealthGoal
    
    let healthGoalsPath = FileManager.documentsDirectory.appendingPathComponent("HealthGoals")

    init(healthDataManager: HealthDataManager = HealthDataManager()) {
        self.healthDataManager = healthDataManager
        self.healthGoals = []
        self.selectedHealthGoal = HealthGoal(title: "Goal", goalType: .running, startDate: Date(), endDate: Date(), doneUnits: 0, goalUnits: 0, actualProgress: 0, expectedProgress: 0, expectedUnits: 0, data: [])
        loadHealthGoals()
    }
    
    func loadHealthGoals() {
        let defaultGoal = HealthGoal(title: "Goal", goalType: .running, startDate: Date(), endDate: Date(), doneUnits: 0, goalUnits: 0, actualProgress: 0, expectedProgress: 0, expectedUnits: 0, data: [])
        do {
            let data = try Data(contentsOf: healthGoalsPath)
            healthGoals = try JSONDecoder().decode([HealthGoal].self, from: data)
        } catch {

            addData(healtGoal: defaultGoal)
        }
        selectedHealthGoal = healthGoals.first(where: { $0.goalType == .running }) ?? defaultGoal
        updateData()
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(healthGoals)
            try data.write(to: healthGoalsPath, options: [.atomicWrite, .completeFileProtection])
            print("Data saved.")
        } catch {
            print("Unable to save data.")
            print(error)
        }
    }
    
    func addData(healtGoal: HealthGoal) {
        healthGoals.append(healtGoal)
        save()
    }
    
    func updateData() {
        if let index = healthGoals.firstIndex(where: {$0.id == selectedHealthGoal.id}) {
            healthGoals[index] = selectedHealthGoal.updateCompletion()
        } else {
            print("Error while updating")
        }
        save()
        updateHealthGoals()
    }
    
    //
    
    func updateHealthGoals() {
        fetchWorkouts()
        fetchDistance()
        calculateHealthGoalStatistics()
    }
    
    func fetchWorkouts() {
        healthDataManager.fetchWorkouts(startDate: selectedHealthGoal.startDate, endDate: selectedHealthGoal.endDate) { [weak self] workuts, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching workouts: \(error.localizedDescription)")
                } else {
                    self?.selectedHealthGoal.data = workuts
                }
            }
        }
    }
    
    func fetchDistance() {
        healthDataManager.fetchRunningDistance(startDate: selectedHealthGoal.startDate, endDate: selectedHealthGoal.endDate) { [weak self] distance, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching distance: \(error.localizedDescription)")
                } else {
                    self?.selectedHealthGoal.doneUnits = distance
                }
            }
        }
    }
    
    func calculateHealthGoalStatistics() {
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
