//
//  taptactoeTests.swift
//  taptactoeTests
//
//  Created by Todd Olsen on 12/7/16.
//  Copyright © 2016 proxpero. All rights reserved.
//

import XCTest
@testable import taptactoe

class taptactoeTests: XCTestCase {


    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

class BoardTests: XCTestCase {

    func testAvailableSquares() {

        let board = Board()
        XCTAssertEqual(board.availableSquares, Board.all)

    }

    func testUnavailableSquares() {
        let board = Board()
        XCTAssertEqual(board.unavailableSquares, [])
    }

    func testOutcome() {
        let board = Board(turn1: [0, 1, 2], turn2: [3, 4])
        let outcome = board.outcome()
        XCTAssertNotNil(outcome)
        XCTAssertTrue(outcome!.isWin(for: Turn.one))
    }

    func testWinner() {
        let board = Board(turn1: [0, 1, 2], turn2: [3, 4])
        let game = Game(board, currentTurn: Turn.one)
        XCTAssertNotNil(game.winner)
        XCTAssertEqual(game.winner!, Turn.one)
    }

    func testInertSquares() {
        let board = Board(turn1: [0, 1, 2, 5], turn2: [3, 4, 6, 7])
        let game = Game(board, currentTurn: Turn.one)
        let inert = game.inertSquares
        XCTAssertEqual(inert, [5, 3, 4, 6, 7])
    }

    func testWinningSquares() {
        let board = Board(turn1: [0, 1, 2], turn2: [3, 4])
        let game = Game(board, currentTurn: Turn.one)
        let winners = game.winningSquares

        XCTAssertNotNil(winners)
        XCTAssertEqual(winners!, Set<Square>([0, 1, 2]))
    }

    func testOccupySquareWithTurn() {

        let board = Board()
        let turn = Turn.one
        let square = 3
        let newBoard = board.occupy(square, with: turn)

        XCTAssertNotNil(newBoard)

        let squares = newBoard!.squares(for: turn)
        XCTAssertEqual(squares.count, 1)
        XCTAssertEqual(squares.first!, square)

        XCTAssertEqual(newBoard!.availableSquares.count, 8)
        XCTAssertEqual(newBoard!.availableSquares, Board.all.subtracting([square]))

    }

    func testFindBestMoveForTurnHavingStraightupWins() {

        let board = Board(turn1: [0, 1, 4], turn2: [3, 8, 6])

        func completion(best: Square) {
            XCTAssertEqual(best, Square(2))
        }

        board.findBestMove(for: Turn.one) { best in
            XCTAssertEqual(best, Square(2))
        }

        board.findBestMove(for: Turn.two) {best in
            XCTAssertEqual(best, Square(7))
        }
    }

    func testFindBestMoveForTurnNeedingToBlock() {

        let board = Board(turn1: [0, 4], turn2: [1, 2, 8])

        board.findBestMove(for: Turn.one) { best in
            XCTAssertEqual(best, 5)
        }

    }

    func testFindBestMoveForTurnHavingForkingOpportunities1() {

        let board = Board(turn1: [0, 4], turn2: [1, 8])

        // this gives only 6, but not 3
        for _ in 1...100 {
            board.findBestMove(for: Turn.one) { best in
                print("best is \(best)")
                XCTAssertTrue([3, 6].contains(best))
            }
        }

    }

    func testFindBestMoveForTurnHavingForkingOpportunities2() {

        let board = Board(turn1: [0, 6], turn2: [1, 3])

        // this gives only 4 but not 8
        for _ in 1...100 {
            board.findBestMove(for: Turn.one) { best in
                print("best is \(best)")
                XCTAssertTrue([4, 8].contains(best))
            }
        }
        
    }

    func testFindBestMoveForTurnWithOpponentInThecorner() {
        let board = Board(turn1: [0, 6, 8], turn2: [1, 3, 7])
    }

    func testEventualOutcomeOfMoveByTurnWithObviousWin() {

        let board = Board(turn1: [0, 6, 8], turn2: [1, 3, 7])
        XCTAssertEqual(board.eventualOutcome(of: 4, by: Turn.one), Outcome.win(Turn.one))
        XCTAssertEqual(board.eventualOutcome(of: 5, by: Turn.one), Outcome.win(Turn.two))

    }

    func testEventualOutcomeOfMoveByTurnWithForkingOpportuntiy1() {

        let board = Board(turn1: [0, 4], turn2: [1, 8])
        XCTAssertEqual(board.eventualOutcome(of: 3, by: Turn.one), Outcome.win(Turn.one))
        XCTAssertEqual(board.eventualOutcome(of: 6, by: Turn.one), Outcome.win(Turn.one))
    }

    func testEventualOutcomeOfMoveByTurnWithForkingOpportuntiy2() {

        for corner in Board.corners {
            let board = Board(turn1: [corner], turn2: [])
            for side in Board.sides {
                XCTAssertEqual(board.eventualOutcome(of: side, by: Turn.two), Outcome.win(Turn.one))
            }
        }

    }

}
