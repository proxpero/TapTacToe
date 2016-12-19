//
//  SquareView.swift
//  taptactoe
//
//  Created by Todd Olsen on 12/14/16.
//  Copyright © 2016 proxpero. All rights reserved.
//

import UIKit

final class SquareView: UIView {

    func occupy(with turn: Turn, completion: @escaping () -> Void) {

        guard let occupation = subviews.first else { return }
        occupation.backgroundColor = turn.color
        occupation.transform = Transform.scaleDown

        func scaleUp() {
            occupation.transform = Transform.identity
            if turn.isCircle {
                occupation.layer.cornerRadius = occupation.frame.width / 2
            }
            occupation.alpha = 1.0
        }

        UIView.animate(withDuration: 0.25, animations: scaleUp) { _ in
            completion()
        }

    }

    func highlight() {

        guard let occupation = subviews.first else { return }
        let isSquare = occupation.layer.cornerRadius == 0
        occupation.animate(with: 0.25, transform: isSquare ? Transform.rotation : Transform.spin) { _ in
            occupation.animate(with: 0.25, transform: Transform.identity)
        }

    }

    func deemphasize() {
        UIView.animate(withDuration: 0.5) {
            self.subviews.first?.alpha = 0.0
        }
    }
    
}
