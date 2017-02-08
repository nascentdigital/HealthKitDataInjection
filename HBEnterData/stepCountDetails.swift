//
//  stepCountDetails.swift
//  HBEnterData
//
//  Created by Allyson on 2017-02-08.
//  Copyright © 2017 Allyson. All rights reserved.
//

import UIKit
import HealthKit

class stepCountDetails: UIViewController {
    
    let healthKitStore = HKHealthStore()
    let current = Date()
    var stepsArray = [Int]()
    var daysArray = [Date]()

    @IBOutlet weak var leastSteps: UITextField!
    @IBOutlet weak var mostSteps: UITextField!
    @IBOutlet weak var leastDateRange: UIDatePicker!
    @IBOutlet weak var mostDateRange: UIDatePicker!
    
    @IBAction func saveButton(_ sender: Any) {
        //save date range and value range for specific detail
        let leastStepCount = Int(leastSteps.text!)
        let mostStepCount = Int(mostSteps.text!)
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "MM dd, yyy"
        let startDate = leastDateRange.date
        let endDate = mostDateRange.date
        createData(leastStep: leastStepCount!, mostStep: mostStepCount!, start: startDate, end: endDate)
        for i in 0 ..< stepsArray.count  {
            HealthManager.sharedInstance.saveSteps(stepsRecorded: stepsArray[i], date: daysArray[i] as NSDate)
        }
        leastSteps.text = ""
        mostSteps.text = ""
        _ = navigationController?.popViewController(animated: true)

    }
    
    //calculating days between
    func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    //creating the data set to be sent to healthbook
    func createData(leastStep: Int, mostStep: Int, start: Date, end: Date) {
        let daysdifference = daysBetween(start: start as Date, end: end as Date)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyy"
        
        for _ in 0 ..< (daysdifference+2) {
            stepsArray.append(Int(arc4random_uniform(UInt32(mostStep)) + UInt32(leastStep)))
        }
        
        let calendar = Calendar.current
        for i in 0 ..< (daysdifference+2){
            daysArray.append(calendar.date(byAdding: .day, value: i, to: start)!)
        }
    }
    
    
}
