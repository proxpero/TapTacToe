//
//  FooterViewController.swift
//  taptactoe
//
//  Created by Todd Olsen on 12/12/16.
//  Copyright © 2016 proxpero. All rights reserved.
//

import UIKit
import CoreMotion

final class FooterViewController: UIViewController {

    private var motionManager: CMMotionManager?
    private var timer: Timer?
    private var animator: UIDynamicAnimator!
    private let gravity = UIGravityBehavior()
    private let collision = UICollisionBehavior()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up UIKit Dynamics 

        animator = UIDynamicAnimator(referenceView: view)
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
        collision.translatesReferenceBoundsIntoBoundary = true
        gravity.magnitude = 3.0
        
    }

    func addToken(for player: PlayerType?) {

        // Create a motion manager if there isn't one.

        if motionManager == nil {
            motionManager = CMMotionManager()
            motionManager!.startAccelerometerUpdates()
            timer = Timer.every(0.2) {
                guard let acceleration = self.motionManager?.accelerometerData?.acceleration else { return }
                self.gravity.gravityDirection = CGVector(dx: acceleration.x, dy: -acceleration.y)
            }
        }

        // Create the proper token.

        let frame = CGRect(
            origin: CGPoint(x: view.frame.midX, y: 0),
            size: CGSize(width: 40, height: 40)
        )

        func newLabel(with text: String) -> UILabel {
            let label = UILabel(frame: frame)
            label.font = UIFont.systemFont(ofSize: 40)
            label.text = text
            label.sizeToFit()
            return label
        }

        func newDrawSquare() -> UIView {
            let square = UIView(frame: frame)
            square.layer.backgroundColor = UIColor.darkGray.cgColor
            square.layer.borderColor = UIColor.white.cgColor
            square.layer.borderWidth = 1.0
            return square
        }

        let shape: UIView = player != nil ? newLabel(with: player!.text) : newDrawSquare()

        // Add the token to the dynamic behaior system.

        view.addSubview(shape)
        let behavior = UIDynamicItemBehavior(items: [shape])
        behavior.elasticity = 0.7
        animator.addBehavior(behavior)
        gravity.addItem(shape)
        collision.addItem(shape)

    }

}

extension UILabel {

    // Give the token a circular collision bounding shape so it rolls.
    open override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }

}



