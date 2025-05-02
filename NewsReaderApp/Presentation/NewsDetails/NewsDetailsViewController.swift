//
//  NewsDetailsViewController.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 30.04.25.
//
import Foundation
import UIKit

final class NewsDetailsViewController: UIViewController {
    private let viewModel: NewsDetailsViewModel
    
    private var isBookmarked = false {
        didSet {
            let imageName = isBookmarked ? "bookmark.fill" : "bookmark"
            bookmarkButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
   
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let dateLabel = UILabel()
    private let contentLabel = UILabel()
    private let imageView = UIImageView()
    private let bookmarkButton = UIButton(type: .system)
    private let titleRowStackView = UIStackView()
    
    
    init(viewModel: NewsDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryBackground
        setupUI()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isBookmarked = viewModel.isBookmarked
    }
    
    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 12
        
        [imageView, titleRowStackView, authorLabel, dateLabel, contentLabel].forEach {
            contentStack.addArrangedSubview($0)
        }
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.numberOfLines = 0
        
        bookmarkButton.tintColor = .primaryText
        bookmarkButton.setContentHuggingPriority(.required, for: .horizontal)
        bookmarkButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        bookmarkButton.addTarget(self, action: #selector(toggleBookmark), for: .touchUpInside)
        
        titleRowStackView.axis = .horizontal
        titleRowStackView.alignment = .top
        titleRowStackView.distribution = .fill
        titleRowStackView.spacing = 8
        titleRowStackView.translatesAutoresizingMaskIntoConstraints = false
        titleRowStackView.addArrangedSubview(titleLabel)
        titleRowStackView.addArrangedSubview(bookmarkButton)
        
        authorLabel.font = .italicSystemFont(ofSize: 14)
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .secondaryLabel
        
        contentLabel.font = .systemFont(ofSize: 16)
        contentLabel.numberOfLines = 0
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
    }
    
    private func configure() {
        titleLabel.text = viewModel.title
        authorLabel.text = viewModel.author
        dateLabel.text = viewModel.date
        contentLabel.text = viewModel.content
        
        self.imageView.image = UIImage(named: "placeholder")
        if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let self else { return }
                DispatchQueue.main.async {
                    if let data = data, let _ = UIImage(data: data) {
                        self.imageView.image = UIImage(data: data)
                    } else {
                        self.imageView.image = UIImage(named: "placeholder")
                    }
                }
            }.resume()
        }
        
        
    }
    
    @objc private func toggleBookmark() {
        viewModel.toggleBookmark()
        isBookmarked.toggle()
    }
    
}

