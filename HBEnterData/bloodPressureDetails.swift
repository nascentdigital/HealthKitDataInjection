//
//  bloodPressureDetails.swift
//  HBEnterData
//
//  Created by Allyson on 2017-02-13.
//  Copyright © 2017 Allyson. All rights reserved.
//

import UIKit
import HealthKit
import PromiseKit


class bloodPressureDetails: UIViewController {
    
    let healthKitStore = HKHealthStore()
    let current = Date()
    var systolicArray = [Int]()
    var dystolicArray = [Int]()
    var daysArray = [Date]()
    
    @IBOutlet weak var leastSystolic: UITextField!
    @IBOutlet weak var mostSystolic: UITextField!
    @IBOutlet weak var leastDystolic: UITextField!
    @IBOutlet weak var mostDystolic: UITextField!
    @IBOutlet weak var leastDateRange: UIDatePicker!
    @IBOutlet weak var mostDateRange: UIDatePicker!
    @IBOutlet weak var loadingText: UITextField!
    @IBOutlet weak var loader: UIImageView!
    @IBOutlet weak var loaderBack: UIImageView!
    @IBOutlet weak var submit: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.loadGif(name: "leftshark")
        loader.isHidden = true
        loaderBack.alpha = 0.8
        loaderBack.isHidden = true
        loadingText.isHidden = true
        
        mostDateRange.maximumDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())

    }
    
    //calculating days between
    func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    //creating the data set to be sent to healthbook
    func createData(leastSystolic: Int, mostSystolic: Int, leastDystolic: Int, mostDystolic: Int, start: Date, end: Date) {
        let daysdifference = daysBetween(start: start as Date, end: end as Date)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyy"
        
        for _ in 0 ..< (daysdifference+2) {
            systolicArray.append(Int(arc4random_uniform(UInt32(mostSystolic)) + UInt32(leastSystolic)))
            dystolicArray.append(Int(arc4random_uniform(UInt32(mostDystolic)) + UInt32(leastDystolic)))
        }
        
        let calendar = Calendar.current
        for i in 0 ..< (daysdifference+2){
            daysArray.append(calendar.date(byAdding: .day, value: i, to: start)!)
        }
    }
    
    //ACTIVITY INDICATOR STUFF
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    func start() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    func stop() {
        activityIndicator.stopAnimating()
    }
    
    func unclickable() {
        submit.isEnabled = false
        leastDateRange.isEnabled = false
        mostDateRange.isEnabled = false
        loader.isHidden = false
        loaderBack.isHidden = false
        leastSystolic.isEnabled = false
        mostSystolic.isEnabled = false
        leastDystolic.isEnabled = false
        mostDystolic.isEnabled = false
        loadingText.isHidden = false
        navigationItem.hidesBackButton = true
    }
    
    func clickable() {
        submit.isEnabled = true
        leastDateRange.isEnabled = true
        mostDateRange.isEnabled = true
        loader.isHidden = true
        loaderBack.isHidden = true
        leastSystolic.isEnabled = true
        mostSystolic.isEnabled = true
        leastDystolic.isEnabled = true
        mostDystolic.isEnabled = true
        loadingText.isHidden = true
        navigationItem.hidesBackButton = false
        leastSystolic.text = ""
        mostSystolic.text=""
        leastDystolic.text=""
        mostDystolic.text=""
        leastDateRange.date = current
        mostDateRange.date = current
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
        createData(leastSystolic: leastSystolicCount!, mostSystolic: mostSystolicCount!, leastDystolic: leastDystolicCount!, mostDystolic: mostDystolicCount!, start: startDate, end: endDate)
        unclickable()
        for i in 0 ..< self.systolicArray.count  {
            HealthManager.sharedInstance.saveStepsBlood(systolicRecorded: self.systolicArray[i], dystolicRecorded: self.dystolicArray[i], date: self.daysArray[i] as NSDate)
        }
        
        var when = DispatchTime.now() + 3
        
        if (self.systolicArray.count > 365) {
            when = DispatchTime.now() + 5
        }
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.clickable()
        }
        
    }
 
    @IBAction func saveButton(_ sender: Any) {
        useSaveButton()
    }

 
 
}

