//
//  PlayerType.swift
//  taptactoe
//
//  Created by Todd Olsen on 12/13/16.
//  Copyright © 2016 proxpero. All rights reserved.
//

enum PlayerType {
    case human
    case robot
}

extension PlayerType {

    var isHuman: Bool {
        switch self {
        case .human:
            return true
        default:
            return false
        }
    }

    var isRobot: Bool {
        switch self {
        case .robot:
            return true
        default:
            return false
        }
    }

    var opponent: PlayerType {
        switch self {
        case .human:
            return .robot
        case .robot:
            return .human
        }
    }

    var text: String {
        switch self {
        case .human: return "🙂"
        case .robot: return "🤖"
        }
    }
}
