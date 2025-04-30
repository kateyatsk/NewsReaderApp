//
//  CategoryCell.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 28.04.25.
//

import UIKit

final class CategoryCell: UICollectionViewCell {
    static let reuseIdentifier = "CategoryCell"
    
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
    
    func configure(text: String, isSelected: Bool) {
        label.text = text
        if isSelected {
            contentView.backgroundColor = .primaryText
            label.textColor = .secondaryBackground
        } else {
            contentView.backgroundColor = .secondaryBackground
            label.textColor = .primaryText
        }
    }
    
}
