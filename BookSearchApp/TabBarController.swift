//
//  ViewController.swift
//  BookSearchApp
//
//  Created by 허성필 on 5/12/25.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.tabBar.backgroundColor = .systemGray5
        self.tabBar.tintColor = .systemPink
        
        addVC()
    }
    
    private func addVC() {
        let homeVC = MainViewController()
        homeVC.tabBarItem = UITabBarItem(title: "검색 탭", image: UIImage(systemName: "book"), selectedImage: UIImage(systemName: "book.fill"))
        
        let cartVC = CartViewController()
        cartVC.tabBarItem = UITabBarItem(title: "담은 책 리스트 탭", image: UIImage(systemName: "cart"), selectedImage: UIImage(systemName: "cart.fill"))
        
        
        self.viewControllers = [homeVC, cartVC]
    }
}
