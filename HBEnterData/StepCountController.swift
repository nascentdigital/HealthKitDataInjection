//
//  StepCountController.swift
//  HBEnterData
//
//  Created by Allyson on 2017-02-08.
//  Copyright © 2017 Allyson. All rights reserved.
//

import UIKit
import HealthKit

class StepCountController: BaseClassController {
    
    var stepsArray = [Int]()
    @IBOutlet weak var leastSteps: UITextField!
    @IBOutlet weak var mostSteps: UITextField!

    
    //creating the data set to be sent to healthbook
    func createData(leastStep: Int, mostStep: Int, start: Date, end: Date) {
        let daysdifference = daysBetween(start: start as Date, end: end as Date)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyy"
        
        for _ in 0 ..< (daysdifference+1) {
            stepsArray.append(Int(arc4random_uniform(UInt32(mostStep)) + UInt32(leastStep)))
        }
        
        let calendar = Calendar.current
        for i in 0 ..< (daysdifference+1){
            daysArray.append(calendar.date(byAdding: .day, value: i, to: start)!)
        }
    }
    
    //ACTIVITY INDICATOR STUFF
    func unclickableSteps() {
    leastSteps.isEnabled = false
    mostSteps.isEnabled = false
    }
    
    func clickableSteps() {
        leastSteps.isEnabled = true
        mostSteps.isEnabled = true
        leastSteps.text="0"
        mostSteps.text="0"
    }
    
    func useSaveButton(){
            var leastStepCount = Int(leastSteps.text!)
            if (leastSteps.text == "") {
                leastStepCount = 0
            }
            var mostStepCount = Int(mostSteps.text!)
            if (mostSteps.text == "") {
                mostStepCount = 0
            }
            let startDate = leastDateRange.date
            let endDate = mostDateRange.date
            createData(leastStep: leastStepCount!, mostStep: mostStepCount!, start: startDate, end: endDate)
            unclickable()
            unclickableSteps()
            for i in 0 ..< self.stepsArray.count  {
                    HealthManager.sharedInstance.saveSteps(stepsRecorded: self.stepsArray[i], date: self.daysArray[i] as NSDate)
                }
            var when = DispatchTime.now() + 2
        
            if (self.stepsArray.count > 365) {
                when = DispatchTime.now() + 4
            }
    
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.clickable()
                self.clickableSteps()
            }
    }
    
    @IBAction func saveButton(_ sender: Any ) {
        useSaveButton()
    }
}

