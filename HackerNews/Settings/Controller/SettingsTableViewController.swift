//
//  SettingsTableViewController.swift
//  HackerNews
//
//  Created by Рамиз Кичибеков on 02.03.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import UIKit
import HackerNewsKit

final class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
    }
    
    //MARK: - Custom methods
    
    private func configureController() {
        title = "Settings"
    }
    
    //MARK: - Actions
    
    @IBAction private func didTapClearButton(_ sender: UIButton) {
        SpotlightManager.deleteAllData()
    }
    
    @IBAction private func didChangeSwitch(_ sender: UISwitch) {
        UserDefaults.didSaveIndexingValue(sender.isOn)
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
