//
//  DistanceConverterController.swift
//  Learn Metric
//
//  Created by Caleb Elson on 10/1/18.
//  Copyright © 2018 Caleb Elson. All rights reserved.
//

import UIKit

class DistanceConverterViewController: UIViewController {
    @IBOutlet weak var inputToConvert: UITextField!
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        inputToConvert.select(self)
    }
    
}
