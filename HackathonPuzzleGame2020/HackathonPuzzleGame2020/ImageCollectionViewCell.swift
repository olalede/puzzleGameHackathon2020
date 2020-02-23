//
//  ImageCollectionViewCell.swift
//  HackathonPuzzleGame2020
//
//  Created by Damilare Olaleye on 2/22/20.
//  Copyright © 2020 Damilare Olaleye. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var puzzleImage: UIImageView!
   
    override func awakeFromNib() {
        self.frame = puzzleImage.frame
    }
    
}

