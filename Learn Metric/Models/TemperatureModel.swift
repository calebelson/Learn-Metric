//
//  TemperatureModel.swift
//  Learn Metric
//
//  Created by Caleb Elson on 6/17/18.
//  Copyright © 2018 Caleb Elson. All rights reserved.
//

import Foundation

class TemperatureModel {
    
    func temperatureConverter(currentApparentTemperature: Double?) -> (fahrenheit: String, celsius: String) {
        
        let formatter = NumberFormatter()
        let unitFormatter = MeasurementFormatter()
        unitFormatter.numberFormatter = formatter
        unitFormatter.unitOptions = .providedUnit

        // Fahrenheit is rounded to integer
        formatter.maximumFractionDigits = 0
        let currentTempF = Measurement(value: (currentApparentTemperature)!, unit: UnitTemperature.fahrenheit)
        let formattedCurrentTempF = unitFormatter.string(from: currentTempF)
        
        // Celsius is rounded to 1 decimal place
        formatter.maximumFractionDigits = 1
        let formattedCurrentTempC = unitFormatter.string(from: currentTempF.converted(to: UnitTemperature.celsius))
        
        let temperature = (formattedCurrentTempF, formattedCurrentTempC)
    
    return temperature
    }
}
