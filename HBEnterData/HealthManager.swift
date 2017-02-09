//
//  HealthManager.swift
//  HBEnterData
//
//  Created by Allyson on 2017-02-06.
//  Copyright © 2017 Allyson. All rights reserved.
//

import Foundation
import HealthKit
import UIKit

class HealthManager: UIViewController {
    
    open static let sharedInstance = HealthManager()

    //creating an instance of HKHealthStore to access
    let healthKitStore = HKHealthStore()
    
    //checking for availability
    func isHealthKitAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    //requesting authorization
    open func requestHKAuthorization( _ completion: @escaping (Bool, NSError?) -> Void) {
       
    //setting types to write to store
    let shareTypes = Set(arrayLiteral: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!)
    let readTypes: Set<HKObjectType> = Set([HKObjectType.workoutType()])
    
    healthKitStore.requestAuthorization(toShare: shareTypes, read: readTypes) { (success, error) -> Void in
    if success {
    print("success")
        
    } else {
    print("failure")
    }
    
    if let error = error { print(error) }
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
    ///////////////////////////////////////////////

    func saveSteps(stepsRecorded: Int, date: NSDate) {
        //get date
        //set sample type
        let sampleType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        //set units
        let units = HKUnit.count()
        //hardcode quantity for now:
        let stepsQuantity = HKQuantity(unit: units, doubleValue: Double(stepsRecorded))
        
        let stepsQuantitySample = HKQuantitySample(type: sampleType!, quantity: stepsQuantity, start: date as Date, end: date as Date)
        
        healthKitStore.save(stepsQuantitySample, withCompletion: { (Bool, NSError)-> Void in
            if (NSError != nil) {
                print(NSError!)
            }
            else {
                print("recorded:  \(date) with \(stepsRecorded)")
        
            }
        })
        
    }

}
