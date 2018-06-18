//
//  IconAndLoadingModel.swift
//  Learn Metric
//
//  Created by Caleb Elson on 6/15/18.
//  Copyright © 2018 Caleb Elson. All rights reserved.
//

import Foundation

class IconAndLoadingModel {
    private let weatherTypes: [String: Skycons] =
        [
            "clear-day" : .clearDay,
            "clear-night" : .clearNight,
            "cloud" : .cloudy,
            "fog" : .fog,
            "partly-cloudy-day" : .partlyCloudyDay,
            "partly-cloudy-night" : .partlyCloudyNight,
            "rain" : .rain,
            "sleet" : .sleet,
            "snow" : .snow,
            "wind" : .wind
    ]
    
    func weatherIcon(icon: String) -> Skycons {
        if let weatherType = weatherTypes[icon] {
            return weatherType
        } else {
            return .partlyCloudyDay
        }
    }
    
}

