//
//  TemperatureConverterViewController.swift
//  Learn Metric
//
//  Created by Caleb on 8/13/18.
//  Copyright © 2018 Caleb Elson. All rights reserved.
//

import UIKit

class TemperatureConververterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Parameters and Outlets
    @IBOutlet weak var temperaturePicker: UIPickerView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var leftControl: UISegmentedControl!
    @IBOutlet weak var rightControl: UISegmentedControl!
    
    let temperatureRows = [(-460...800).map{ $0 }, (-273...427).map{ $0 },  (0...700).map{ $0 }]
    let temperatureScales = [UnitTemperature.fahrenheit, UnitTemperature.celsius, UnitTemperature.kelvin]
    lazy var selectedPickerRows = temperatureRows[0]
    lazy var currentlySelectedTemperature = defaultTemperatureValue
    let defaultTemperatureValue = Measurement(value: 70, unit: UnitTemperature.fahrenheit)
    let scaleRowModifiers = [460, 273, 0]
    

    // MARK: - View setup
    override func viewDidLoad() {
        temperaturePicker.dataSource = self
        temperaturePicker.delegate = self
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshPressed))
        self.navigationItem.rightBarButtonItem = refresh
        
        refreshPressed()
    }
    
    
    // MARK: - Pickerview setup
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return temperatureRows[leftControl.selectedSegmentIndex].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(selectedPickerRows[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentlySelectedTemperature = Measurement(value: Double(temperatureRows[leftControl.selectedSegmentIndex][row]), unit: temperatureScales[leftControl.selectedSegmentIndex])
        
        setLabelValue()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = String(selectedPickerRows[row])
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6980392157, green: 0.8431372549, blue: 1, alpha: 1)])
        
        return myTitle
    }
    
    // MARK: - Segmented controls
    
    @IBAction func leftControlPressed(_ sender: UISegmentedControl) {
        
        // To prevent drift from repeated scale changes
        let temp = currentlySelectedTemperature
        
        selectedPickerRows = temperatureRows[leftControl.selectedSegmentIndex]
        temperaturePicker.reloadComponent(0)
        
        temperaturePicker.selectRow(Int(currentlySelectedTemperature.converted(to: temperatureScales[leftControl.selectedSegmentIndex]).value) + scaleRowModifiers[leftControl.selectedSegmentIndex], inComponent: 0, animated: true)
        
        currentlySelectedTemperature = Measurement(value: Double(temperatureRows[leftControl.selectedSegmentIndex][temperaturePicker.selectedRow(inComponent: 0)]), unit: temperatureScales[leftControl.selectedSegmentIndex])
        
        currentlySelectedTemperature = temp
        
        setLabelValue()
    }
    
    @IBAction func rightControlPressed(_ sender: UISegmentedControl) {
        setLabelValue()
    }
    
    
    // MARK: - Refresh button
    
    @objc func refreshPressed() {

        temperaturePicker.selectRow(530, inComponent: 0, animated: false)
        
        rightControl.selectedSegmentIndex = 1
        setLabelValue()
    }
    
    func setLabelValue() {
        let numberFormatter = NumberFormatter()
        let temperatureFormatter = MeasurementFormatter()
        temperatureFormatter.unitOptions = .providedUnit
        
        // Fahrenheit is rounded to integer, celsius and kelvin to one decimal place
        if rightControl.selectedSegmentIndex == 0 {
            numberFormatter.maximumFractionDigits = 0
        } else {
            numberFormatter.maximumFractionDigits = 1
        }
        
        temperatureFormatter.numberFormatter = numberFormatter
        
        temperatureLabel.text = temperatureFormatter.string(from: currentlySelectedTemperature.converted(to: temperatureScales[rightControl.selectedSegmentIndex]))
    }
}
