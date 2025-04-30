//
//  NewsCell.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 29.04.25.
//

import UIKit

final class NewsCell: UICollectionViewCell {
    static let reuseIdentifier = "NewsCell"
    
    var onBookmarkTap: (() -> Void)?
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 25
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
    
    private let bookmarkButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .primaryText
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondaryBackground
        contentView.layer.cornerRadius = 25
        
        contentView.addSubviews(
            imageView,
            newsTitleLabel,
            descriptionLabel,
            bookmarkButton
        )

        bookmarkButton.addTarget(
            self,
            action: #selector(didTapBookmark),
            for: .touchUpInside
        )
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            bookmarkButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            bookmarkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 24),
            bookmarkButton.heightAnchor.constraint(equalTo: bookmarkButton.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            imageView.heightAnchor.constraint(equalToConstant: 180),
            
            newsTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            newsTitleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            newsTitleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -30),
            
            descriptionLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: newsTitleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: newsTitleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    func configure(
        with news: News,
        isBookmarked: Bool,
        onBookmarkTap: @escaping () -> Void
    ) {
        self.onBookmarkTap = onBookmarkTap
        newsTitleLabel.text = news.title
        descriptionLabel.text = news.description
        
        let name = isBookmarked ? "bookmark.fill" : "bookmark"
        bookmarkButton.setImage(UIImage(systemName: name), for: .normal)
        
        imageView.image = nil
        
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
    
    @objc private func didTapBookmark() {
        onBookmarkTap?()
    }
    
}


extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach({addSubview($0)})
    }
}
