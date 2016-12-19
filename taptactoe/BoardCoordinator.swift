//
//  GameCoordinator.swift
//  taptactoe
//
//  Created by Todd Olsen on 12/7/16.
//  Copyright © 2016 proxpero. All rights reserved.
//

import UIKit

final class GameCoordinator {

    var firstPlayer = PlayerType.human
    var currentPlayer = PlayerType.human
    var game = Game()

    let headerViewController: HeaderViewController
    let boardViewController: BoardViewController
    let footerViewController: FooterViewController

    init(with headerViewController: HeaderViewController,
         _ boardViewController: BoardViewController,
         _ footerViewController: FooterViewController)
    {
        self.headerViewController = headerViewController
        self.boardViewController = boardViewController
        self.footerViewController = footerViewController

        game.delegate = self
        boardViewController.delegate = self
    }

    func reset() {
        firstPlayer = firstPlayer.opponent
        currentPlayer = firstPlayer
        game.reset()
        headerViewController.reset(with: firstPlayer) {
            if self.firstPlayer.isRobot {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.game.performTurn()
                }
            }
        }
    }

    private func winner(for outcome: Outcome) -> PlayerType? {
        switch outcome {
        case .draw: return nil
        default: return currentPlayer
        }
    }

    func endGame(with outcome: Outcome) {
        boardViewController.clearAll() {
            self.reset()
        }
        headerViewController.clear()
        footerViewController.addToken(for: winner(for: outcome))
    }

}

extension GameCoordinator: GameDelegate {

    func game(_ game: Game, didOccupy square: Square, with turn: Turn) {
        boardViewController.occupy(square, with: turn, isDelayed: currentPlayer.isRobot) {
            game.checkStatus()
        }
    }

    func game(_ game: Game, didSwitchTo turn: Turn) {
        currentPlayer = currentPlayer.opponent
        headerViewController.switchTurn(to: turn)
        if currentPlayer.isRobot && game.outcome == nil {
            game.performTurn()
        }
    }

    func game(_ game: Game, didEndWith outcome: Outcome) {
        boardViewController.highlight(game.winningSquares)
        boardViewController.deemphasize(game.inertSquares)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.endGame(with: outcome)
        }
    }

}

extension GameCoordinator: BoardViewDelegate {

    func userDidTap(_ square: Square) {
        if currentPlayer.isHuman {
            game.occupy(square, with: game.currentTurn)
        }
    }

}

