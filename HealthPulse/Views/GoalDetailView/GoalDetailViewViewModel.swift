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
    let healthGoalsPath = FileManager.documentsDirectory.appendingPathComponent("HealthGoals")

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
        print("loadibng health goals")
        let defaultGoalData = createSampleData(startDay: Date.firstDayOfTheYear, numberOfDays: 250, averageUnits: 8, averageTimeBetweenDataPoints: 3)
        let defaultGoal = HealthGoal(title: "Goal", goalType: .running, startDate: Date.firstDayOfTheYear, endDate: Date.lastDayOfTheYear, doneUnits: 0, goalUnits: 100, unitSelection: .kilometers, actualProgress: 0, expectedProgress: 0, expectedUnits: 0, data: defaultGoalData, graphType: .circle, colorSet: .gray)
//        let defaultGoal = HealthGoal(title: "Goal", goalType: .running, startDate: Date.firstDayOfTheYear, endDate: Date.lastDayOfTheYear, doneUnits: 0, goalUnits: 100, unitSelection: .kilometers, actualProgress: 0, expectedProgress: 0, expectedUnits: 0, data: [], graphType: .circle, colorSet: .gray)
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
        let request1 = BGAppRefreshTaskRequest(identifier: "updateData")
        request1.earliestBeginDate = Calendar.current.date(byAdding: .hour, value: 4, to: Date())
        let request2 = BGAppRefreshTaskRequest(identifier: "updateData")
        request2.earliestBeginDate = Calendar.current.date(byAdding: .hour, value: 8, to: Date())
        let request3 = BGAppRefreshTaskRequest(identifier: "updateData")
        request3.earliestBeginDate = Calendar.current.date(byAdding: .hour, value: 12, to: Date())
        let request4 = BGAppRefreshTaskRequest(identifier: "updateData")
        request4.earliestBeginDate = Calendar.current.date(byAdding: .hour, value: 16, to: Date())
        let request5 = BGAppRefreshTaskRequest(identifier: "updateData")
        request5.earliestBeginDate = Calendar.current.date(byAdding: .hour, value: 20, to: Date())
        let request6 = BGAppRefreshTaskRequest(identifier: "updateData")
        request6.earliestBeginDate = Calendar.current.date(byAdding: .hour, value: 24, to: Date())
        let request7 = BGAppRefreshTaskRequest(identifier: "updateData")
        request7.earliestBeginDate = Calendar.current.date(byAdding: .hour, value: 28, to: Date())
        let request8 = BGAppRefreshTaskRequest(identifier: "updateData")
        request8.earliestBeginDate = Calendar.current.date(byAdding: .hour, value: 32, to: Date())
        let request9 = BGAppRefreshTaskRequest(identifier: "updateData")
        request9.earliestBeginDate = Calendar.current.date(byAdding: .hour, value: 36, to: Date())
        let request10 = BGAppRefreshTaskRequest(identifier: "updateData")
        request10.earliestBeginDate = Calendar.current.date(byAdding: .hour, value: 40, to: Date())
        do {
            try BGTaskScheduler.shared.submit(request1)
            try BGTaskScheduler.shared.submit(request2)
            try BGTaskScheduler.shared.submit(request3)
            try BGTaskScheduler.shared.submit(request4)
            try BGTaskScheduler.shared.submit(request5)
            try BGTaskScheduler.shared.submit(request6)
            try BGTaskScheduler.shared.submit(request7)
            try BGTaskScheduler.shared.submit(request8)
            try BGTaskScheduler.shared.submit(request9)
            try BGTaskScheduler.shared.submit(request10)
            print("Background Tasks Scheduled!")
        } catch(let error) {
            print("Scheduling Error: \(error.localizedDescription)")
        }
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
                    fetchedWorkouts.append(HealthDataPoint(date: Date.now, units: 0.0, unitsAcc: fetchedWorkouts.last?.unitsAcc ?? 0.0))
                    self.selectedHealthGoal.data = fetchedWorkouts
                    self.calculateHealthGoalStatistics()
                    self.saveToUserDefaults()
                }
            }
        }
        
        // TESTING:
        // selectedHealthGoal = HealthGoal(title: "", goalType: .running, startDate: Date.firstDayOfTheYear, endDate: Date.lastDayOfTheYear, doneUnits: 743, goalUnits: 1000, unitSelection: .kilometers, actualProgress: 744, expectedProgress: 0.677, expectedUnits: 677, data: data, graphType: .circle, colorSet: .gray)
        // selectedHealthGoal.data = sampleData
        // selectedHealthGoal.goalUnits = 1000
        // selectedHealthGoal.doneUnits = sampleData.last!.unitsAcc
        // selectedHealthGoal.actualProgress = sampleData.last!.unitsAcc / 100
        // selectedHealthGoal.expectedProgress =  80.8 // sampleData.last!.unitsAcc * 1.2 // 100
        // selectedHealthGoal.expectedUnits = sampleData.last!.unitsAcc * 1.2
        // calculateHealthGoalStatistics()
        // saveToUserDefaults()

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
                let totalDuration = selectedHealthGoal.endDate.timeIntervalSince(selectedHealthGoal.startDate) / (60 * 60 * 24)
                let passedDuration = Date().timeIntervalSince(selectedHealthGoal.startDate) / (60 * 60 * 24)
                let expectedProgressPerDay = selectedHealthGoal.goalUnits / totalDuration
                let result = (expectedProgressPerDay * passedDuration) / selectedHealthGoal.goalUnits
                return result
            }
        } ()
        selectedHealthGoal.expectedUnits = {
            let totalDuration = selectedHealthGoal.endDate.timeIntervalSince(selectedHealthGoal.startDate) / (60 * 60 * 24)
               let passedDuration = Date().timeIntervalSince(selectedHealthGoal.startDate) / (60 * 60 * 24)
               let expectedProgressPerDay = selectedHealthGoal.goalUnits / totalDuration
            let result = (expectedProgressPerDay * passedDuration)
            return result
        } ()
    }
}
