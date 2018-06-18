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
    @IBOutlet weak var refreshButtonOutlet: UIButton!
    
    let darkSkyClient = DarkSkyClient(apiKey: "xxxx")
    let iconAndLoadingModel = IconAndLoadingModel()
    let temperatureModel = TemperatureModel()
    
    
    override func viewDidLoad() {
        refreshButtonOutlet.sendActions(for: .touchUpInside)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK: Refresh button
    @IBAction func refreshButton(_ sender: UIButton) {
        
        // Sets default view
        iconView.isHidden = true
        iconView.pause()
        
        loadingView.isHidden = false
        loadingView.type = .pacman
        loadingView.color = #colorLiteral(red: 0.6980392157, green: 0.8431372549, blue: 1, alpha: 1)
        loadingView.startAnimating()
        
        summaryLabel.text = "Loading..."
        summaryLabel.textColor = #colorLiteral(red: 0.6980392157, green: 0.8431372549, blue: 1, alpha: 1)
        
        Locator.currentPosition(accuracy: .city, timeout: Timeout.delayed(8.0), onSuccess: { location in
            
            self.darkSkyClient.getForecast(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { result in
                
                switch result {
                case .success(let currentForecast, let requestMetadata):
                    print("getForecast successful: \(requestMetadata)")
                    
                    // This is set to a tuple for the converted and formatted apparent temperature values
                    let currentTemperature = self.temperatureModel.temperatureConverter(currentlyApparentTemperature: currentForecast.currently?.apparentTemperature)
                    
                    // Swaps the loadingView with iconView for weather, inserts converted values to the summary label
                    DispatchQueue.main.async {
                        self.loadingView.isHidden = true
                        self.loadingView.stopAnimating()
                        
                        self.iconView.isHidden = false
                        self.iconView.setType = self.iconAndLoadingModel.weatherIcon(icon: (currentForecast.currently?.icon?.rawValue)!)
                        self.iconView.play()
                        self.iconView.setColor = #colorLiteral(red: 0.6980392157, green: 0.8431372549, blue: 1, alpha: 1)
                        
                        self.summaryLabel.text = "It is currently " + (currentForecast.currently?.summary)! +
                        "\n\(currentTemperature.fahrenheit), \(currentTemperature.celsius)"
                    }
                    
                case .failure(let error):
                    print("getForecast error: \(error)")
                    
                    DispatchQueue.main.async {
                        self.loadingView.isHidden = true
                        self.loadingView.stopAnimating()
                        
                        self.iconView.isHidden = false
                        self.iconView.setType = .partlyCloudyDay
                        self.iconView.play()
                        self.iconView.setColor = #colorLiteral(red: 0.944022473, green: 0.4014404026, blue: 0.4582167554, alpha: 1)
                        
                        self.summaryLabel.textColor = #colorLiteral(red: 0.944022473, green: 0.4014404026, blue: 0.4582167554, alpha: 1)
                        self.summaryLabel.text = "Error getting temperature, check\nnetwork and location settings"
                        
                    }
                }
            }
            
        }, onFail: { err, last in
            print("Failed to get location: \(err)")
            
            DispatchQueue.main.async {
                self.loadingView.color = .red
                self.loadingView.startAnimating()
                self.summaryLabel.text = "Error getting temperature,\ncheck network and location settings"
            }
        })
    }
    
    // TODO: Info button
    
}

