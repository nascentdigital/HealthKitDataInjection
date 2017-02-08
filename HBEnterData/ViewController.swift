//
//  ViewController.swift
//  HBEnterData
//
//  Created by Allyson on 2017-02-06.
//  Copyright © 2017 Allyson. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UITableViewController {
    
    let healthKitStore = HKHealthStore()
    
    let options = ["Step Count"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);

        func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
            view.tintColor = UIColor.red
            let header = view as! UITableViewHeaderFooterView
            header.textLabel?.textColor = UIColor.white
        }
        
        
        HealthManager.sharedInstance.requestHKAuthorization { (true, error) in}}

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }


}
