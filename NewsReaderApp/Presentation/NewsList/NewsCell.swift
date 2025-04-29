//
//  NewsCell.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 29.04.25.
//

import UIKit

final class NewsCell: UICollectionViewCell {
    static let reuseIdentifier = "NewsCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    
    private let newsTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .semibold)
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.numberOfLines = 3
        lbl.textColor = .secondaryLabel
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 8
        
        contentView.addSubview(imageView)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(descriptionLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalToConstant: 180),
            
            newsTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            newsTitleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            newsTitleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: newsTitleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: newsTitleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with news: News) {
        newsTitleLabel.text = news.title
        descriptionLabel.text = news.description
        
        if let urlString = news.urlToImage, let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }.resume()
        } else {
            imageView.image = nil
        }
            
    }
    
}
