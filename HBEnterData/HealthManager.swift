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

    //creating an instance of HKHealthStore to access later
    let healthKitStore = HKHealthStore()
    
    //checking for availability of the health kit
    func isHealthKitAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    //requesting authorization from user
    open func requestHKAuthorization( _ completion: @escaping (Bool, NSError?) -> Void) {
       
    //setting types to write to store
    var shareTypes = Set(arrayLiteral: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!)
    shareTypes.insert(HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureSystolic)!)
    shareTypes.insert(HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureDiastolic)!)
    shareTypes.insert(HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!)
    let readTypes = Set(arrayLiteral: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!)
    
   
    //requesting authorization from the user
    healthKitStore.requestAuthorization(toShare: shareTypes, read: readTypes) { (success, error) -> Void in
    if success {
    print("success")
        
    } else {
    print("failure")
    }
    
    if let error = error { print(error) }
    }
    }


    //saving STEPCOUNT to healthkit
    func saveSteps(stepsRecorded: Int, date: NSDate) {
        //get date
        //set sample type
        let sampleType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        //set units
        let units = HKUnit.count()
        //hardcode quantity for now:
        let stepsQuantity = HKQuantity(unit: units, doubleValue: Double(stepsRecorded))
        
        //setting up the sample to be written to da store
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

    //saving BLOOD PRESSURE to healthkit
    func saveStepsBlood(systolicRecorded: Int, dystolicRecorded: Int, date: NSDate) {
        //get date
        //set sample type
        let sampleTypeSystolic = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureSystolic)
        let sampleTypeDystolic = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureDiastolic)
        
        //set units
        let BPUnits = HKUnit.millimeterOfMercury()
        //hardcode quantity for now:
        let systolicQuantity = HKQuantity(unit: BPUnits, doubleValue: Double(systolicRecorded))
        let dystolicQuantity = HKQuantity(unit: BPUnits, doubleValue: Double(dystolicRecorded))
        
        let systolicQuantitySample = HKQuantitySample(type: sampleTypeSystolic!, quantity: systolicQuantity, start: date as Date, end: date as Date)
        let dystolicQuantitySample = HKQuantitySample(type: sampleTypeDystolic!, quantity: dystolicQuantity, start: date as Date, end: date as Date)

        let objectSet: NSSet = NSSet(objects: systolicQuantitySample, dystolicQuantitySample)
        let BPObject: HKCorrelationType = HKObjectType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.bloodPressure)!
        let bloodPressureCorrelation: HKCorrelation = HKCorrelation(type: BPObject, start: date as Date, end: date as Date, objects: objectSet as! Set<HKSample>)
        healthKitStore.save(bloodPressureCorrelation, withCompletion: { (Bool, NSError)-> Void in
            if (NSError != nil) {
                print(NSError!)
            }
            else {
                print("recorded:  \(date) with \(systolicQuantity) and \(dystolicQuantity)")
         
            }
            
            
        })
        
    }
    
    //saving WEIGHT to healthkit
    func saveWeight(weightRecorded: Int, date: NSDate) {
        //get weight
        //set sample type
        let sampleType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
        
        //set units
        let units = HKUnit.pound()
        //hardcode quantity for now:
        let weightQuantity = HKQuantity(unit: units, doubleValue: Double(weightRecorded))
        
        let stepsQuantitySample = HKQuantitySample(type: sampleType!, quantity: weightQuantity, start: date as Date, end: date as Date)
        healthKitStore.save(stepsQuantitySample, withCompletion: { (Bool, NSError)-> Void in
            if (NSError != nil) {
                print(NSError!)
            }
            else {
                print("recorded:  \(date) with \(weightRecorded)")
                
            }
            
        })
        
    }
    
    func getData(completion: @escaping (_ dataRetrieved: Double) -> Void) {
        
        let dataType  = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)! //change to data type
        let dataUnit  = HKUnit.count() //change to any data unit
        var components = DateComponents()
        components.day = 1
        let startDate = NSCalendar.current.startOfDay(for: NSDate() as Date)
        let endDate = NSCalendar.current.date(byAdding: components, to: startDate)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])

        let sumOption = HKStatisticsOptions.cumulativeSum
        let query = HKStatisticsQuery(quantityType: dataType, quantitySamplePredicate: predicate,
                                                   options: sumOption)
        { (query, result, error) in
            if let sumQuantity = result?.sumQuantity() {
                
                let value = Int(sumQuantity.doubleValue(for: dataUnit)) //not always double?
                print(value)
            }
        }
        
        healthKitStore.execute(query)
    }

}
