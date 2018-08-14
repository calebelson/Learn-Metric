//
//  TemperatureModel.swift
//  Learn Metric
//
//  Created by Caleb Elson on 6/17/18.
//  Copyright © 2018 Caleb Elson. All rights reserved.
//

import Foundation

class TemperatureModel {
    
    func temperatureConverter(currentApparentFahrenheit: Double?) -> (fahrenheit: String, celsius: String, kelvin: String) {
        
        let formatter = NumberFormatter()
        let unitFormatter = MeasurementFormatter()
        unitFormatter.numberFormatter = formatter
        unitFormatter.unitOptions = .providedUnit

        // Fahrenheit is rounded to integer
        formatter.maximumFractionDigits = 0
        let currentFahrenheitTemp = Measurement(value: (currentApparentFahrenheit)!, unit: UnitTemperature.fahrenheit)
        let formattedFahrenheitCurrentTemp = unitFormatter.string(from: currentFahrenheitTemp)
        
        // Celsius is rounded to 1 decimal place
        formatter.maximumFractionDigits = 1
        let formattedCelsiusCurrentTemp = unitFormatter.string(from: currentFahrenheitTemp.converted(to: UnitTemperature.celsius))
        
        // Kelvin is rounded to 1 decimal place
        let formattedKelvinCurrentTemp = unitFormatter.string(from: currentFahrenheitTemp.converted(to: .kelvin))
        
        let temperature = (formattedFahrenheitCurrentTemp, formattedCelsiusCurrentTemp, formattedKelvinCurrentTemp)
    
    return temperature
    }
}
