//
//  Transform.swift
//  taptactoe
//
//  Created by Todd Olsen on 12/14/16.
//  Copyright © 2016 proxpero. All rights reserved.
//

import CoreGraphics

struct Transform {
    static let tilt = CGAffineTransform(rotationAngle: -(.pi/2.0))
    static let scaleDown = CGAffineTransform(scaleX: 0.1, y: 0.1)
    static let rotation = CGAffineTransform(rotationAngle: .pi)
    static let spin = CGAffineTransform(a: -1, b: 0, c: 0, d: 1, tx: 0, ty: 0)
    static let identity = CGAffineTransform.identity
}
