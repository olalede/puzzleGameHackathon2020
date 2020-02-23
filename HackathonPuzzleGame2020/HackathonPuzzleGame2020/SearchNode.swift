//
//  SearchNode.swift
//  HackathonPuzzleGame2020
//
//  Created by Damilare Olaleye on 2/23/20.
//  Copyright © 2020 Damilare Olaleye. All rights reserved.
//

import Foundation
import MBProgressHUD


class SearchNode: CustomStringConvertible {
    var board: Board
    var lastMoveIndex: Int?
    var children: [SearchNode] = []

    weak var parent: SearchNode?
    var heuristicValue: Double?
    var costValue: Double?
    
    init (board: Board, lastMoveIndex: Int?, heuristicValue: Double?, costValue: Double?) {
        self.board = board
        self.lastMoveIndex = lastMoveIndex
        self.heuristicValue = heuristicValue
        self.costValue = costValue
    }
    
    /// Iterates through the list array O(N)
    /// This is an example of writing a documentation comment
    func isInList (list: [SearchNode]) -> Bool {
        for eachNode in list {
            let thisBoard = eachNode.board
            if thisBoard == board {
                return true
            }
        }
        
        return false
    }
    
    var description: String {
    return "(board = \(board), lastMoveIndex = \(lastMoveIndex))"
    }
}

typealias SuccessorFunctionType = (_ currentNode: SearchNode, _ heuristicFunction: HeuristicFunctionType?) -> [SearchNode]

func successorFunction (currentNode: SearchNode, heuristicFunction: HeuristicFunctionType?) -> [SearchNode] {
    var indexThatCanMove = currentNode.board.indexesThatCanMove()
    var successorNodes = [SearchNode]()
    
    for index in indexThatCanMove {
        let childBoard = Board(board: currentNode.board) // make copy of board
        childBoard.movePiece(index: index)
        let costOfMove = cost(currentState: currentNode.board, nextState: childBoard)
        var heuristicValue: Double?
        if let heuristicFunctionUnwrapped = heuristicFunction {
            heuristicValue = heuristicFunctionUnwrapped(currentNode.board)
        }
        
        let childNode = SearchNode(board: childBoard, lastMoveIndex: index, heuristicValue: heuristicValue, costValue: costOfMove)
        childNode.parent = currentNode
        currentNode.children.append(childNode)
        
        successorNodes.append(childNode)
    }
    
    return successorNodes
}

func cost (currentState: Board, nextState: Board) -> Double {
    // can only move one square in Fifteen Puzzle. Every move is equal.
    return 1
}

func traceSolution (goalNode: SearchNode, startState: Board, winningMoves: inout [Int]) {
    
    if let lastMove = goalNode.lastMoveIndex {
        if let parent = goalNode.parent {
            winningMoves.append(lastMove)
            traceSolution(goalNode: parent, startState: startState, winningMoves: &winningMoves)
        }
    } else {
        // end of the line
        winningMoves = winningMoves.reversed()
    }
}

typealias HeuristicFunctionType = (_ theState: Board) -> Double

func straightLightDistanceHeuristic (theState: Board) -> Double {
    var straightLineDistances = Double()
    var sum: Double = 0
    
    for (index, _) in theState.pieces.enumerated(){ //enumerate(theState.pieces) {
        let sld = straightLineDistance(index: index, theState: theState)
        sum += sld
    }
    
    return sum
}

func straightLineDistance (index: Int, theState: Board) -> Double {
    let coordinateOfIndex = theState.indexToCoordinate(index: index)
    let coordinateOfGoal = theState.indexToCoordinate(index: theState.pieces[index].winningIndex)
    
    let xDistance = abs(coordinateOfIndex.x - coordinateOfGoal.x)
    let yDistance = abs(coordinateOfGoal.y - coordinateOfGoal.y)
    
    let squaredX = Double(xDistance * xDistance)
    let squaredY = Double(yDistance * yDistance)
    
    return sqrt(squaredX + squaredY)
}

