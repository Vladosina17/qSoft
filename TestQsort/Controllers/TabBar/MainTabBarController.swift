//
//  MainTabBarController.swift
//  TestQsort
//
//  Created by Влад Барченков on 09.08.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainViewController = MainViewController()
        tabBar.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        let peopleImg = UIImage(systemName: "person.2")!
        viewControllers = [generateNavigationController(rootViewController: mainViewController, title: "Лента", image: peopleImg)]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}
