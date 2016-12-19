//
//  Game.swift
//  taptactoe
//
//  Created by Todd Olsen on 12/7/16.
//  Copyright © 2016 proxpero. All rights reserved.
//

import Foundation

/// A Game represents a tictactoe game. It tracks the current board and the
/// current turn.
class Game {

    // MARK: Stored Properties

    weak var delegate: GameDelegate?

    private var board: Board
    private(set) var currentTurn: Turn

    // MARK: Initialization

    init(_ board: Board = Board(), currentTurn: Turn = Turn.one) {
        self.board = board
        self.currentTurn = currentTurn
    }

    // MARK: Computed Properties

    public var outcome: Outcome? {
        return board.outcome
    }

    public var winner: Turn? {
        guard let outcome = outcome else { return nil }
        switch outcome {
        case .draw: return nil
        case .win(let winner): return winner
        }
    }

    var availableSquares: Set<Square> {
        return board.availableSquares
    }

    var unavailableSquares: Set<Square> {
        return board.unavailableSquares
    }

    var winningSquares: Set<Square>? {
        guard let turn = winner else { return nil }
        var result = Set<Square>()
        for set in Board.winners {
            if set.isSubset(of: board.squares(for: turn)) {
                result.formUnion(set)
            }
        }
        return result
    }

    var inertSquares: Set<Square> {
        let winners = winningSquares ?? []
        return unavailableSquares.subtracting(winners)
    }

    // MARK:

    func reset() {
        board = Board()
        currentTurn = Turn.one
    }

    func checkStatus() {
        if let outcome = board.outcome {
            delegate?.game(self, didEndWith: outcome)
            return
        }
        currentTurn = currentTurn == Turn.one ? Turn.two : Turn.one
        delegate?.game(self, didSwitchTo: currentTurn)
    }

    public func occupy(_ square: Square, with turn: Turn) {
        guard let board = board.occupy(square, with: turn) else { return }
        self.board = board
        delegate?.game(self, didOccupy: square, with: turn)
    }

    func performTurn() {
        delegate?.game(self, willFindBestMoveAmong: board.availableSquares)
        board.findBestMove(for: currentTurn) { square in
            delegate?.game(self, didFindBestMoveAt: square)
            occupy(square, with: currentTurn)
        }
    }

}

protocol GameDelegate: class {
    func game(_ game: Game, didOccupy square: Square, with turn: Turn)
    func game(_ game: Game, didSwitchTo turn: Turn)
    func game(_ game: Game, willFindBestMoveAmong squares: Set<Square>)
    func game(_ game: Game, didFindBestMoveAt square: Square)
    func game(_ game: Game, didEndWith outcome: Outcome)
}

extension GameDelegate {
    func game(_ game: Game, willFindBestMoveAmong squares: Set<Square>) { }
    func game(_ game: Game, didFindBestMoveAt square: Square) { }
}

