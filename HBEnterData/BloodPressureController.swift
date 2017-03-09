//
//  BloodPressureController.swift
//  HBEnterData
//
//  Created by Allyson on 2017-02-13.
//  Copyright © 2017 Allyson. All rights reserved.
//

import UIKit
import HealthKit


class BloodPressureController: BaseClassController {
    
    var systolicArray = [Int]()
    var dystolicArray = [Int]()
    
    @IBOutlet weak var leastSystolic: UITextField!
    @IBOutlet weak var mostSystolic: UITextField!
    @IBOutlet weak var leastDystolic: UITextField!
    @IBOutlet weak var mostDystolic: UITextField!
    
    //creating the data set to be sent to healthbook
    func createData(leastSystolic: Int, mostSystolic: Int, leastDystolic: Int, mostDystolic: Int, start: Date, end: Date) {
        let daysdifference = daysBetween(start: start as Date, end: end as Date)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyy"
        
        for _ in 0 ..< (daysdifference+1) {
            systolicArray.append(Int(arc4random_uniform(UInt32(mostSystolic)) + UInt32(leastSystolic)))
            dystolicArray.append(Int(arc4random_uniform(UInt32(mostDystolic)) + UInt32(leastDystolic)))
        }
        
        let calendar = Calendar.current
        for i in 0 ..< (daysdifference+1){
            daysArray.append(calendar.date(byAdding: .day, value: i, to: start)!)
        }
    }
    
    //ACTIVITY INDICATOR STUFF
    func unclickableBP() {
        leastSystolic.isEnabled = false
        mostSystolic.isEnabled = false
        leastDystolic.isEnabled = false
        mostDystolic.isEnabled = false
    }
    
    func clickableBP() {
        loader.isHidden = true
        mostSystolic.isEnabled = true
        leastDystolic.isEnabled = true
        mostDystolic.isEnabled = true
        leastSystolic.text = ""
        mostSystolic.text=""
        leastDystolic.text=""
        mostDystolic.text=""
    }
    
    func useSaveButton(){
        var leastSystolicCount = Int(leastSystolic.text!)
        if (leastSystolic.text == "") {
            leastSystolicCount = 0
        }
        var mostSystolicCount = Int(mostSystolic.text!)
        if (mostSystolic.text == "") {
            mostSystolicCount = 0
        }
        var leastDystolicCount = Int(leastDystolic.text!)
        if (leastDystolic.text == "") {
            leastDystolicCount = 0
        }
        var mostDystolicCount = Int(mostDystolic.text!)
        if (mostDystolic.text == "") {
            mostDystolicCount = 0
        }
        let startDate = leastDateRange.date
        let endDate = mostDateRange.date
        unclickable()
        unclickableBP()
        createData(leastSystolic: leastSystolicCount!, mostSystolic: mostSystolicCount!, leastDystolic: leastDystolicCount!, mostDystolic: mostDystolicCount!, start: startDate, end: endDate)
        for i in 0 ..< self.systolicArray.count  {
            HealthManager.sharedInstance.saveStepsBlood(systolicRecorded: self.systolicArray[i], dystolicRecorded: self.dystolicArray[i], date: self.daysArray[i] as NSDate)
        }
        
        var when = DispatchTime.now() + 3
        
        if (self.systolicArray.count >= 365 && self.systolicArray.count < 1825) {
            when = DispatchTime.now() + 5
        }
        else if (self.systolicArray.count <= 1825 && self.systolicArray.count > 365) {
            when = DispatchTime.now() + 10
        }
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.clickable()
            self.clickableBP()
        }
    }
 
    @IBAction func saveButton(_ sender: Any) {
        useSaveButton()
    }
}

