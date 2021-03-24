//
//  DataImporter.swift
//  One Rep Max
//
//  Created by Nick Hayward on 3/22/21.
//

import Foundation

public struct DataImporter {
    
    public static var shared = DataImporter()
    
    private static let mockData: String = "WorkoutData"
    
    private static var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d yyyy"
        return formatter
    }()
    
    
    /// Get all workouts and completes on main thread by default
    /// - Parameter completion: Completes with a result of an array of `[Workout]` or an `ImportError`
    public func fetchWorkoutData(completion: @escaping (Result<[Workout], ImportError>) -> Void, on queue: DispatchQueue = .main){
        guard let workouts = parseData() else {
            queue.async {
                completion(.failure(.invalidData))
            }
            return
        }
        queue.async {
            completion(.success(workouts))
        }
    }
    
    /// Get all exercises and completes on main thread by default
    /// - Parameters:
    ///   - completion: Completes with a result of an array of `[Exercise]` sorted by name or an `ImportError`
    ///   - queue: <#queue description#>
    public func fetchExerciseData(completion: @escaping (Result<[Exercise], ImportError>) -> Void, on queue: DispatchQueue = .main){
        var exercises: [String: Exercise] = [:]

        guard let workouts = parseData() else {
            queue.async {
                completion(.failure(.invalidData))
            }
            return
        }
        
        workouts.forEach { workout in
            guard var exercise = exercises[workout.exerciseName] else {
                exercises[workout.exerciseName] = Exercise(name: workout.exerciseName, workouts: [workout])
                return
            }
            
            exercise.workouts.append(workout)
            exercises[workout.exerciseName] = exercise
        }
        
        queue.async {
            completion(.success(Array(exercises.values.sorted(by: { (a, b) -> Bool in
                a.name < b.name
            }))))
        }
    }
    
    /// Imports data from a CSV
    /// - Returns: An array of `[Workout]`
    private func parseData() -> [Workout]? {
        guard let resourceURL = Bundle.main.url(forResource: Self.mockData, withExtension: "csv"),
              let data = try? Data(contentsOf: resourceURL),
              let workoutDataCSV = String(data: data, encoding: .utf8) else { return nil }
        
        let lines = workoutDataCSV.components(separatedBy: .newlines)
        
        let workouts = lines.compactMap { line -> Workout? in
            
            let fields = line.components(separatedBy: ",")
            guard fields.count <= 5 else { return nil }
            print(fields.count)
            guard let date = Self.formatter.date(from: fields[0]) else { return nil }
            
            let exerciseName = fields[1]
            guard let sets = Int(fields[2]),
                  let repetitions = Int(fields[3]),
                  let weight = Double(fields[4]) else { return nil }
            
            let workout = Workout(exerciseName: exerciseName,
                                  sets: sets,
                                  repetitions: repetitions,
                                  weight: Measurement(value: weight, unit: UnitMass.pounds),
                                  date: date)
            return workout
        }
        
        return workouts
    }
}
