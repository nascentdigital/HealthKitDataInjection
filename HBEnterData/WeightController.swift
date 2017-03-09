//
//  WeightController.swift
//  HBEnterData
//
//  Created by Allyson on 2017-02-14.
//  Copyright © 2017 Allyson. All rights reserved.
//

import UIKit
import HealthKit

class WeightController: BaseClassController {
    
    var weightArray = [Int]()
    
    @IBOutlet weak var leastWeight: UITextField!
    @IBOutlet weak var mostWeight: UITextField!
    @IBOutlet weak var frequency: UILabel!
    @IBOutlet weak var stepper: UIStepper!

    
    @IBAction func stepperValueChanged(_ sender: Any) {
        let value: Int = Int(stepper.value)
        frequency.text = String(value)
    }

    //calculating days between
    func daysBetweenWeight(start: Date, end: Date, frequency: Int) -> Int {
        let days = Int(Calendar.current.dateComponents([.day], from: start, to: end).day!)
        return (days + 2) / frequency
    }
    
    //creating the data set to be sent to healthbook
    func createData(leastWeightValue: Int, mostWeightValue: Int, start: Date, end: Date, frequencyValue: Int) {
        let length = daysBetweenWeight(start: start as Date, end: end as Date, frequency: frequencyValue)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyy"
        
        for _ in 0 ..< (length + 1) {
            weightArray.append(Int(arc4random_uniform(UInt32(mostWeightValue)) + UInt32(leastWeightValue)))
        }
        
        let calendar = Calendar.current
        daysArray.append(start)
        for i in 1 ..< (length + 1){
            daysArray.append(calendar.date(byAdding: .day, value: frequencyValue, to: daysArray[i-1])!)
        }
    }
    
    //ACTIVITY INDICATOR STUFF
    func unclickableWeight() {
        leastWeight.isEnabled = false
        mostWeight.isEnabled = false
    }
    
    func clickableWeight() {
        leastWeight.isEnabled = true
        mostWeight.isEnabled = true
        leastWeight.text=""
        mostWeight.text=""
        frequency.text="1"
        leastDateRange.date = current
    }
    func useSaveButton(){
        var leastWeightValue = Int(leastWeight.text!)
        if (leastWeight.text == "") {
            leastWeightValue = 0
        }
        var mostWeightValue = Int(mostWeight.text!)
        if (mostWeight.text == "") {
            mostWeightValue = 0
        }
        let frequencyValue = Int(frequency.text!)
        let startDate = leastDateRange.date
        let endDate = mostDateRange.date
        createData(leastWeightValue: leastWeightValue!, mostWeightValue: mostWeightValue!, start: startDate, end: endDate, frequencyValue: frequencyValue!)
        unclickable()
        unclickableWeight()
        for i in 0 ..< (self.weightArray.count) {
            HealthManager.sharedInstance.saveWeight(weightRecorded: self.weightArray[i], date: self.daysArray[i] as NSDate)
        }
        
        var when = DispatchTime.now() + 2
        
        if (self.weightArray.count > 365) {
            when = DispatchTime.now() + 4
        }
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.clickable()
            self.clickableWeight()
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        useSaveButton()
    }
}
