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
    
    let fahrenheitValues = (-460...800).map{ $0 }
    let celsiusValues = (-273...427).map{ $0 }
    let kelvinValues = (0...700).map{ $0 }
    let converter = TemperatureModel()
    let defaultRow = 100
    let temperatureScales = ["fahrenheit", "celsius", "kelvin"]
    var leftControlScale = ""
    var rightControlScale = ""
    lazy var currentSelectedTemperatureValues = converter.temperatureConverter(currentApparentFahrenheit: Double(defaultRow))
    
    
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
        return fahrenheitValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(fahrenheitValues[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setLabelValue()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = String(fahrenheitValues[row])
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6980392157, green: 0.8431372549, blue: 1, alpha: 1)])
        
        return myTitle
    }
    
    func setLabelValue() {
        
        currentSelectedTemperatureValues = converter.temperatureConverter(currentApparentFahrenheit: Double(fahrenheitValues[temperaturePicker.selectedRow(inComponent: 0)]))
        
        temperatureLabel.text = currentSelectedTemperatureValues[rightControlScale]
    }
    
    // MARK: - Segmented controls
    
    // TODO: Left segmented control
    @IBAction func leftControlPressed(_ sender: UISegmentedControl) {
        switch leftControl.selectedSegmentIndex {
        case 0:
            leftControlScale = temperatureScales[0]
        case 1:
            leftControlScale = temperatureScales[1]
        case 2:
            leftControlScale = temperatureScales[2]
        default:
            print("Error leftControl")
        }
    }
    
    @IBAction func rightControlPressed(_ sender: UISegmentedControl) {
        rightControlScale = temperatureScales[rightControl.selectedSegmentIndex]
        
        setLabelValue()
    }
    
    
    // MARK: - Refresh button
    
    @objc func refreshPressed() {
        temperaturePicker.selectRow(defaultRow, inComponent: 0, animated: true)
        
        leftControl.selectedSegmentIndex = 0
        leftControlScale = temperatureScales[leftControl.selectedSegmentIndex]
        rightControl.selectedSegmentIndex = 1
        rightControlScale = temperatureScales[rightControl.selectedSegmentIndex]
        
        setLabelValue()
    }
    
}
