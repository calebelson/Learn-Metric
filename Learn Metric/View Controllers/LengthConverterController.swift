//
//  LengthConverterController.swift
//  Learn Metric
//
//  Created by Caleb Elson on 10/1/18.
//  Copyright © 2018 Caleb Elson. All rights reserved.
//

import UIKit

class LengthConverterViewController: UIViewController {
    @IBOutlet weak var valueToConvert: UITextField!
    @IBOutlet weak var convertedValue: UILabel!
    
    override func viewDidLoad() {
        valueToConvert.backgroundColor = .black
        valueToConvert.attributedPlaceholder = NSAttributedString(string: "Value to convert", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.6979569793, green: 0.8412405849, blue: 0.9987565875, alpha: 0.5)])
        
        convertedValue.backgroundColor = .black
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshPressed))
        self.navigationItem.rightBarButtonItem = refresh
        
        refreshPressed()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        valueToConvert.select(self)
    }
    
    @IBAction func inputChanged(_ sender: Any) {
        let lengthFormatter = MeasurementFormatter()
        lengthFormatter.unitOptions = .providedUnit
        lengthFormatter.numberFormatter.maximumFractionDigits = 3

        switch valueToConvert.text?.last {
        case .none:
            // No value, resets to default for both input and output
            convertedValue.text = "Converted value"
        case ".":
            // Remove newest decimal if more than one has been input
            if valueToConvert.text!.filter({ $0 == "." }).count > 1 {
                valueToConvert.text!.removeLast()
            } else {
                fallthrough
            }
        default:
            // Convert Value of input
            convertedValue.text = lengthFormatter.string(for: Measurement(value: Double(valueToConvert.text!) ?? 0, unit: UnitLength.feet).converted(to: .meters))
        }
    }
    
    // MARK: - Refresh button
    @objc func refreshPressed() {
        valueToConvert.text = ""
        inputChanged(self)
    }
}
