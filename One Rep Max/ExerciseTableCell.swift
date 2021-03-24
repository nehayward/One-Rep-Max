//
//  ExerciseTableViewCell.swift
//  One Rep Max
//
//  Created by Nick Hayward on 3/23/21.
//

import Foundation
import UIKit

class ExerciseTableViewCell: UITableViewCell {
    static let ID = "\(ExerciseTableViewCell.self)"
    let exerciseView = ExerciseView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    func setup() {
        exerciseView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(exerciseView)
        
        NSLayoutConstraint.activate([
            exerciseView.topAnchor.constraint(equalTo: contentView.topAnchor),
            exerciseView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            exerciseView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            exerciseView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
