//
//  ResultsViewController.swift
//  HackathonPuzzleGame2020
//
//  Created by Damilare Olaleye on 2/23/20.
//  Copyright © 2020 Damilare Olaleye. All rights reserved.
//

import Foundation
import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var winner: UILabel!
    @IBOutlet weak var SiriChoice: UILabel!
    @IBOutlet weak var PlayerChoice: UILabel!
    
    
    @IBOutlet weak var playAgain: UIButton!
    
    var siriChoiceFromVC: String?
    var playerChoiceFromVC: String?
    var winnerFromVC: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SiriChoice.text = siriChoiceFromVC
        PlayerChoice.text = playerChoiceFromVC
        winner.text = winnerFromVC
        
        playAgain.layer.cornerRadius = 5
        playAgain.layer.borderWidth = 1
        playAgain.layer.borderColor = UIColor.black.cgColor
    }
    

    @IBAction func Dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
