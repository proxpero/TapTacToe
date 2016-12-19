//
//  Outcome.swift
//  taptactoe
//
//  Created by Todd Olsen on 12/14/16.
//  Copyright © 2016 proxpero. All rights reserved.
//

import Foundation

enum Outcome {
    case win(Turn)
    case draw

    func isWin(for turn: Turn) -> Bool {
        switch self {
        case .win(let winner): return winner == turn
        default: return false
        }
    }

    func isDraw() -> Bool {
        return self == .draw
    }
}

extension Outcome: Equatable {
    static func == (lhs: Outcome, rhs: Outcome) -> Bool {
        switch (lhs, rhs) {
        case (.draw, .draw): return true
        case (.win(let left), .win(let right)): return left == right
        default: return false
        }
    }
}
