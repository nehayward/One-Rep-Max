//
//  ExerciseView.swift
//  One Rep Max
//
//  Created by Nick Hayward on 3/23/21.
//

import Foundation
import UIKit

class ExerciseView: UIView {
    static let preferredSize = CGSize(width: 343, height: 100)
    override var intrinsicContentSize: CGSize { Self.preferredSize }

    // MARK: UI
    private lazy var contentDetailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.text = "--"
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = NSLocalizedString("One Rep Max • lbs", comment: "Describing a one rep max and unit mass")
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.text = "--"
        return label
    }()
    
    public required init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
        addConstraints()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    func configure(_ viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        detailLabel.text = viewModel.detail
    }
    
    func addSubviews() {
        addSubview(contentDetailStackView)
        addSubview(detailLabel)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            contentDetailStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentDetailStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentDetailStackView.trailingAnchor.constraint(lessThanOrEqualTo: detailLabel.leadingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            detailLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

extension ExerciseView {
    struct ViewModel {
        let title: String
        let detail: String
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ExerciseViewViewPreview: PreviewProvider {
    static var previews: some View {
        Group {
            ExerciseView()
                .toPreview()
                .previewDisplayName("Light")
                .background(Color(UIColor.systemBackground))
                .previewLayout(.sizeThatFits)
            
            ExerciseView()
                .toPreview()
                .previewDisplayName("Dark")
                .background(Color(UIColor.systemBackground))
                .colorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
#endif
