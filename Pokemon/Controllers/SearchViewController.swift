//
//  SearchViewController.swift
//  Pokemon
//
//  Created by Begüm Tüzüner on 31.07.2023.
//

import UIKit


class SearchViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate
{
    func didAddCardToFavorites() {
        let fav = FavoriteViewController()
        fav.refreshPage()
    }
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var cardsCollectionView: UICollectionView!
    var favoriteCards: [Card] = []
    
    
    // Create an array of cards
    private var cards = [Card]()
    private var filteredCards = [Card]()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        searchBar.isHidden = false
        searchBar.delegate = self
//        searchBar.keyboardType = .numberPad
        cardsCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell")
        cardsCollectionView.delegate = self
        cardsCollectionView.dataSource = self
        cardsCollectionView.backgroundColor = .systemBackground
        cardsCollectionView.collectionViewLayout = createLayout()
        APICaller.shared.fetchPosts{ [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cards):
                    self?.cards = cards
                    self?.cardsCollectionView?.reloadData()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
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
    
//    func showCardDetails(for card: Card) {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
//            if let cardDetailsVC = storyboard.instantiateViewController(withIdentifier: "CardDetailsViewController") as? CardDetailsViewController {
//                cardDetailsVC.card = card
//                navigationController?.pushViewController(cardDetailsVC, animated: true)
//            }
//        }
    
    func showCardDetails(for card: Card) {
        performSegue(withIdentifier: "CustomSearchCardDetailsSegue", sender: card)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CustomSearchCardDetailsSegue",
           let destinationVC = segue.destination as? CardDetailsViewController,
           let card = sender as? Card {
            destinationVC.card = card
        }
}
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}



// Implement UICollectionViewDataSource and UICollectionViewDelegateFlowLayout for the collection view
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCards.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let card = filteredCards[indexPath.item]
        // Configure the cell with the card data
        cell.configure(with: card)
        
        // Set the onLongPress closure to handle adding the card to favorites
        cell.onLongPress = { [weak self] in
            self?.addToFavorites(card)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width / 2 - 10 // Display two cells per row with spacing of 10 points
        return CGSize(width: cellWidth, height: cellWidth * 2) // Height includes image view and label
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let card = filteredCards[indexPath.item]
        showCardDetails(for: card)
        
    }
    
    // Function to add a card to favorites
    private func addToFavorites(_ card: Card) {
        if let data = UserDefaults.standard.data(forKey: "FavoriteCards"),
           let favoriteCards = try? JSONDecoder().decode([Card].self, from: data) {
            // Update the favoriteCards array
            self.favoriteCards = favoriteCards
        }


        if !favoriteCards.contains(where: { $0.id == card.id }) {
            favoriteCards.append(card)

            print("\(card.name) added to favorites!")
            UserDefaults.standard.set(try? JSONEncoder().encode(favoriteCards), forKey: "FavoriteCards")
            
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Hide the keyboard
        guard let searchText = searchBar.text, let enteredNumber = Int(searchText) else {
            filteredCards = cards // Show all cards if the search text is empty or not a valid number
            cardsCollectionView.reloadData()
            return
        }
        // Filter the cards based on the entered health points number
        filteredCards = cards.filter { card in
            if let hp = Int(card.hp) {
                return hp == enteredNumber
            }
            return false
        }
        cardsCollectionView.reloadData()
    }
}
