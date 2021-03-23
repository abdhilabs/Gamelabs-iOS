//
//  MainViewController.swift
//  Gamelabs
//
//  Created by Abdhi on 19/03/21.
//

import UIKit

class MainViewController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - Navigation
    private lazy var home: UIViewController = {
        let vc = HomeViewController()
        let image = UIImage(systemName: "house")
        let selectedImage = UIImage(systemName: "house.fill")
        vc.tabBarItem = UITabBarItem(title: "Home", image: image, selectedImage: image)
        return UINavigationController(rootViewController: vc)
    }()
    
    private lazy var search: UIViewController = {
        let vc = SearchViewController()
        let image = UIImage(systemName: "magnifyingglass")
        let selectedImage = UIImage(systemName: "magnifyingglass")
        vc.tabBarItem = UITabBarItem(title: "Search", image: image, selectedImage: selectedImage)
        return UINavigationController(rootViewController: vc)
    }()
    
    private lazy var favourite: UIViewController = {
        let vc = FavouriteViewController()
        let image = UIImage(systemName: "star")
        let selectedImage = UIImage(systemName: "star")
        vc.tabBarItem = UITabBarItem(title: "Favourite", image: image, selectedImage: selectedImage)
        return UINavigationController(rootViewController: vc)
    }()
    
    private lazy var about: UIViewController = {
        let vc = AboutViewController()
        let image = UIImage(systemName: "person.circle")
        let selectedImage = UIImage(systemName: "person.circle")
        vc.tabBarItem = UITabBarItem(title: "About", image: image, selectedImage: selectedImage)
        return UINavigationController(rootViewController: vc)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        self.tabBar.isOpaque = false
        self.tabBar.isTranslucent = true
        self.tabBar.tintColor = UIColor.tabIconColor
        
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 2
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.layer.borderWidth = 0
        self.tabBar.layer.cornerRadius = 4
        self.tabBar.clipsToBounds = true
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.tabBar.backgroundColor = UIColor.white
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        
        self.viewControllers = [home, search, favourite, about]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}
