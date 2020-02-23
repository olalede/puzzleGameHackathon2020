//
//  ViewControllerRPS.swift
//  HackathonPuzzleGame2020
//
//  Created by Damilare Olaleye on 2/23/20.
//  Copyright © 2020 Damilare Olaleye. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerRPS: UIViewController {
    
    static var winner: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func randomSiriMove() -> String {
        let choice = Int(arc4random_uniform(3))
        switch choice {
        case 0:
            return "rock"
        case 1:
            return "paper"
        case 2:
            return "scissors"
        default:
            return "Something has gone wrong"
        }
    }
    
    func getPlayerChoice(_ userChoice: UIButton) -> String {
        let choice = userChoice.tag
        switch choice {
        case 0:
            return "rock"
        case 1:
            return "paper"
        case 2:
            return "scissors"
        default:
            return "Something has gone wrong"
        }
    }
    
    func findWinner(_ botChoice: String, _ playerChoice: String) -> String {
        if (playerChoice != botChoice) {
            switch playerChoice {
            case "rock":
                if (botChoice == "paper") {
                    return "Siri Wins"
                }else {
                    return "You Win!"
                }
                
            case "paper":
                if (botChoice == "scissors") {
                    return "Siri Wins"
                }else {
                    return "You Win!"
                }
                
            case "scissors":
                if (botChoice == "rock") {
                    return "Siri Wins"
                }else {
                    return "You Win!"
                }
            default:
                return "Something has gone wrong"
            }
        }
        else {
            return "Its a Tie. Play Again.";
        }
    }
    
    @IBAction func play(_ playerMoveChoice: UIButton) {
    // @IBOutlet weak var play: UIButton!
            performSegue(withIdentifier: "showResults", sender: playerMoveChoice)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any? ) {

        if segue.identifier == "showResults" {
            let controller = segue.destination as! ResultsViewController
            let siriChoice: String = randomSiriMove()
            let playerChoice: String = getPlayerChoice((sender as? UIButton)!)
            let winner: String = findWinner(siriChoice, playerChoice)
            
            controller.siriChoiceFromVC = siriChoice
            controller.playerChoiceFromVC = playerChoice
            controller.winnerFromVC = winner
        }
    }
}


