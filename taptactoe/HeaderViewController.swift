//
//  HeaderViewController.swift
//  taptactoe
//
//  Created by Todd Olsen on 12/12/16.
//  Copyright © 2016 proxpero. All rights reserved.
//

import UIKit

final class HeaderViewController: UIViewController {

    @IBOutlet var turnOne: UILabel!
    @IBOutlet var turnTwo: UILabel!
    
    @IBOutlet var indicator: UIView!
    @IBOutlet var indicatorWidth: NSLayoutConstraint!

    private var inset: CGFloat = 0.0
    private var width: CGFloat = 0.0

    func clear() {
        guard let stackview = view.subviews.first else { return }
        UIView.animate(withDuration: 0.25) {
            stackview.alpha = 0.0
        }
    }

    func position(for turn: Turn) -> CGFloat {
        switch turn {
        case .one: return inset
        case .two: return inset + width + inset + inset
        }
    }

    func transform(for turn: Turn) -> CGAffineTransform {
        let xpos: CGFloat
        switch turn {
        case .one: xpos = inset
        case .two: xpos = inset + width + inset + inset
        }
        return CGAffineTransform(translationX: xpos, y: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        inset = (view.frame.width / 2.0) * 0.2
        width = (view.frame.width / 2.0) - (2.0 * inset)
        indicatorWidth.constant = width
        indicator.layer.backgroundColor = UIColor.blue.cgColor
        switchTurn(to: .one)
    }

    func reset(with firstPlayer: PlayerType, completion: (() -> Void)? = nil) {
        guard let stackview = view.subviews.first else { return }

        turnOne.text = firstPlayer.text
        turnTwo.text = firstPlayer.opponent.text
        self.switchTurn(to: .one)

        UIView.animate(withDuration: 0.5,
                       animations: { stackview.alpha = 1.0 },
                       completion: { _ in completion?() }
        )

    }

    func switchTurn(to turn: Turn) {
        func radius() -> CGFloat { return min(indicator.frame.width, indicator.frame.height) / 2.0 }
        UIView.animate(withDuration: 0.5) {
            self.indicator.transform = self.transform(for: turn)
            self.indicator.layer.cornerRadius = turn.isCircle ? radius() : 0.0
            self.indicator.layer.backgroundColor = turn.color.cgColor
        }
    }
    
}
