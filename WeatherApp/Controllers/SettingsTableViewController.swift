//
//  SettingsTableViewController.swift
//  WeatherApp
//
//  Created by Veerababu Mulugu on 29/05/23.
//

import Foundation
import UIKit

protocol SettingsDelegate: AnyObject {
    func settingsDone(vm: SettingsViewModel)
}

class SettingsTableViewController: UITableViewController {
    private var settingsViewModel = SettingsViewModel()
    weak var delegate: SettingsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func done() {
        delegate?.settingsDone(vm: settingsViewModel)
        dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.visibleCells.forEach { cell in
            cell.accessoryType = .none
        }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            let unit = settingsViewModel.units[indexPath.row]
            settingsViewModel.selectedUnit = unit
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsViewModel.units.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsItem = settingsViewModel.units[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        cell.textLabel?.text = settingsItem.displayName
        
        if settingsItem == settingsViewModel.selectedUnit {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
}
