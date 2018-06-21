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
import CoreLocation

class HomeViewController: UIViewController {
    
    let darkSkyClient = DarkSkyClient(apiKey: "xxxx")

    
    @IBOutlet weak var weatherAnimationView: UIView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var refreshButtonOutlet: UIBarButtonItem!
    lazy var skyIconView = SKYIconView(frame: CGRect(x: 0, y: 0, width: weatherAnimationView.frame.width, height: weatherAnimationView.frame.height))
    lazy var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: weatherAnimationView.frame.width, height: weatherAnimationView.frame.height))
    
    let iconAndLoadingModel = IconAndLoadingModel()
    let temperatureModel = TemperatureModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        skyIconView.backgroundColor = .black
        activityIndicatorView.backgroundColor = .black
        weatherAnimationView.backgroundColor = .black
        
        // Default loading view
        setIconAndSummary()

        if let coordinates = getLocation() {
            getWeather(coordinates: coordinates)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Completely hide navigation bar background
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        // Change text color in navigation bar
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.6980392157, green: 0.8431372549, blue: 1, alpha: 1)
    }
    
    // MARK: Refresh button
    @IBAction func refreshButton(_ sender: Any) {
        // Set view to loading view
        setIconAndSummary()
        
        if let coordinates = getLocation() {
            getWeather(coordinates: coordinates)
        }
    }
    
    // MARK: Location
    func getLocation() -> CLLocationCoordinate2D? {
        Locator.currentPosition(accuracy: .neighborhood, timeout: Timeout.delayed(8), onSuccess: { location in
            print("Location successfully attained")
            
            return self.getWeather(coordinates: location.coordinate)
            
        }, onFail: { err, last in
            print("Failed to get location: \(err)")
            
            self.setIconAndSummary(weatherRetrievalSuccess: false)
        })
        
        return nil
    }
    
    // MARK: Weather
    func getWeather(coordinates: CLLocationCoordinate2D) {
        darkSkyClient.getForecast(latitude: coordinates.latitude, longitude: coordinates.longitude, completion: { result in
            switch result {
            case .success(let currentForecast, let requestMetadata):
                print("getForecast successful: \(requestMetadata)")
                
                self.setIconAndSummary(weatherRetrievalSuccess: true, weatherSummary: currentForecast.currently?.summary, apparentTemperature: currentForecast.currently?.apparentTemperature, icon: currentForecast.currently?.icon?.rawValue)
                
            case .failure(let error):
                print("getForecast error: \(error)")
                
                self.setIconAndSummary(weatherRetrievalSuccess: false)
            }
        })
    }
    
    
  
    // MARK: Icon and summary setup
    func setIconAndSummary(weatherRetrievalSuccess: Bool? = nil, weatherSummary: String? = nil, apparentTemperature: Double? = nil, icon: String? = nil) {
        
        // Clears allAnimationsView
        DispatchQueue.main.async {
            self.skyIconView.removeFromSuperview()
            self.activityIndicatorView.removeFromSuperview()
        }

        switch weatherRetrievalSuccess {
        case true:
            // This is set to a tuple for the converted and formatted apparent temperature values
            let currentTemperatureValues = temperatureModel.temperatureConverter(currentApparentTemperature: apparentTemperature)
            
            DispatchQueue.main.async {
                self.skyIconView.setType = self.iconAndLoadingModel.weatherIcon(icon: icon!)
                self.skyIconView.setColor = #colorLiteral(red: 0.6980392157, green: 0.8431372549, blue: 1, alpha: 1)
                self.weatherAnimationView.addSubview(self.skyIconView)
                self.skyIconView.play()
                
                self.summaryLabel.textColor = #colorLiteral(red: 0.6980392157, green: 0.8431372549, blue: 1, alpha: 1)
                self.summaryLabel.text = "It is currently " + weatherSummary! +
                "\n\(currentTemperatureValues.fahrenheit), \(currentTemperatureValues.celsius)"
            }
            
            // Failure getting location or weather info
        case false:
            DispatchQueue.main.async {
                self.skyIconView.setType = .partlyCloudyDay
                self.skyIconView.setColor = #colorLiteral(red: 0.944022473, green: 0.4014404026, blue: 0.4582167554, alpha: 1)
                
                self.weatherAnimationView.addSubview(self.skyIconView)
                self.skyIconView.play()
                
                self.summaryLabel.textColor = #colorLiteral(red: 0.944022473, green: 0.4014404026, blue: 0.4582167554, alpha: 1)
                self.summaryLabel.text = "Error getting temperature, check\nnetwork and location settings"
            }
            
            // Loading View
        default:
            DispatchQueue.main.async {
                self.activityIndicatorView.type = .pacman
                self.activityIndicatorView.color = #colorLiteral(red: 0.6980392157, green: 0.8431372549, blue: 1, alpha: 1)
                
                self.weatherAnimationView.addSubview(self.activityIndicatorView)
                self.activityIndicatorView.startAnimating()
                
                self.summaryLabel.textColor = #colorLiteral(red: 0.6980392157, green: 0.8431372549, blue: 1, alpha: 1)
                self.summaryLabel.text = "Loading..."
            }
        }
    }
    
    // TODO: Info button
    
}

