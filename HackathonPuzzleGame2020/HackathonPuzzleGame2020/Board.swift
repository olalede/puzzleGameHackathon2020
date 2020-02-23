//
//  Board.swift
//  HackathonPuzzleGame2020
//
//  Created by Damilare Olaleye on 2/23/20.
//  Copyright © 2020 Damilare Olaleye. All rights reserved.
//

import Foundation


func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
    return (lhs.y == rhs.y) && (lhs.x == rhs.x)
}

struct Coordinate: Printable {
    var x: Int
    var y: Int
    
    init (x: Int, y: Int) {
        self.y = y
        self.x = x
    }
    
    var description: String {
    return "Coordinate (x: \(x), y: \(y))"
    }
}
func == (lhs: Piece, rhs: Piece) -> Bool {
    return ((lhs.pieceName == rhs.pieceName) && (lhs.winningIndex == rhs.winningIndex))
}

func != (lhs: Piece, rhs: Piece) -> Bool {
    return !(lhs == rhs)
}

class Piece: Printable, Equatable {
    let pieceName: String
    let winningIndex: Int
    
    init (pieceName: String, winningIndex: Int) {
        self.pieceName = pieceName
        self.winningIndex = winningIndex
        
    }
    
    var description: String {
    return "Piece (name: \(pieceName))\n"
    }
    
}

func == (lhs: Board, rhs: Board) -> Bool {
    var isSame = lhs.pieces.count == rhs.pieces.count
    
    if isSame {
        for i in 0...lhs.pieces.count {
            if lhs.pieces[i] != rhs.pieces[i] {
                isSame = false
                break
            }
        }
    }
    
    return isSame
}

class Board: Printable {
    var pieces = [Piece]()
    let columns: Int
    let rows: Int
    var empty: Int
    var winningLocations: Int
    let gameWonNotification = "GameWon"
    
    init (rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        self.empty = rows * columns - 1
        self.winningLocations = rows * columns - 1
        
        var i = 0
        for row in 0...rows {
            for col in 0...columns {
                pieces.append(Piece(pieceName: "\(i)", winningIndex: i+=1))
            }
        }
    }
    
    convenience init (board: Board) {
        self.init(rows: board.rows, columns: board.columns);
        empty = board.empty
        winningLocations = board.winningLocations
        pieces = board.pieces.copy()
    }
    
    var description: String {
    return "Pieces \(pieces)"
    }
    
    func coordinateToIndex (coordinate: Coordinate) -> Int {
        return coordinate.y * rows + coordinate.x
    }
    
    func indexToCoordinate (index: Int) -> Coordinate {
        assert(rows != 0)
        let y = index / rows
        let x = index % rows
        
        return Coordinate(x: x, y: y)
    }
    
    func indexesThatCanMove () -> [Int] {
        let coordinatesOfPiecesThatCanMove = availableMoves(index: empty)
        var indexesArray = [Int]()
        
        for eachCoordinate in coordinatesOfPiecesThatCanMove {
            let index = coordinateToIndex(coordinate: eachCoordinate)
            indexesArray.append(index)
        }
        
        assert(indexesArray.count >= 2)
        
        return indexesArray
    }
    
    func shufflePiece () -> Int {
        let indexes = indexesThatCanMove()
        let randomInRange = Int(arc4random()) % indexes.count
    
        return indexes[randomInRange]
    }
    
    func shuffleList (moves: Int) -> [Int]? {
        let board = Board(board: self)
        var indexesOfPiecesToMove = Array<Int>()
        
        for _ in 0...moves {
            let indexOfPieceToMove = board.shufflePiece()
            board.movePiece(index: indexOfPieceToMove)
            
            indexesOfPiecesToMove.append(indexOfPieceToMove)
        }
        
        return indexesOfPiecesToMove
    }
    
    func availableMoves (index: Int) -> [Coordinate] {
        let checkMovements = [(0, -1), (1, 0), (0, 1), (-1, 0)]
        let maxX = self.columns - 1
        let maxY = self.rows - 1
        let currentPosition = indexToCoordinate(index: index)
        
        let positions = checkMovements.map( { Coordinate(x: currentPosition.x + $0.0, y: currentPosition.y + $0.1) } )
            .filter( { $0.x >= 0 && $0.y >= 0 && $0.x <= maxX && $0.y <= maxY })
        
        return positions;
    }
    
    func movePiece (index: Int) -> Coordinate? {
        var possibleDestinations = availableMoves(index: index)
        var destinationCoordinate: Coordinate?
        let emptyCoordinate = indexToCoordinate(index: empty)
        
        for eachCoordinate in possibleDestinations {
            if eachCoordinate == emptyCoordinate {
                destinationCoordinate = indexToCoordinate(index: empty)
                let destinationIndex = empty
                let oldIndex = index

                swap(&pieces[oldIndex], &pieces[destinationIndex])
                empty = oldIndex
                
                if pieces[destinationIndex].winningIndex == destinationIndex {
                    winningLocations+=1
                } else {
                    winningLocations-=1
                }
                
                if winningLocations == rows * columns - 1 {
                    NotificationCenter.defaultCenter().postNotification(NSNotification(name: gameWonNotification, object: nil))
                }
                
                break;
            }
        }
        
        return destinationCoordinate
    }
    
}
