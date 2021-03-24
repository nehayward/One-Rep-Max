//
//  Manager.swift
//  One Rep Max
//
//  Created by Nick Hayward on 3/22/21.
//

import Foundation
import UIKit

public class MathManager {
    
    public init() {
        NotificationCenter.default.addObserver(self, selector: #selector(clearCache), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    public static var shared = MathManager()
    
    private var cache = [Cache: Measurement<UnitMass>]()
    
    /// Calculate one rep max using Brzycki Formula from weight and number of repetitions, source - https://en.wikipedia.org/wiki/One-repetition_maximum 
    /// - Parameters:
    ///   - weight: Weight in pounds (lbs)
    ///   - repetitions: Number of repetitions.
    /// - Returns: One rep max weight
    public func oneRepMax(weight: Measurement<UnitMass>, repetitions: Int) -> Measurement<UnitMass> {
        let cacheValue = Cache(weight: weight, repetition: repetitions)
        
        if let max = cache[cacheValue] {
            return max
        }
        
        let maxWeight = weight.value * (36 / (37 - Double(repetitions)))
        let max = Measurement(value: maxWeight, unit: weight.unit)
        cache[cacheValue] = max
        return max
    }
    
    
    /// Calculate your the highest One Rep max from an exercise.
    /// - Parameter exercise: A single exercise
    /// - Returns: A measurement with your one rep max.
    public func calculatePersonalBest(exercise: Exercise) -> Measurement<UnitMass> {
        var oneRepMaxPR = 0.0
        var maxExerciseUnit = UnitMass.pounds

        exercise.workouts.forEach { (workout) in
            let currentPR = oneRepMax(weight: workout.weight,
                                      repetitions: workout.repetitions)
            
            if currentPR.value > oneRepMaxPR {
                oneRepMaxPR = currentPR.value
                maxExerciseUnit = currentPR.unit
            }
        }
        
        return Measurement(value: oneRepMaxPR, unit: maxExerciseUnit)
    }
    
    
    
    /// Filters all workouts to one day PR and then sorts all workouts by date in ascending order
    /// - Parameter exercise: A single exercise
    /// - Returns: An array of workouts sorted by date ascending.
    public func getUniqueWorkoutsSortedByDate(exercise: Exercise) -> [Workout] {
        
        var workouts: [Date: Workout] = [:]
        
        exercise.workouts.forEach { (workout) in
            guard let workoutForDate = workouts[workout.date] else {
                // MARK: No workout PR
                workouts[workout.date] = workout
                return
            }
            let currentPR = oneRepMax(weight: workout.weight,
                                      repetitions: workout.repetitions)
            let dateWorkoutPR =  oneRepMax(weight: workoutForDate.weight,
                                                           repetitions: workoutForDate.repetitions)
            
            if currentPR > dateWorkoutPR {
                workouts[workout.date] = workout
            }
        }
        
        return Array(workouts.values.sorted(by: { (a, b) -> Bool in
            a.date < b.date
        }))
    }
    
    // MARK: Actions
    @objc private func clearCache() {
        cache.removeAll()
    }
}

extension MathManager {
    struct Cache: Hashable {
        let weight: Measurement<UnitMass>
        let repetition: Int
    }
}
