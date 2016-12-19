//
//  Board.swift
//  taptactoe
//
//  Created by Todd Olsen on 12/7/16.
//  Copyright © 2016 proxpero. All rights reserved.
//

import UIKit

typealias Square = Int

struct Board {

    // MARK: - Stored Properties
    private let storage: Dictionary<Turn, Set<Square>>

    // MARK: - Initializers

    init(turn1: Set<Square> = [], turn2: Set<Square> = []) {
        var dict = Dictionary<Turn, Set<Square>>()
        dict[Turn.one] = turn1
        dict[Turn.two] = turn2
        self.storage = dict
    }

    // MARK: - Computed Properties

    var availableSquares: Set<Square> {
        return Board.all.subtracting(squares(for: Turn.one)).subtracting(squares(for: Turn.two))
    }

    var unavailableSquares: Set<Square> {
        return Board.all.subtracting(availableSquares)
    }

    func squares(for turn: Turn) -> Set<Square> {
        return storage[turn]!
    }

    var outcome: Outcome? {
        for winner in Board.winners {
            for turn in [Turn.one, Turn.two] {
                if storage[turn]!.isSuperset(of: winner) {
                    return .win(turn)
                }
            }
        }
        if availableSquares.isEmpty { return .draw }
        return nil
    }

    // MARK: -

    /// Mark the `square` as claimed by the player `turn` and returns a new
    /// board reflecting this change. Returns `nil` if the square is 
    /// unavailable.
    ///
    /// - Parameters:
    ///   - square: The square being claimed
    ///   - turn: The player who is occupying the square.
    /// - Returns: A new board reflecting the occupation.
    func occupy(_ square: Square, with turn: Turn) -> Board? {
        guard availableSquares.contains(square) else { return nil }
        var storage_ = storage
        var set = squares(for: turn)
        set.insert(square)
        storage_[turn] = set
        return Board(turn1: storage_[Turn.one]!, turn2: storage_[Turn.two]!)
    }

}

extension Board {

    // MARK: Minimax

    func findBestMove(for turn: Turn, completion: (Square) -> Void) {

        func bestPreliminaryMove(for turn: Turn) -> Square? {

            if availableSquares.count == Board.all.count {
                return Board.corners.first!
            }

            if availableSquares.count == Board.all.count - 1 {
                if availableSquares.contains(Board.center) {
                    return Board.center
                }
                let availableCorners = availableSquares.intersection(Board.corners)
                if !availableCorners.isEmpty {
                    return availableCorners.first!
                }
            }

            return nil
        }

        if let bestMove = bestPreliminaryMove(for: turn) {
            completion(bestMove)
            return
        }

        var wins: Set<Square> = []
        var draws: Set<Square> = []

        for move in availableSquares {
            let outcome = eventualOutcome(of: move, by: turn)
            if outcome.isWin(for: turn) {
                wins.insert(move)
            } else if outcome.isDraw() {
                draws.insert(move)
            }
        }

        // If there are multiple best moves, pick one at random.
        if !wins.isEmpty {
            completion(wins.first!)
        } else if !draws.isEmpty {
            completion(draws.first!)
        } else {
            completion(availableSquares.first!)
        }


    }

    func eventualOutcome(of square: Square, by turn: Turn) -> Outcome {

        guard let newBoard = occupy(square, with: turn) else { fatalError() }

        if let outcome = newBoard.outcome {
            return outcome
        }

        let outcomes = newBoard.availableSquares.map { candidate -> Outcome in
            return newBoard.eventualOutcome(of: candidate, by: turn.opponent)
        }

        if outcomes.contains(.win(turn.opponent)) {
            return .win(turn.opponent)
        }
        
        if outcomes.contains(.draw) {
            return .draw
        }
        
        return .win(turn)
        
    }

}

// MARK:

extension Board {

    static let all: Set<Square> = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    static let winners: Set<Set<Square>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
    static let corners: Set<Square> = [0, 2, 6, 8]
    static let sides: Set<Square> = [1, 3, 5, 7]
    static let center: Square = 4

}

