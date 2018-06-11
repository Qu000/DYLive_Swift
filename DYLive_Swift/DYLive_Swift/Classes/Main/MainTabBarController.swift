//
//  MainTabBarController.swift
//  DYLive_Swift
//
//  Created by qujiahong on 2018/6/11.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildVC(storyName: "Home")
        addChildVC(storyName: "Live")
        addChildVC(storyName: "Follow")
        addChildVC(storyName: "Profile")
        
    }

    func addChildVC(storyName: String) {
        
        let childVC = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        
        addChildViewController(childVC)
    }
}
