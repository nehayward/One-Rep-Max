//
//  Workout.swift
//  One Rep Max
//
//  Created by Nick Hayward on 3/22/21.
//

import Foundation

public struct Workout: Codable, Hashable {
    
    /// Name of exercise
    public let exerciseName: String
    
    /// Number of sets for an exercise
    public let sets: Int
    
    /// Number of repetitions
    public let repetitions: Int
    
    /// Weight or rep
    public let weight: Measurement<UnitMass>
    
    /// Date of exercise
    public let date: Date
}

extension Workout: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(exerciseName), Sets: \(sets), Reps: \(repetitions), Weight: \(weight.value) \(weight.unit.symbol), \(date.debugShort)"
    }
}

extension Date {
    var debugShort: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
}
