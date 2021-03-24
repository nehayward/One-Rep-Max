//
//  ExerciseViewController.swift
//  One Rep Max
//
//  Created by Nick Hayward on 3/22/21.
//

import UIKit
import SwiftUI
import SwiftUICharts
import OneRepMaxCore

class ExerciseViewController: UIViewController {

    private var exercise: Exercise
    private let mathManager: MathManager

    // MARK: UI
    private var hostingBarChartViewController: UIHostingController<BarChartView>?

    init(exercise: Exercise, mathManager: MathManager = .shared) {
        self.mathManager = mathManager
        self.exercise = exercise
        super.init(nibName: nil, bundle: nil)
        title = exercise.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setup()
        addSubviews()
        addConstraints()
    }
    
    func setup() {
        view.backgroundColor = .systemBackground

        hostingBarChartViewController = UIHostingController(rootView: createBarChart())
        hostingBarChartViewController?.view.translatesAutoresizingMaskIntoConstraints = false
    }
    

    func addSubviews() {
        guard let hostingBarChartViewController = hostingBarChartViewController else { return }
        view.addSubview(hostingBarChartViewController.view)
        addChild(hostingBarChartViewController)
        hostingBarChartViewController.didMove(toParent: self)
   
    }

    func addConstraints() {
        guard let hostingBarChartViewController = hostingBarChartViewController else { return }
        
        NSLayoutConstraint.activate([
            hostingBarChartViewController.view.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            hostingBarChartViewController.view.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            hostingBarChartViewController.view.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    private func createBarChart() -> BarChartView {
        let points: [(String, Double)] = mathManager.getUniqueWorkoutsSortedByDate(exercise: exercise) .map { (workout) -> (String, Double) in
            let max = mathManager.oneRepMax(weight: workout.weight, repetitions: workout.repetitions)
            return (workout.date.debugShort, max.value)
        }
        
        let pr = mathManager.calculatePersonalBest(exercise: exercise)
        let title = "PR \(String(format: "%.0f", pr.value)) \(pr.unit.symbol)"
        let widthMargins: CGFloat = UITraitCollection.current.verticalSizeClass == .compact ? 80 : 40

        let oneMaxPRBarChartView = BarChartView(data: ChartData(values: points), title: title, legend: "One Rep Max", form: CGSize(width: UIScreen.main.bounds.width - widthMargins, height: 300), dropShadow: false)
        
        return oneMaxPRBarChartView
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let widthMargins: CGFloat = UITraitCollection.current.verticalSizeClass == .compact ? 80 : 40
        hostingBarChartViewController?.rootView.formSize = CGSize(width: UIScreen.main.bounds.width - widthMargins, height: 300)
    }
}
