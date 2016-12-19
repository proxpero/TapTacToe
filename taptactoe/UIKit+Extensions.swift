//
//  UIKit+Extensions.swift
//  taptactoe
//
//  Created by Todd Olsen on 12/14/16.
//  Copyright © 2016 proxpero. All rights reserved.
//

import UIKit

extension UIStoryboard {

    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }

    func instantiate<A: UIViewController>(_ type: A.Type) -> A {
        guard let vc = self.instantiateViewController(withIdentifier: String(describing: type.self)) as? A else {
            fatalError("Could not instantiate view controller \(A.self)") }
        return vc
    }
}

extension UIView {

    func animate(with duration: TimeInterval, transform: CGAffineTransform, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = transform
        }, completion: completion)
    }
    
}

extension Timer {

    // Cribbed from https://github.com/radex/SwiftyTimer

    @discardableResult
    public class func every(_ interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        let timer = Timer.new(every: interval, block)
        timer.start()
        return timer
    }

    public class func new(every interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        return CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, interval, 0, 0) { _ in
            block()
        }
    }

    public func start(runLoop: RunLoop = .current, modes: RunLoopMode...) {
        let modes = modes.isEmpty ? [.defaultRunLoopMode] : modes

        for mode in modes {
            runLoop.add(self, forMode: mode)
        }
    }
    
}

extension UIColor {
    /// Creates a color from `rgb`, typically `rgb` takes
    /// the form of a hexadecimal. For example: `0x31f3b9`.
    public convenience init(rgb: UInt32, alpha: CGFloat = 1.0) {
        self.init(
            red:    CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green:  CGFloat((rgb & 0x00FF00) >>  8) / 255.0,
            blue:   CGFloat((rgb & 0x0000FF) >>  0) / 255.0,
            alpha:  alpha
        )
    }

    public func desaturated() -> Self {
        var hue = CGFloat(0)
        var brightness = CGFloat(0)
        var alpha = CGFloat(0)
        _ = getHue(&hue, saturation: nil, brightness: &brightness, alpha: &alpha)
        let result = type(of: self).init(hue: hue, saturation: 0, brightness: brightness, alpha: alpha)
        return result
    }
}
