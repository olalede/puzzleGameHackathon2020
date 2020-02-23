//
//  HacktonPuzzle.swift
//  HackathonPuzzleGame2020
//
//  Created by Damilare Olaleye on 2/22/20.
//  Copyright © 2020 Damilare Olaleye. All rights reserved.
//

import Foundation

class HacktonPuzzle: Codable{
    var title: String
    var unsolvedImages: [String]
    var solvedImages: [String]
    
    init(title: String, solvedImages: [String]){
        
        //model class for the puzzle
        self.title = title
        self.solvedImages = solvedImages
        self.unsolvedImages = self.solvedImages.shuffled()
    }
   
}
