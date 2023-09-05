//
//  TabBarViewController.swift
//  Pokemon
//
//  Created by Begüm Tüzüner on 2.08.2023.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let SearchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController")
        let FavoriteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavoriteViewController")
        
        SearchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        SearchViewController.title = "Search"
        FavoriteViewController.tabBarItem.image = UIImage(systemName: "heart")
        FavoriteViewController.title = "Favorite"
        
        let navController1 = UINavigationController(rootViewController: SearchViewController)
        let navController2 = UINavigationController(rootViewController: FavoriteViewController)

        viewControllers = [navController1, navController2]
    }
}
