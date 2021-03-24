//
//  Exercise.swift
//  One Rep Max
//
//  Created by Nick Hayward on 3/22/21.
//

import Foundation

/// A single exercise with an array of all workouts
public struct Exercise: Codable {
    public let name: String
    public var workouts: [Workout]
}
