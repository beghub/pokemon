//
//  FavoriteViewController.swift
//  Pokemon
//
//  Created by Begüm Tüzüner on 30.07.2023.
//

import UIKit

class FavoriteViewController: UIViewController{
    
    @IBOutlet var favsCollectionView: UICollectionView!
    var favoriteCards = UserDefaults.standard.array(forKey: "FavoriteCards") as? [Card] ?? [] {
        didSet {
            favsCollectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshPage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        favsCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell")
        favsCollectionView.delegate = self
        favsCollectionView.dataSource = self
        favsCollectionView.backgroundColor = .systemBackground
        favsCollectionView.collectionViewLayout = createLayout()
        
    }
    
    private func removeFavoriteCard(at indexPath: IndexPath) {
        if favoriteCards.count > 1 {
            favoriteCards.remove(at: indexPath.item)
        }
        
        // Update the favoriteCards array in UserDefaults
        UserDefaultsManager.shared.setFavoriteCards(favoriteCards)
        print("removed.")
    }
        
    // Selector method to reload data
    @objc public func refreshPage() {
        if let data = UserDefaults.standard.data(forKey: "FavoriteCards"),
           let favoriteCards = try? JSONDecoder().decode([Card].self, from: data) {
            // Update the favoriteCards array
            self.favoriteCards = favoriteCards
        }
        for cardd in favoriteCards{
            print(cardd.name)
        }
        favsCollectionView.reloadData()
    }
    
    
    private func createLayout() -> UICollectionViewLayout {
        // Item size
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.47),
            heightDimension: .fractionalHeight(1.0)
        )
        
        // Item
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group size
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.8)
        )
        
        // Group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        
        // Add spacing between items
        group.interItemSpacing = .fixed(10)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        
        // Configure spacing between items (optional)
        let spacing: CGFloat = 5.0
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        // Create layout
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func showCardDetails(for card: Card) {
        performSegue(withIdentifier: "CustomCardDetailsSegue", sender: card)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CustomCardDetailsSegue",
           let destinationVC = segue.destination as? CardDetailsViewController,
           let card = sender as? Card {
            destinationVC.card = card
        }
}
}

// Implement UICollectionViewDataSource and UICollectionViewDelegateFlowLayout for the collection view
extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteCards.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let card = favoriteCards[indexPath.item]
        // Configure the cell with the card data
        cell.configure(with: card)
        
        // Set the onLongPress closure to handle adding the card to favorites
        cell.onLongPress = { [weak self] in
            self?.removeFavoriteCard(at: indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width / 2 - 10 // Display two cells per row with spacing of 10 points
        return CGSize(width: cellWidth, height: cellWidth * 2) // Height includes image view and label
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let card = favoriteCards[indexPath.item]
        showCardDetails(for: card)
        
    }
    
}

