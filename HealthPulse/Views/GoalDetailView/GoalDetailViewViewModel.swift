//
//  GoalDetailViewViewModel.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 15.04.24.
//

import Foundation
import SwiftData
import WidgetKit
import BackgroundTasks

class GoalDetailViewViewModel: ObservableObject {
    
    private var healthDataManager: HealthDataManager
    private let healthGoalsPath = FileManager.documentsDirectory.appendingPathComponent("HealthGoals")
    private let backgroundTaskIdentifier = "updateData"
    private let backgroundTaskHours = stride(from: 4, to: 44, by: 4)

    @Published var healthGoals: [HealthGoal]
    @Published var selectedHealthGoal: HealthGoal
    @Published var numberString: String = ""
    @Published var showGoalMissing: Bool = true
    @Published var showMenuSheet: Bool = false
    @Published var noDataFound: Bool = false

    init(healthDataManager: HealthDataManager = HealthDataManager()) {
        self.healthDataManager = healthDataManager
        self.healthGoals = []
        self.selectedHealthGoal = HealthGoal(title: "Goal", goalType: .running, startDate: Date.firstDayOfTheYear, endDate: Date.lastDayOfTheYear, doneUnits: 0, goalUnits: 100, unitSelection: .kilometers, actualProgress: 0, expectedProgress: 0, expectedUnits: 0, data: [], graphType: .circle, colorSet: .gray)
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
        let defaultGoalData = createSampleData(startDay: Date.firstDayOfTheYear, numberOfDays: 250, averageUnits: 8, averageTimeBetweenDataPoints: 3)
        let defaultGoal = HealthGoal(title: "Goal", goalType: .running, startDate: Date.firstDayOfTheYear, endDate: Date.lastDayOfTheYear, doneUnits: 0, goalUnits: 100, unitSelection: .kilometers, actualProgress: 0, expectedProgress: 0, expectedUnits: 0, data: defaultGoalData, graphType: .circle, colorSet: .gray)
        do {
            let data = try Data(contentsOf: healthGoalsPath)
            healthGoals = try JSONDecoder().decode([HealthGoal].self, from: data)
        } catch {
            addData(healtGoal: defaultGoal)
        }
        selectedHealthGoal = healthGoals.first(where: { $0.goalType == .running }) ?? defaultGoal
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
        } catch {
            print("Unable to save data.")
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
        noDataFound = (selectedHealthGoal.data.isEmpty || selectedHealthGoal.doneUnits == 0.0) ? true : false
    }
    
    private func saveToUserDefaults() {
        UserDefaults(suiteName: "group.lmg.runningGoal")!.setCodableObject(selectedHealthGoal, forKey: "healthGoal")
    }
    
    func scheduleBackgroundUpdate() {
        backgroundTaskHours.forEach { hourOffset in
            let request = BGAppRefreshTaskRequest(identifier: backgroundTaskIdentifier)
            request.earliestBeginDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: Date())
            do {
                try BGTaskScheduler.shared.submit(request)
            } catch {
                print("Scheduling Error: \(error.localizedDescription)")
            }
        }
        print("Background Tasks Scheduled!")
    }
    
    private func fetchWorkouts() {
        print("fetching workouts")
        healthDataManager.fetchWorkouts(healthGoal: selectedHealthGoal, startDate: selectedHealthGoal.startDate, endDate: selectedHealthGoal.endDate) { [weak self] workouts, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching workouts: \(error.localizedDescription)")
                } else {
                    var fetchedWorkouts: [HealthDataPoint] = workouts
                    fetchedWorkouts.insert(HealthDataPoint(date: self.selectedHealthGoal.startDate, units: 0.0, unitsAcc: 0.0), at: 0)
                    fetchedWorkouts.append(HealthDataPoint(date: min(Date.now, self.selectedHealthGoal.endDate), units: 0.0, unitsAcc: fetchedWorkouts.last?.unitsAcc ?? 0.0))
                    self.selectedHealthGoal.data = fetchedWorkouts
                    self.calculateHealthGoalStatistics()
                    self.saveToUserDefaults()
                }
            }
        }
    }
    
    private func fetchDistance() {
        let fetchDistanceClosure: (Double?, Error?) -> Void = { [weak self] distance, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching distance: \(error.localizedDescription)")
                } else {
                    self?.selectedHealthGoal.doneUnits = distance ?? 0.0
                    self?.calculateHealthGoalStatistics()
                    self?.saveToUserDefaults()
                }
            }
        }
        
        switch selectedHealthGoal.unitSelection {
        case .kilometers:
            healthDataManager.fetchRunningDistanceKm(startDate: selectedHealthGoal.startDate, endDate: selectedHealthGoal.endDate, completion: fetchDistanceClosure)
        case .miles:
            healthDataManager.fetchRunningDistanceMi(startDate: selectedHealthGoal.startDate, endDate: selectedHealthGoal.endDate, completion: fetchDistanceClosure)
        }
    }
    
    private func calculateHealthGoalStatistics() {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: selectedHealthGoal.startDate)
        let endDate = calendar.startOfDay(for: selectedHealthGoal.endDate)
        let currentDate = calendar.startOfDay(for: Date())
        
        let totalDuration = calendar.dateComponents([.day], from: startDate, to: endDate).day! + 1
        let passedDuration = min(calendar.dateComponents([.day], from: startDate, to: currentDate).day! + 1, totalDuration)
        let expectedProgressPerDay = selectedHealthGoal.goalUnits / Double(totalDuration)
        
        selectedHealthGoal.actualProgress = selectedHealthGoal.doneUnits / (selectedHealthGoal.goalUnits == 0 ? 1 : selectedHealthGoal.goalUnits)
        selectedHealthGoal.expectedProgress = (expectedProgressPerDay * Double(passedDuration)) / (selectedHealthGoal.goalUnits == 0 ? 1 : selectedHealthGoal.goalUnits)
        selectedHealthGoal.expectedUnits = expectedProgressPerDay * Double(passedDuration)
    }
    
}
