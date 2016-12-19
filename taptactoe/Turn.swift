//
//  Turn.swift
//  taptactoe
//
//  Created by Todd Olsen on 12/13/16.
//  Copyright © 2016 proxpero. All rights reserved.
//

import UIKit

private let blue = UIColor(rgb: 0x4990E2)
private let red = UIColor(rgb: 0xD0011B)


/// A Turn encapsulates the notion of which player is expected to go. 
/// Turn.one is always the one who make the first move in a game.
enum Turn {

    case one
    case two

    var opponent: Turn {
        return self == .one ? .two : .one
    }

    var color: UIColor {
        switch self {
        case .one: return blue
        case .two: return red
        }
    }

    var isCircle: Bool {
        switch self {
        case .one: return true
        case .two: return false
        }
    }

}
