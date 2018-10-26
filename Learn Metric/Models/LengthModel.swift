//
//  LengthModel.swift
//  Learn Metric
//
//  Created by Caleb Elson on 10/25/18.
//  Copyright © 2018 Caleb Elson. All rights reserved.
//

import Foundation

class LengthModel {
    let spinngerScales = ["Millimeters", "Centimeters", "Meters", "Kilometers", "Megameters", "Inches", "Feet", "Yards", "Miles", "Light Years", "Parsecs"]
    let lengthScales: [UnitLength] = [.millimeters, .centimeters, .meters, .kilometers, .megameters, .inches, .feet, .yards, .miles, .lightyears, .parsecs]
    
    func lengthConversion(value: Double, fromScale: Int, toScale: Int) -> String {
        let convertedMeasurement = Measurement(value: value, unit: lengthScales[fromScale]).converted(to: lengthScales[toScale])
        
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitOptions = .providedUnit
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .scientific
        numberFormatter.exponentSymbol = "E+"
        numberFormatter.maximumSignificantDigits = 9
        
        //Only uses scientific notation for numbers greater than 1 trillion
        if convertedMeasurement.value > 1_000_000_000_000 {
            measurementFormatter.numberFormatter = numberFormatter
        }
        
        return measurementFormatter.string(from: convertedMeasurement)
    }
}
