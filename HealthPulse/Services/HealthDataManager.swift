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
    
    func fetchRunningDistance(startDate: Date, endDate: Date, completion: @escaping (Double, Error?) -> Void) {
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

    func fetchWorkouts(startDate: Date, endDate: Date, completion: @escaping ([HealthDataPoint], Error?) -> Void) {
        let runningPredicate = HKQuery.predicateForWorkouts(with: .running)
        let timePredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let predicates = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, runningPredicate])
        let query = HKSampleQuery(sampleType: HKObjectType.workoutType(), predicate: predicates, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
                guard let workouts = results as? [HKWorkout], error == nil else {
                    completion([], error)
                    return
                }
                
                // Start with an empty array and a starting accumulated distance of zero
                var accumulatedDistance = 0.0
                var healthDataPoints: [HealthDataPoint] = []
                
                for workout in workouts {
                    // Calculate the distance for the current workout
                    let workoutDistance = workout.totalDistance?.doubleValue(for: HKUnit.meterUnit(with: .kilo)) ?? 0.0
                    
                    // Update the accumulated distance
                    accumulatedDistance += workoutDistance
                    
                    // Create a HealthDataPoint for the current workout with the updated accumulated distance
                    let dataPoint = HealthDataPoint(date: workout.startDate, units: workoutDistance, unitsAcc: accumulatedDistance)
                    
                    // Append the data point to the array
                    healthDataPoints.append(dataPoint)
                }
                
                // Call the completion handler with the array of HealthDataPoints with correct accumulated distance
                completion(healthDataPoints, nil)
            }
//        let query = HKSampleQuery(sampleType: HKObjectType.workoutType(), predicate: predicates, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
//            guard let workouts = results as? [HKWorkout], error == nil else {
//                completion([], error)
//                return
//            }
//            let _ = workouts.reduce(0.0) { sum, workout in
//                return sum + (workout.totalDistance?.doubleValue(for: HKUnit.meterUnit(with: .kilo)) ?? 0)
//            }
//            completion(workouts.map { workout -> HealthDataPoint in
//                return HealthDataPoint(date: workout.startDate, units: workout.totalDistance?.doubleValue(for: HKUnit.meterUnit(with: .kilo)) ?? 0.0, unitsAcc: 0.0)
//            }, error)
//        }
        healthStore.execute(query)
    }
    
    
}
