//
//  SettingsViewController.swift
//  HackathonPuzzleGame2020
//
//  Created by Damilare Olaleye on 2/23/20.
//  Copyright © 2020 Damilare Olaleye. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController, UITableViewDataSource {
    
   
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

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Settings Cell", for: indexPath as IndexPath) as UITableViewCell
        cell.textLabel?.text = Settings.fromRaw(indexPath.row).description()
        
        if let currentSetting = Settings.fromRaw(indexPath.row) {
            switch currentSetting {
            case .BreadthFirstSearch, .AStar:
                cell.accessoryType = (currentSetting == savedSettings.savedSearchSetting) ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None
                cell.selectionStyle = UITableViewCell.SelectionStyle.default
            default:
                break
        }
        }

        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if let currentSetting = Settings.fromRaw(indexPath.row) {
            switch currentSetting {
            case .BreadthFirstSearch, .AStar:
                cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
                deselectOtherSettings(currentSetting, tableView: tableView)
            default:
                break
            }
            
            savedSettings.savedSearchSetting = currentSetting
        }
    }
    
    func deselectOtherSettings(currentSetting: Settings, tableView: UITableView) {
        for rawValue in 0...Settings.Count.toRaw() {
            if let eachSetting = Settings.fromRaw(rawValue) {
                switch eachSetting {
                case .BreadthFirstSearch, .AStar:
                    if currentSetting != eachSetting {
                        let indexPath = NSIndexPath(forRow: rawValue, inSection: 0)
                        let cell = tableView.cellForRowAtIndexPath(indexPath)
                        cell.accessoryType = UITableViewCellAccessoryType.None
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

