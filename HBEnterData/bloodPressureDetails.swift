//
//  bloodPressureDetails.swift
//  HBEnterData
//
//  Created by Allyson on 2017-02-13.
//  Copyright © 2017 Allyson. All rights reserved.
//

import Foundation
import UIKit
import HealthKit
import PromiseKit


class bloodPressureDetails: UIViewController {
    
    /*let healthKitStore = HKHealthStore()
    let current = Date()
    var stepsArray = [Int]()
    var daysArray = [Date]()
    
    @IBOutlet weak var leastSystolic: UITextField!
    @IBOutlet weak var mostSystolic: UITextField!
    @IBOutlet weak var leastDystolic: UITextField!
    @IBOutlet weak var mostDystolic: UITextField!
    @IBOutlet weak var leastDateRange: UIDatePicker!
    @IBOutlet weak var mostDateRange: UIDatePicker!
    @IBOutlet weak var loaderBack: UIImageView!
    @IBOutlet weak var loader: UIImageView!
    @IBOutlet weak var loadingText: UITextField!
    @IBOutlet weak var submit: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loader.loadGif(name: "leftshark")
//        loader.isHidden = true
//        loaderBack.alpha = 0.5
//        loaderBack.isHidden = true
//        loadingText.isHidden = true
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
    /*
    func unclickable() {
        submit.isEnabled = false
        leastDateRange.isEnabled = false
        mostDateRange.isEnabled = false
        loader.isHidden = false
        loaderBack.isHidden = false
        leastSteps.isEnabled = false
        mostSteps.isEnabled = false
        loadingText.isHidden = false
        navigationItem.hidesBackButton = true
    }
    
    func clickable() {
        submit.isEnabled = true
        leastDateRange.isEnabled = true
        mostDateRange.isEnabled = true
        loader.isHidden = true
        loaderBack.isHidden = true
        leastSteps.isEnabled = true
        mostSteps.isEnabled = true
        loadingText.isHidden = true
        navigationItem.hidesBackButton = false
    }
    func useSaveButton(){
        let leastStepCount = Int(leastSteps.text!)
        let mostStepCount = Int(mostSteps.text!)
        let startDate = leastDateRange.date
        let endDate = mostDateRange.date
        createData(leastStep: leastStepCount!, mostStep: mostStepCount!, start: startDate, end: endDate)
        unclickable()
        for i in 0 ..< self.stepsArray.count  {
            HealthManager.sharedInstance.saveSteps(stepsRecorded: self.stepsArray[i], date: self.daysArray[i] as NSDate)
        }
        
        var when = DispatchTime.now() + 3
        
        if (self.stepsArray.count > 365) {
            when = DispatchTime.now() + 5
        }
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.clickable()
        }
        
    }
    
    @IBAction func saveButton(_ sender: Any ) {
        useSaveButton()
    }
    */
 */
}

