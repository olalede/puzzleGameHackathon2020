//
//  PieceView.swift
//  HackathonPuzzleGame2020
//
//  Created by Damilare Olaleye on 2/23/20.
//  Copyright © 2020 Damilare Olaleye. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class PieceView: UIView {
    var pieceLabel = UILabel()
    
    init(frame: CGRect, labelText: String?, boardPiece: Piece) {
        super.init(frame: frame)
        
        if let textString = labelText {
            pieceLabel.text = textString
            pieceLabel.textAlignment = NSTextAlignment.center
            pieceLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            pieceLabel.backgroundColor = UIColor.clear
            
            addSubview(pieceLabel)
        }
        
        self.backgroundColor = UIColor.green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
