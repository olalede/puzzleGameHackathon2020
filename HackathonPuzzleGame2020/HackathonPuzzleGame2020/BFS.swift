//
//  BFS.swift
//  HackathonPuzzleGame2020
//
//  Created by Damilare Olaleye on 2/23/20.
//  Copyright © 2020 Damilare Olaleye. All rights reserved.
//  Breadth First Search


import Foundation
import MBProgressHUD

func bfs (startState: Board, goalState: Board, successorFunction: SuccessorFunctionType) -> [Int] {
    var openList: [SearchNode] = [SearchNode(board: startState, lastMoveIndex: nil, heuristicValue: nil, costValue: nil)]
    var closedList: [SearchNode] = []
    var daughters: [SearchNode] = []
    var winningPath: [Int] = []
    
    // begin the loop
    while true {
        if openList.isEmpty {
            print("Error: No path found")
            break
        }
        
        let currentNode = openList.remove(at: 0) //openList.removeAtIndex(0) 
        closedList.append(currentNode)
        
        if currentNode.board == goalState {
            
            traceSolution(goalNode: currentNode, startState: startState, winningMoves: &winningPath)
            break
        }
        
        var daughters = successorFunction(currentNode, nil)
        
       
        daughters = daughters.filter {
            !$0.isInList(list: openList) && !$0.isInList(list: closedList)
        }
        
        openList += daughters
    }
    
    return winningPath
}

