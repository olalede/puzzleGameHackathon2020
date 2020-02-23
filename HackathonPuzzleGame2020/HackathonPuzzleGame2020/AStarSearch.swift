//
//  AStarSearch.swift
//  HackathonPuzzleGame2020
//
//  Created by Damilare Olaleye on 2/23/20.
//  Copyright © 2020 Damilare Olaleye. All rights reserved.
//

import Foundation
import MBProgressHUD

func aStar (startState: Board, goalState: Board, heuristicFunction: @escaping HeuristicFunctionType, successorFunction: SuccessorFunctionType) -> [Int] {
    let heuristicValue = heuristicFunction(startState)
    var openList: [SearchNode] = [SearchNode(board: startState, lastMoveIndex: nil, heuristicValue: heuristicValue, costValue: 0)]
    var closedList: [SearchNode] = []
    var daughters: [SearchNode] = []
    var winningPath: [Int] = []
    
  
    while true {
        if openList.isEmpty {
        
            print("Error: No path found")
            break
        }
        
     
        let currentNode = openList.remove(at: 0)
        closedList.append(currentNode)
        
        if currentNode.board == goalState {
            traceSolution(goalNode: currentNode, startState: startState, winningMoves: &winningPath)
            break
        }

      
        let daughters = successorFunction(currentNode, heuristicFunction)
        
        let daughtersInOpenList = daughters.filter {
            $0.isInList(list: openList)
        }
        
        let daughtersInClosedList = daughters.filter {
            $0.isInList(list: closedList)
        }
        
        let daughtersNewToBothLists = daughters.filter {
            !$0.isInList(list: openList) && !$0.isInList(list: closedList)
        }
        openList += daughtersNewToBothLists
        
        updateOpenListWithBetterDaughters(daughters: daughtersInOpenList, openList: &openList)
        updateClosedListWithBetterDaughters(daughters: daughtersInClosedList, openList: &openList, closedList: &closedList)
        
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
        for (index, openNode) in openList.enumerated(){ //enumerate(openList) {
            if eachDaughter.board == openNode.board {
                if Unicode.CanonicalCombiningClass(rawValue: Unicode.CanonicalCombiningClass.RawValue(eachDaughter.costValue!)) < Unicode.CanonicalCombiningClass(rawValue: Unicode.CanonicalCombiningClass.RawValue(openNode.costValue!)) {
                    openList[index] = eachDaughter
                }

                break
            }
        }
    }
}

func updateClosedListWithBetterDaughters(daughters: [SearchNode], openList: inout [SearchNode], closedList: inout [SearchNode])  {
    for eachDaughter in daughters {
        for (index, closedNode) in closedList.enumerated() { //enumerate(closedList) {
            if eachDaughter.board == closedNode.board {
                if eachDaughter.costValue! < closedNode.costValue! {
                    openList.remove(at: index)    //removeAtIndex(index)
                    closedList.append(eachDaughter)
                }
                
                break
            }
        }
    }
}





