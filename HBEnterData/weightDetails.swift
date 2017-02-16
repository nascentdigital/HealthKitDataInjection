//
//  weightDetails.swift
//  HBEnterData
//
//  Created by Allyson on 2017-02-14.
//  Copyright © 2017 Allyson. All rights reserved.
//

import UIKit
import HealthKit
import PromiseKit


class weightDetails: UIViewController {
    
    let healthKitStore = HKHealthStore()
    let current = Date()
    var weightArray = [Int]()
    var daysArray = [Date]()
    
    @IBOutlet weak var leastWeight: UITextField!
    @IBOutlet weak var mostWeight: UITextField!
    @IBOutlet weak var leastDateRange: UIDatePicker!
    @IBOutlet weak var mostDateRange: UIDatePicker!
    @IBOutlet weak var loaderBack: UIImageView!
    @IBOutlet weak var loader: UIImageView!
    @IBOutlet weak var loadingText: UITextField!
    @IBOutlet weak var submit: UIBarButtonItem!
    @IBOutlet weak var frequency: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.loadGif(name: "leftshark")
        loader.isHidden = true
        loaderBack.alpha = 0.8
        loaderBack.isHidden = true
        loadingText.isHidden = true
        
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 20
        stepper.value = 1;
        
        mostDateRange.maximumDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())

        
    }
    
    @IBAction func stepperValueChanged(_ sender: Any) {
        let value: Int = Int(stepper.value)
        frequency.text = String(value)
    }

    //calculating days between
    func daysBetween(start: Date, end: Date, frequency: Int) -> Int {
        let days = Int(Calendar.current.dateComponents([.day], from: start, to: end).day!)
        return (days + 2) / frequency
    }
    
    //creating the data set to be sent to healthbook
    func createData(leastWeightValue: Int, mostWeightValue: Int, start: Date, end: Date, frequencyValue: Int) {
        let length = daysBetween(start: start as Date, end: end as Date, frequency: frequencyValue)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyy"
        
        for _ in 0 ..< (length+1) {
            weightArray.append(Int(arc4random_uniform(UInt32(mostWeightValue)) + UInt32(leastWeightValue)))
        }
        
        let calendar = Calendar.current
        daysArray.append(start)
        for i in 1 ..< (length + 1){
            daysArray.append(calendar.date(byAdding: .day, value: frequencyValue, to: daysArray[i-1])!)
        }
    }
    
    //ACTIVITY INDICATOR STUFF
    
    func unclickable() {
        submit.isEnabled = false
        leastDateRange.isEnabled = false
        mostDateRange.isEnabled = false
        loader.isHidden = false
        loaderBack.isHidden = false
        leastWeight.isEnabled = false
        mostWeight.isEnabled = false
        loadingText.isHidden = false
        navigationItem.hidesBackButton = true
    }
    
    func clickable() {
        submit.isEnabled = true
        leastDateRange.isEnabled = true
        mostDateRange.isEnabled = true
        loader.isHidden = true
        loaderBack.isHidden = true
        leastWeight.isEnabled = true
        mostWeight.isEnabled = true
        loadingText.isHidden = true
        navigationItem.hidesBackButton = false
        leastWeight.text=""
        mostWeight.text=""
        frequency.text="1"
        leastDateRange.date = current
        mostDateRange.date = current
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
        for i in 0 ..< (self.weightArray.count) {
            HealthManager.sharedInstance.saveWeight(weightRecorded: self.weightArray[i], date: self.daysArray[i] as NSDate)
        }
        
        var when = DispatchTime.now() + 2
        
        if (self.weightArray.count > 365) {
            when = DispatchTime.now() + 4
        }
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.clickable()
        }
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
        useSaveButton()
    }

    
}
