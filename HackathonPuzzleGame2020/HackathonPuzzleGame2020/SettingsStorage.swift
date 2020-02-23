//
//  SettingsStorage.swift
//  HackathonPuzzleGame2020
//
//  Created by Damilare Olaleye on 2/23/20.
//  Copyright © 2020 Damilare Olaleye. All rights reserved.
//

import Foundation
import MBProgressHUD


enum Settings: Int {
    case BreadthFirstSearch = 0, AStar
    case Count
    
    func description() -> String {
        switch self {
        case .BreadthFirstSearch:
            return "Breadth First Search"
        case .AStar:
            return "A* (Implementation in Progress)"
        default:
            return String(self.rawValue)
        }
    }
}

class SettingsStorage {
    
    let savedSearchSettingKey = "savedSearchSettingKey"
    
    var savedSearchSetting: Settings {
    get {
        if let rawValue = UserDefaults.standard.object(forKey: savedSearchSettingKey) as? Int {
            if let savedSetting = Settings.init(rawValue: rawValue) {
                return savedSetting
            }
        }
        
        let newSetting = Settings.AStar
        UserDefaults.standard.set(newSetting.rawValue, forKey: savedSearchSettingKey)
        UserDefaults.standard.synchronize()
        return newSetting
    }
    set {
        UserDefaults.standard.set(newValue.rawValue, forKey: savedSearchSettingKey)
        UserDefaults.standard.synchronize()
    }
    }
    
}

