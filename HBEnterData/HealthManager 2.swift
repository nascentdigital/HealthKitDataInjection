//
//  HealthManager.swift
//  HBEnterData
//
//  Created by Allyson on 2017-02-06.
//  Copyright © 2017 Allyson. All rights reserved.
//

import Foundation
import HealthKit

class HealthManager {
    
    let healthKitStore: HKHealthStore = HKHealthStore();
    
    func authorizeHealth(completion: ((success: Bool, error: NSError!) -> Void)!) {
        
    }
}
