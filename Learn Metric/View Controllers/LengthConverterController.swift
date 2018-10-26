//
//  LengthConverterController.swift
//  Learn Metric
//
//  Created by Caleb Elson on 10/1/18.
//  Copyright © 2018 Caleb Elson. All rights reserved.
//

import UIKit

class LengthConverterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var valueToConvert: UITextField!
    @IBOutlet weak var convertedValue: UILabel!
    @IBOutlet weak var scalePickerView: UIPickerView!
    
    let lengthModel = LengthModel()
    
    override func viewDidLoad() {
        scalePickerView.dataSource = self
        scalePickerView.delegate = self
        
        scalePickerView.backgroundColor = .black
        valueToConvert.backgroundColor = .black
        convertedValue.backgroundColor = .black

        valueToConvert.attributedPlaceholder = NSAttributedString(string: "Value to convert", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.6979569793, green: 0.8412405849, blue: 0.9987565875, alpha: 0.5)])
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshPressed))
        self.navigationItem.rightBarButtonItem = refresh
        
        refreshPressed()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        valueToConvert.select(self)
    }
    
    
    // MARK: - Pickerview setup
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lengthModel.spinngerScales.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lengthModel.spinngerScales[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = lengthModel.spinngerScales[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.6980392157, green: 0.8431372549, blue: 1, alpha: 1)])
        
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        inputChanged(self)
    }
    
    
    // MARK: - inputChanged
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
            // Convert Value of input from scale in left component of PickerView to scale of right component
            convertedValue.text = lengthModel.lengthConversion(value: Double(valueToConvert.text!)!, fromScale: scalePickerView.selectedRow(inComponent: 0), toScale: scalePickerView.selectedRow(inComponent: 1))
        }
    }
    
    
    // MARK: - Refresh button
    @objc func refreshPressed() {
        valueToConvert.text = ""
        inputChanged(self)
        scalePickerView.selectRow(1, inComponent: 0, animated: true)
        scalePickerView.selectRow(5, inComponent: 1, animated: true)
    }
}
