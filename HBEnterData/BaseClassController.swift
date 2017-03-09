//
//  BaseClassController.swift
//  HBEnterData
//
//  Created by Allyson on 2017-02-27.
//  Copyright © 2017 Allyson. All rights reserved.
//

import UIKit
import HealthKit

class BaseClassController: UIViewController {
    
    @IBOutlet weak var loaderBack: UIImageView!
    @IBOutlet weak var loader: UIImageView!
    @IBOutlet weak var loadingText: UITextField!
    @IBOutlet weak var mostDateRange: UIDatePicker!
    @IBOutlet weak var submit: UIBarButtonItem!
    @IBOutlet weak var leastDateRange: UIDatePicker!
    
    var scrollView: UIScrollView!

    
    let healthKitStore = HKHealthStore()
    let current = Date()
    var daysArray = [Date]()

    
    //calculating days between
    func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BaseClassController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        loader.loadGif(name: "leftshark")
        loader.isHidden = true
        loaderBack.alpha = 0.8
        loaderBack.isHidden = true
        loadingText.isHidden = true
        mostDateRange.maximumDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())
        
//        //SCROLLVIEW 
//        scrollView = UIScrollView(frame: view.bounds)
//        scrollView.backgroundColor = UIColor.black
//        scrollView.contentSize = view.bounds.size
//        //scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
//        
//        scrollView.addSubview(view)
//        view.addSubview(scrollView)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func unclickable() {
        submit.isEnabled = false
        mostDateRange.isEnabled = false
        leastDateRange.isEnabled = false
        loader.isHidden = false
        loaderBack.isHidden = false
        loadingText.isHidden = false
        navigationItem.hidesBackButton = true
    }
    
    func clickable() {
        submit.isEnabled = true
        mostDateRange.isEnabled = true
        leastDateRange.isEnabled = true
        loader.isHidden = true
        loaderBack.isHidden = true
        loadingText.isHidden = true
        navigationItem.hidesBackButton = false
        mostDateRange.date = current
        leastDateRange.date = current

    }
}
