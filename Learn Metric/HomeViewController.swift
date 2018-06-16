//
//  ViewController.swift
//  Learn Metric
//
//  Created by Caleb Elson on 6/7/18.
//  Copyright © 2018 Caleb Elson. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import ForecastIO
import SwiftLocation

class HomeViewController: UIViewController {
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    @IBOutlet weak var iconView: SKYIconView!
    @IBOutlet weak var summaryLabel: UILabel!
    
    let client = DarkSkyClient(apiKey: "xxxxxxxxxxx")
    let iconAndLoadingModel = IconAndLoadingModel()
    
    override func viewDidLoad() {
        refresh()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: Refresh button
    
    func refresh() {
        iconView.isHidden = true
        loadingView.isHidden = false
        loadingView.type = .pacman
        loadingView.startAnimating()
        summaryLabel.text = "Loading..."
        
        Locator.currentPosition(accuracy: .city, timeout: Timeout.delayed(10), onSuccess: { location in
            self.client.getForecast(latitude: 37.8267, longitude: -122.4233) { result in
                switch result {
                case .success(let currentForecast, let requestMetadata):
                    print("getForecast successful: \(requestMetadata)")
                    
                    let n = NumberFormatter()
                    
                    n.maximumFractionDigits = 0
                    let currentTempF = Measurement(value: (currentForecast.currently?.apparentTemperature)!, unit: UnitTemperature.fahrenheit)
                    let roundedF = n.string(for: currentTempF.value)!
                    
                    n.maximumFractionDigits = 1
                    let currentTempC = currentTempF.converted(to: UnitTemperature.celsius)
                    let roundedC = n.string(for: currentTempC.value)!
                    
                    DispatchQueue.main.async {
                        self.loadingView.isHidden = true
                        self.iconView.isHidden = false
                        
                        self.iconView.setType = self.iconAndLoadingModel.weatherIcon(icon: (currentForecast.currently?.icon?.rawValue)!)
                        
                        self.iconView.play()
                        self.iconView.setColor = #colorLiteral(red: 0.6980392157, green: 0.8431372549, blue: 1, alpha: 1)
                        
                        self.summaryLabel.text = "It is currently " + (currentForecast.currently?.summary)! +
                        "\n\(roundedF) °F and \(roundedC) °C"
                    }
                    
                case .failure(let error):
                    print("getForecast error: \(error)")
                }
            }
        }, onFail: { err, last in
            print("Failed to get location: \(err)")
        })
    }
     
}

