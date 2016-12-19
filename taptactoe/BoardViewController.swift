//
//  BoardViewController.swift
//  taptactoe
//
//  Created by Todd Olsen on 12/7/16.
//  Copyright © 2016 proxpero. All rights reserved.
//

import UIKit

final class BoardViewController: UIViewController {

    weak var delegate: BoardViewDelegate?

    @IBOutlet var squareViews: [SquareView]!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
            let touch = touches.first,
            let square = squareViews
                .filter({ $0.point(inside: touch.location(in: $0), with: event) })
                .map({ $0.tag })
                .first
            else { return }
        delegate?.userDidTap(square)
    }

}


extension BoardViewController {

    func view(with tag: Int) -> SquareView {
        return squareViews[tag]
    }

    func occupy(_ square: Square, with turn: Turn, isDelayed: Bool, completion: @escaping () -> Void) {
        let delay = isDelayed ? 0.5 : 0.0
        let squareView = view(with: square)

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            squareView.occupy(with: turn) {
                completion()
            }
        }
    }

    func deemphasize(_ squares: Set<Square>) {
        squares.map(view).forEach { $0.deemphasize() }
    }

    func highlight(_ squares: Set<Square>?) {
        guard let squares = squares else { return }
        squares.map(view).forEach { $0.highlight() }
    }

    func clearAll(completion: @escaping () -> Void) {

        func animations() {
            view.transform = view.transform.concatenating(Transform.tilt)
            for occupation in squareViews.flatMap({ $0.subviews.first }) {
                occupation.alpha = 0.0
            }
        }

        func completion_(stop: Bool) {
            for occupation in squareViews.flatMap({ $0.subviews.first }) {
                occupation.backgroundColor = .clear
                occupation.layer.cornerRadius = 0.0
                occupation.alpha = 0.0
            }
            completion()
        }

        UIView.animate(withDuration: 0.5, animations: animations, completion: completion_)
    }

}

protocol BoardViewDelegate: class {
    func userDidTap(_ square: Square)
}

