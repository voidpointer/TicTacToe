//
//  ViewController.swift
//  TicTacToe
//
//  Created by Katie Forshier on 4/13/15.
//  Copyright (c) 2015 Slalom. All rights reserved.
//

import UIKit

protocol TicTacToeProtocol {
    func GetSquareMark(square: TicTacToeSquare) -> SquareMark
    func SetSquareMark(square: TicTacToeSquare, mark: SquareMark) -> Void
    func IsWinningLinePresent() -> Bool
}

public class TicTacToeSquare {
    var row: Int
    var column: Int
    
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
}

public enum SquareMark {
    case X
    case O
    case BLANK
}

class GameViewController: UIViewController, TicTacToeProtocol {

    @IBOutlet weak var square1: UIButton!
    @IBOutlet weak var square2: UIButton!
    @IBOutlet weak var square3: UIButton!
    @IBOutlet weak var square4: UIButton!
    @IBOutlet weak var square5: UIButton!
    @IBOutlet weak var square6: UIButton!
    @IBOutlet weak var square7: UIButton!
    @IBOutlet weak var square8: UIButton!
    @IBOutlet weak var square9: UIButton!
    
    @IBOutlet var gameSquares: [UIButton]!
    
    // turn keeps track of which turn it is and alternates between .X and .O
    var turn = SquareMark.X;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // blank out the tiles at the beginning of the game
        for square in gameSquares {
            square.setTitle("", forState:UIControlState.Normal);
        }
    }

    @IBAction func squareTapped(sender: UIButton) {
        var row = sender.tag / 3,
            column = sender.tag % 3,
            square = TicTacToeSquare(row:row, column:column);
        
        // check to see if this square has already been played
        if (GetSquareMark(square) != .BLANK) {
            return;
        }
        
        SetSquareMark(square, mark:turn);
        
        if (IsWinningLinePresent()) {
            // pop up a winning message
            var refreshAlert = UIAlertController(title: "Game Over", message: (turn == .X ? "X" : "O") + " wins!", preferredStyle: UIAlertControllerStyle.Alert)
            presentViewController(refreshAlert, animated: true, completion: nil)
        }
        
        // alternate turns
        turn = turn == .X ? .O : .X;
    }
    
    /*
    CheckWinningLine is used by IsWinningLinePresent to see if three squares 
    have the same value (and that value is not BLANK)
    Note: We don't have to check if they're X's or O's, we just know that the last
    player to make a move is the winner.
    */
    func CheckWinningLine(row1: Int, column1: Int, row2: Int, column2: Int, row3: Int, column3: Int) -> Bool {
        var mark1 = GetSquareMark(TicTacToeSquare(row: row1, column: column1));
        var mark2 = GetSquareMark(TicTacToeSquare(row: row2, column: column2));
        var mark3 = GetSquareMark(TicTacToeSquare(row: row3, column: column3));
        
        if (mark1 != .BLANK &&
            mark1 == mark2 &&
            mark2 == mark3) {
            return true;
        }
        return false;
    }

    func GetSquareMark(square: TicTacToeSquare) -> SquareMark {
        var squareIndex = square.row * 3 + square.column;
        
        if (gameSquares[squareIndex].titleLabel?.text == "X") {
            return .X;
        }
        else if (gameSquares[squareIndex].titleLabel?.text == "O") {
            return .O;
        }
        else {
            return .BLANK;
        }
    }
    
    func SetSquareMark(square: TicTacToeSquare, mark: SquareMark) -> Void {
        var squareIndex = square.row * 3 + square.column;
        gameSquares[squareIndex].setTitle(mark == .X ? "X" : "O", forState:UIControlState.Normal);
    }
    
    func IsWinningLinePresent() -> Bool {
        // horizontal lines
        if (CheckWinningLine(0, column1: 0, row2: 0, column2: 1, row3: 0, column3: 2) ||
            CheckWinningLine(1, column1: 0, row2: 1, column2: 1, row3: 1, column3: 2) ||
            CheckWinningLine(2, column1: 0, row2: 2, column2: 1, row3: 2, column3: 2)) {
            return true;
        }
        
        // vertical lines
        if (CheckWinningLine(0, column1: 0, row2: 1, column2: 0, row3: 2, column3: 0) ||
            CheckWinningLine(0, column1: 1, row2: 1, column2: 1, row3: 2, column3: 1) ||
            CheckWinningLine(0, column1: 2, row2: 1, column2: 2, row3: 2, column3: 2)) {
            return true;
        }
        
        // diagonal lines
        if (CheckWinningLine(0, column1: 0, row2: 1, column2: 1, row3: 2, column3: 2) ||
            CheckWinningLine(2, column1: 0, row2: 1, column2: 1, row3: 0, column3: 2)) {
            return true;
        }
        
        return false;
    }
}

