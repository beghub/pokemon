//
//  SearchCollectionViewCell.swift
//  Pokemon
//
//  Created by Begüm Tüzüner on 1.08.2023.
//

import UIKit
import SDWebImage

class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchCollectionViewCell"
    
    private let imageView = UIImageView()
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        // Layout constraints for image view
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.49) // Square image view
        ])
        
        // Layout constraints for label
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with card: Card) {
        // Configure the cell's UI elements with the card data
        imageView.sd_setImage(with: URL(string: card.imageUrl), placeholderImage: UIImage(systemName: "person") ,completed: nil)
        label.text = card.name
        
    }

    
    // MARK: -Long Press To Add Favorites
    var onLongPress: (() -> Void)?
    
    private func setupGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        addGestureRecognizer(longPressGesture)
    }
    
    @objc private func handleLongPress() {
        onLongPress?()
    }
}
