//
//  Alert.swift
//  HackathonPuzzleGame2020
//
//  Created by Damilare Olaleye on 2/22/20.
//  Copyright © 2020 Damilare Olaleye. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    
    private static func showAlert(on vc:UIViewController,with title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async { vc.present(alert, animated: true, completion: nil) }
    }
    static func showSolvedPuzzleAlert(on vc:UIViewController) {
        showAlert(on: vc, with: "", message: "Hurray!!!\n You have Solved this Puzzle ")
    }
    
}


