//
//  PuzzleViewController.swift
//  HackathonPuzzleGame2020
//
//  Created by Damilare Olaleye on 2/23/20.
//  Copyright © 2020 Damilare Olaleye. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class PuzzleViewController: UIViewController {
    
    var boardBackground = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 300)))
    var boardGame = Board(rows: 4, columns: 4)
    let frameBuffer: CGFloat = 10.0
    let pieceBuffer: CGFloat = 2.0
    var viewsForPieces: [PieceView] = []
    var shufflingOrSolving = false
    var lastSuggestedIndex: Int?
    var settings = SettingsStorage()
    
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)!
       // viewsForPieces =  generateViewsForAllPieces()
    }
    
    var sizeOfSquare: (width: CGFloat, height: CGFloat) {
    get {
        let width = (boardBackground.frame.size.width - frameBuffer * 2 - pieceBuffer * (CGFloat(boardGame.columns) - 1.0)) / CGFloat(boardGame.columns)
        let height = (boardBackground.frame.size.height - frameBuffer * 2 - pieceBuffer * (CGFloat(boardGame.rows) - 1.0)) / CGFloat(boardGame.rows)
        
        return (width, height)
    }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardBackground.backgroundColor = UIColor.yellow
        self.view.addSubview(boardBackground)
        boardBackground.center = self.view.center;
        _ = boardGame.empty
        for y in 0...boardGame.rows {
            for x in 0...boardGame.columns {
                let boardIndex = boardGame.coordinateToIndex(coordinate: Coordinate(x: x, y: y))
                if boardIndex != boardGame.empty {
                    let theView = viewsForPieces[boardIndex]
                    boardBackground.addSubview(theView)
                    
                    theView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector(("tapButton:"))))
                }
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: Selector(("gameWon")), name: NSNotification.Name(rawValue: boardGame.gameWonNotification), object: nil)
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func shuffleButtonPressed(_ sender: UIButton) {
        shufflingOrSolving = true
        
        if let shuffleList = boardGame.shuffleList(moves: 4) {
            for eachIndex in shuffleList {
                movePieceViewWithIndex(index: eachIndex)
            }
        }
        
        shufflingOrSolving = false
    }
    
    
    
    @IBAction func solveButtonPressed(_ sender: UIButton) {
        shufflingOrSolving = true
        
        clearOldSuggestedPieceView()
        
        let goalState = Board(rows: 4, columns: 4)
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = "Solving"
        let searchQueue = DispatchQueue(__label: "searchQueue", attr: nil)
        searchQueue.async() {
            var winningPath: [Int]?
            switch self.settings.savedSearchSetting {
            case .AStar:
                winningPath = aStar(startState: self.boardGame, goalState: goalState, heuristicFunction: straightLightDistanceHeuristic, successorFunction: successorFunction)
            case .BreadthFirstSearch:
                winningPath = bfs(startState: self.boardGame, goalState: goalState, successorFunction: successorFunction)
            default:
                print("Error: unexpected case (file: \(#file), function: \(#function), line: \(#line))")
            }
            DispatchQueue.main.async {
                if let unwrappedWinningPath = winningPath {
                    if unwrappedWinningPath.count > 0 {
                        UIView.animate(withDuration: 0.25) {
                            self.lastSuggestedIndex = unwrappedWinningPath[0]
                            self.viewsForPieces[unwrappedWinningPath[0]].backgroundColor = UIColor.red
                        }
                        self.shufflingOrSolving = false
                    }
                }
                
                hud.hide(animated: true)
            }
        }
    }
    
    func clearOldSuggestedPieceView () {
        if let oldSuggestedIndex = self.lastSuggestedIndex {
            self.viewsForPieces[oldSuggestedIndex].backgroundColor = UIColor.green
        }
    }
    
    func gameWon () {
        if !shufflingOrSolving {
            let alert = UIAlertController(title: "You Won!!", message: "Good Job! You won the game", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
            self.present(alert, animated: true)
        }
    }
    
    func movePieceViewWithIndex (index: Int) {
        let pieceView = viewsForPieces[index]
        
        if let toCoordinate = boardGame.movePiece(index: index) {
            movePieceView(pieceView: pieceView, toCoordinate: toCoordinate)
            let destinationIndex = boardGame.coordinateToIndex(coordinate: toCoordinate)
            pieceView.tag = destinationIndex
            
            swap(&viewsForPieces[destinationIndex], &viewsForPieces[index])
        }
    }
    
    func tapButton (tap: UITapGestureRecognizer) {
        if let pieceViewTapped = tap.view as? PieceView {
            let index = pieceViewTapped.tag
            movePieceViewWithIndex(index: index)
        }
    }
    
    func movePieceView (pieceView: PieceView, toCoordinate: Coordinate) {
        // animate square moving to new location
        let newFrame = getFrameForPiece(column: toCoordinate.x, row: toCoordinate.y)
        UIView.animate(withDuration: 0.25) {
            pieceView.frame = newFrame
            
            self.clearOldSuggestedPieceView()
        }
    }
    
    func getOriginForPiece (column: Int, row: Int) -> (CGFloat, CGFloat) {
        let x = frameBuffer + pieceBuffer * CGFloat(column) + CGFloat(column) * sizeOfSquare.width
        let y = frameBuffer + pieceBuffer * CGFloat(row) + CGFloat(row) * sizeOfSquare.height
        
        return (x, y)
    }
    
    func getFrameForPiece (column: Int, row: Int) -> CGRect {
        let (x, y) = getOriginForPiece(column: column, row: row)
        let (width, height) = sizeOfSquare
        
        return CGRect.init(x: x, y: y, width: width, height: height)
    
    func generateViewsForAllPieces () -> [PieceView] {
        var peiceViews = [PieceView]()
        
        for y in 0...boardGame.rows {
            for x in 0...boardGame.columns {
                let boardIndex = boardGame.coordinateToIndex(coordinate: Coordinate(x: x, y: y))
                let piece = boardGame.pieces[boardIndex]
                let labelText = piece.pieceName
                let pieceView = PieceView(frame: getFrameForPiece(column: x, row: y), labelText: labelText, boardPiece: piece)
                pieceView.tag = boardIndex
                

                peiceViews.append(pieceView)
            }
        }
        
        return peiceViews
    }
    
        func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
          if segue.identifier == "Show Settings" {
            if let settingsViewController = segue.destination as? SettingsViewController {
                  settingsViewController.savedSettings = settings
              }
          }
      }

}
    
}
