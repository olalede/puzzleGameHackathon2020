//
//  AStarSearch.swift
//  HackathonPuzzleGame2020
//
//  Created by Damilare Olaleye on 2/23/20.
//  Copyright © 2020 Damilare Olaleye. All rights reserved.
//

import Foundation

func aStar (startState: Board, goalState: Board, heuristicFunction: HeuristicFunctionType, successorFunction: SuccessorFunctionType) -> [Int] {
    var heuristicValue = heuristicFunction(theState: startState)
    var openList: [SearchNode] = [SearchNode(board: startState, lastMoveIndex: nil, heuristicValue: heuristicValue, costValue: 0)]
    var closedList: [SearchNode] = []
    var daughters: [SearchNode] = []
    var winningPath: [Int] = []
    
  
    while true {
        if openList.isEmpty {
        
            print("Error: No path found")
            break
        }
        
     
        let currentNode = openList.removeAtIndex(0)
        closedList.append(currentNode)
        
        if currentNode.board == goalState {
            traceSolution(currentNode, startState, &winningPath)
            break
        }

      
        var daughters = successorFunction(currentNode: currentNode, heuristicFunction: heuristicFunction)
        
        var daughtersInOpenList = daughters.filter {
            $0.isInList(openList)
        }
        
        var daughtersInClosedList = daughters.filter {
            $0.isInList(closedList)
        }
        
        var daughtersNewToBothLists = daughters.filter {
            !$0.isInList(openList) && !$0.isInList(closedList)
        }
        openList += daughtersNewToBothLists
        
        updateOpenListWithBetterDaughters(daughtersInOpenList, &openList)
        updateClosedListWithBetterDaughters(daughtersInClosedList, &openList, &closedList)
        
        openList.sort {
            (aNode: SearchNode, bNode: SearchNode) -> Bool in
            let aActualWithEstimatedCost = aNode.costValue! + aNode.heuristicValue!
            let bActualWithEstimatedCost = bNode.costValue! + bNode.heuristicValue!
            
            return aActualWithEstimatedCost < bActualWithEstimatedCost
        }
    }
    
    return winningPath
}

func updateOpenListWithBetterDaughters(daughters: [SearchNode], openList: inout [SearchNode])  {
    for eachDaughter in daughters {
        for (index, openNode) in enumerate(openList) {
            if eachDaughter.board == openNode.board {
                if eachDaughter.costValue < openNode.costValue {
                    openList[index] = eachDaughter
                }

                break
            }
        }
    }
}

func updateClosedListWithBetterDaughters(daughters: [SearchNode], openList: inout [SearchNode], closedList: inout [SearchNode])  {
    for eachDaughter in daughters {
        for (index, closedNode) in enumerate(closedList) {
            if eachDaughter.board == closedNode.board {
                if eachDaughter.costValue! < closedNode.costValue! {
                    openList.removeAtIndex(index)
                    closedList.append(eachDaughter)
                }
                
                break
            }
        }
    }
}





