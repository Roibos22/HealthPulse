//
//  HealthDataManager.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 15.04.24.
//

import Foundation
import HealthKit

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date()) - 11111
    }
    static var oneYearAgo: Date {
        Calendar.current.date(byAdding: .year, value: -1, to: now) ?? Date()
    }
}

class HealthDataManager: ObservableObject {
    
    let healthStore = HKHealthStore()
    @Published var distance: Double = 0
    
    init() {
        let distanceType = HKQuantityType(.distanceWalkingRunning)
        let workoutType = HKObjectType.workoutType()
        let healthTypes: Set = [distanceType, workoutType]
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
            } catch {
                print ("Error fetching helth data")
            }
        }
    }
    
    func fetchRunningDistanceKm(startDate: Date, endDate: Date, completion: @escaping (Double, Error?) -> Void) {
        let runningPredicate = HKQuery.predicateForWorkouts(with: .running)
        let timePredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let predicates = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, runningPredicate])
        
        let query = HKSampleQuery(sampleType: HKObjectType.workoutType(), predicate: predicates, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
            guard let workouts = results as? [HKWorkout], error == nil else {
                completion(0, error)
                return
            }
            let totalDistance = workouts.reduce(0.0) { sum, workout in
                return sum + (workout.totalDistance?.doubleValue(for: HKUnit.meterUnit(with: .kilo)) ?? 0)
            }
            completion(totalDistance, nil)
        }
        healthStore.execute(query)
    }
    
    func fetchRunningDistanceMi(startDate: Date, endDate: Date, completion: @escaping (Double, Error?) -> Void) {
        let runningPredicate = HKQuery.predicateForWorkouts(with: .running)
        let timePredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let predicates = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, runningPredicate])
        
        let query = HKSampleQuery(sampleType: HKObjectType.workoutType(), predicate: predicates, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
            guard let workouts = results as? [HKWorkout], error == nil else {
                completion(0, error)
                return
            }
            let totalDistance = workouts.reduce(0.0) { sum, workout in
                return sum + (workout.totalDistance?.doubleValue(for: HKUnit.mile()) ?? 0)
            }
            completion(totalDistance, nil)
        }
        healthStore.execute(query)
    }

    func fetchWorkouts(healthGoal: HealthGoal, startDate: Date, endDate: Date, completion: @escaping ([HealthDataPoint], Error?) -> Void) {
        let runningPredicate = HKQuery.predicateForWorkouts(with: .running)
        let timePredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let predicates = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, runningPredicate])
        let query = HKSampleQuery(sampleType: HKObjectType.workoutType(), predicate: predicates, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
                guard let workouts = results as? [HKWorkout], error == nil else {
                    completion([], error)
                    return
                }
                var accumulatedDistance = 0.0
                var healthDataPoints: [HealthDataPoint] = []
                for workout in workouts {
                    var workoutDistance = 0.0
                    if healthGoal.unitSelection == .kilometers {
                        workoutDistance = workout.totalDistance?.doubleValue(for: HKUnit.meterUnit(with: .kilo)) ?? 0.0
                    } else {
                        workoutDistance = workout.totalDistance?.doubleValue(for: HKUnit.mile()) ?? 0.0
                    }
                    accumulatedDistance += workoutDistance
                    let dataPoint = HealthDataPoint(date: workout.startDate, units: workoutDistance, unitsAcc: accumulatedDistance)
                    healthDataPoints.append(dataPoint)
                }
                completion(healthDataPoints, nil)
            }

        healthStore.execute(query)
    }
}
