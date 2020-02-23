//
//  SettingsViewController.swift
//  HackathonPuzzleGame2020
//
//  Created by Damilare Olaleye on 2/23/20.
//  Copyright © 2020 Damilare Olaleye. All rights reserved.
//

import UIKit
import MBProgressHUD


class SettingsViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Settings Cell", for: indexPath as IndexPath) as UITableViewCell
        cell.textLabel?.text = Settings.self(rawValue: indexPath.row)?.description()
        
        if let currentSetting = Settings.init(rawValue: indexPath.row)  { //fromRaw(indexPath.row) {
            switch currentSetting {
            case .BreadthFirstSearch, .AStar:
                cell.accessoryType = (currentSetting == savedSettings.savedSearchSetting) ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
                cell.selectionStyle = UITableViewCell.SelectionStyle.default
            default:
                break
        }
        }

        return cell
    }
    
    
   
    @IBOutlet weak var tableView: UITableView!

    var savedSettings: SettingsStorage!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings"
        
        assert(savedSettings != nil) 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return Settings.Count.rawValue
    }

    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if let currentSetting = Settings.init(rawValue: indexPath.row){
        //(indexPath.row) {
            switch currentSetting {
            case .BreadthFirstSearch, .AStar:
                cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
                deselectOtherSettings(currentSetting: currentSetting, tableView: tableView)
            default:
                break
            }
            
            savedSettings.savedSearchSetting = currentSetting
        }
    }
    
    func deselectOtherSettings(currentSetting: Settings, tableView: UITableView) {
        for rawValue in 0...Settings.Count.hashValue {
            if let eachSetting = Settings.init(rawValue: hashValue) {
                switch eachSetting {
                case .BreadthFirstSearch, .AStar:
                    if currentSetting != eachSetting {
                        let indexPath = NSIndexPath(row: rawValue, section: 0)
                        let cell = tableView.cellForRow(at: indexPath as IndexPath)
                        cell?.accessoryType = UITableViewCell.AccessoryType.none
                    }
                default:
                    break
                }
            }
        }
    }

}


extension UITableViewCell.AccessoryType {
    func toggleCheckmark() -> UITableViewCell.AccessoryType {
        switch self {
        case .checkmark:
            return .none
        case .none:
            return .checkmark
        default:
            return .none
        }
    }
}

