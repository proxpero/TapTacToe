//
//  RootViewController.swift
//  taptactoe
//
//  Created by Todd Olsen on 12/9/16.
//  Copyright © 2016 proxpero. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {

    var stackView: UIStackView {
        guard let stackView = view.subviews.flatMap({ $0 as? UIStackView }).first
            else { fatalError() }
        return stackView
    }

    func addViewController(_ vc: UIViewController) {
        addChildViewController(vc)
        vc.didMove(toParentViewController: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        for view in childViewControllers.flatMap({ $0.view }) {
            stackView.addArrangedSubview(view)
        }
    }
}
