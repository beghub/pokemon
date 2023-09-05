//
//  CardDetailsViewController.swift
//  Pokemon
//
//  Created by Begüm Tüzüner on 3.08.2023.
//

import UIKit
import SDWebImage

class CardDetailsViewController: UIViewController {
    
    static let identifier = "CardDetailsViewController"
    var card: Card? 

    @IBOutlet var cardImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Populate UI elements with the card data
        if let card = card {
            cardImageView.sd_setImage(with: URL(string: card.imageUrl), placeholderImage: UIImage(systemName: "person") ,completed: nil)
            nameLabel.text = "Name: " + card.name
            artistLabel.text = "Artist: " + card.artist
        }
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
