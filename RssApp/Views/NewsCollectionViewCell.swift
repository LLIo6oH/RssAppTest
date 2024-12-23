//
//  NewsCollectionViewCell.swift
//  RssApp
//
//  Created by Dmitry Kuklin on 23.12.2024.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NewsCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 1
        imageView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 2
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private let unreadIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 5
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, authorLabel, dateLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        
        contentView.addSubview(imageView)
        contentView.addSubview(stackView)
        contentView.addSubview(unreadIndicator)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        unreadIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            unreadIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            unreadIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            unreadIndicator.widthAnchor.constraint(equalToConstant: 10),
            unreadIndicator.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    func configure(with newsItem: NewsItem) {
        titleLabel.text = newsItem.title
        descriptionLabel.text = newsItem.description
        authorLabel.text = newsItem.author ?? "Unknown Author"
        if let pubDate = newsItem.pubDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy, HH:mm"
            dateLabel.text = formatter.string(from: pubDate)
        } else {
            dateLabel.text = "No Date"
        }
        
        imageView.image = UIImage(systemName: "photo")
        unreadIndicator.isHidden = newsItem.isRead
    }
    
    func setImage(_ image: UIImage?) {
        guard let image else {
            imageView.image = UIImage(systemName: "photo")
            return
        }
        imageView.image = image
    }
}
