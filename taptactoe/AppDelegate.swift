//
//  AppDelegate.swift
//  taptactoe
//
//  Created by Todd Olsen on 12/7/16.
//  Copyright © 2016 proxpero. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: GameCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        guard
            let window = window,
            let rootViewController = window.rootViewController as? RootViewController
            else { return false }

        let header = UIStoryboard.main.instantiate(HeaderViewController.self)
        let board = UIStoryboard.main.instantiate(BoardViewController.self)
        let footer = UIStoryboard.main.instantiate(FooterViewController.self)

        for vc in [header, board, footer] {
            rootViewController.addViewController(vc)
        }

        coordinator = GameCoordinator.init(with: header, board, footer)

        return true
    }
    
}

