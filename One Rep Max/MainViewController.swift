//
//  MainViewController.swift
//  One Rep Max
//
//  Created by Nick Hayward on 3/22/21.
//

import UIKit
import OneRepMaxCore

class MainViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ExerciseTableViewCell.self, forCellReuseIdentifier: ExerciseTableViewCell.ID)
        return tableView
    }()
    
    private var exercises: [Exercise] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        addSubviews()
        addConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let selectedRow = self.tableView.indexPathForSelectedRow else { return }

        if let coordinator = transitionCoordinator {
            coordinator.animate { [weak self] (context) in
                self?.tableView.deselectRow(at: selectedRow, animated: true)
            } completion: { (context) in
                if context.isCancelled {
                    self.tableView.selectRow(at: selectedRow, animated: false, scrollPosition: .none)
                }
            }
        } else {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }
    
    func setup() {
        title =  NSLocalizedString("Exercises", comment: "Excerises")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        DataImporter.shared.fetchExerciseData { [weak self] result in
            switch result {
            case .success(let exercises):
                print(exercises)
                self?.exercises = exercises
                self?.tableView.reloadData()
            case .failure(let error):
                switch error {
                case .invalidData:
                    let alert = UIAlertController(title: "Failed to import data", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(.init(title: "Ok", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func addSubviews() {
        view.addSubview(tableView)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}


extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exercise = exercises[indexPath.row]
        navigationController?.pushViewController(ExerciseViewController(exercise: exercise), animated: true)
    }
}


extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let exercise = exercises[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseTableViewCell.ID) as? ExerciseTableViewCell else {
            fatalError("Failed to register cell")
        }
        let best = MathManager.shared.calculatePersonalBest(exercise: exercise)
        let max = "\(String(format: "%.0f", best.value)) \(best.unit.symbol)"
        
        cell.exerciseView.configure(ExerciseView.ViewModel(title: exercise.name, detail: max))
        return cell
    }
}
