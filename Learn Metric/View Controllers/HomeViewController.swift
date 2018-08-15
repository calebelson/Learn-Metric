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
import Popover

class HomeViewController: UIViewController {
    
    let darkSkyClient = DarkSkyClient(apiKey: "xxxx")
    
    
    // MARK: - Parameters, Outlets, and Subviews
    @IBOutlet weak var weatherAnimationView: UIView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var infoButtonOutlet: UIButton!
    @IBOutlet weak var infoView: UIView!
    
    lazy var skyIconView = SKYIconView(frame: CGRect(x: 0, y: 0, width: weatherAnimationView.frame.width, height: weatherAnimationView.frame.height))
    lazy var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: weatherAnimationView.frame.width, height: weatherAnimationView.frame.height))
    lazy var infoPopoverView = UIView(frame: CGRect(x: 0, y: 0, width: 280, height: 250))
    
    let iconAndLoadingModel = IconAndLoadingModel()
    let temperatureModel = TemperatureModel()
    let popover = Popover()
    
    
    // MARK: - View setup
    override func viewDidLoad() {
        weatherAnimationView.backgroundColor = .black

        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        skyIconView.backgroundColor = .black
        activityIndicatorView.backgroundColor = .black
        
        // Default loading view
        iconAndSummary()
        
        if let coordinates = coordinates() {
            weather(coordinates: coordinates)
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
        iconAndSummary()
        
        if let coordinates = coordinates() {
            weather(coordinates: coordinates)
        }
    }
    
    
    // MARK: - Location, Weather, Icons
    func coordinates() -> CLLocationCoordinate2D? {
        Locator.currentPosition(accuracy: .neighborhood, timeout: Timeout.delayed(8), onSuccess: { location in
            print("Location successfully attained")
            
            return self.weather(coordinates: location.coordinate)
            
        }, onFail: { err, last in
            print("Failed to get location: \(err)")
            
            self.iconAndSummary(weatherRetrievalSuccess: false)
        })
        
        return nil
    }
    
    func weather(coordinates: CLLocationCoordinate2D) {
        darkSkyClient.getForecast(latitude: coordinates.latitude, longitude: coordinates.longitude, completion: { result in
            switch result {
            case .success(let currentForecast, let requestMetadata):
                print("getForecast successful: \(requestMetadata)")
                
                self.iconAndSummary(weatherRetrievalSuccess: true, weatherSummary: currentForecast.currently?.summary, apparentTemperature: currentForecast.currently?.apparentTemperature, icon: currentForecast.currently?.icon?.rawValue)
                
            case .failure(let error):
                print("getForecast error: \(error)")
                
                self.iconAndSummary(weatherRetrievalSuccess: false)
            }
        })
    }
    
    func iconAndSummary(weatherRetrievalSuccess: Bool? = nil, weatherSummary: String? = nil, apparentTemperature: Double? = nil, icon: String? = nil) {
        
        // Clears allAnimationsView
        DispatchQueue.main.async {
            self.skyIconView.removeFromSuperview()
            self.activityIndicatorView.removeFromSuperview()
        }
        
        switch weatherRetrievalSuccess {
        case true:
            // This is set to a tuple for the converted and formatted apparent temperature values
            let currentTemperatureValues = temperatureModel.temperatureConverter(currentApparentFahrenheit: apparentTemperature)
            
            DispatchQueue.main.async {
                self.skyIconView.setType = self.iconAndLoadingModel.weatherIcon(icon: icon!)
                self.skyIconView.setColor = #colorLiteral(red: 0.6980392157, green: 0.8431372549, blue: 1, alpha: 1)
                self.weatherAnimationView.addSubview(self.skyIconView)
                self.skyIconView.play()
                
                self.summaryLabel.textColor = #colorLiteral(red: 0.6980392157, green: 0.8431372549, blue: 1, alpha: 1)
                self.summaryLabel.text = "Currently: " + weatherSummary! +
                "\n\(currentTemperatureValues["fahrenheit"]!), \(currentTemperatureValues["celsius"]!), \(currentTemperatureValues["kelvin"]!)"
            }
            
        // Failure getting location or weather info
        case false:
            DispatchQueue.main.async {
                self.skyIconView.setType = .wind
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
    
    
    // MARK: - Info button
    @IBAction func infoButton(_ sender: Any) {
        let options = [.color(UIColor(white: 0.7, alpha: 0.5)), .blackOverlayColor(UIColor(white: 0.0, alpha: 0.45))] as [PopoverOption]
        let popover = Popover(options: options)
        
        infoView.frame = infoPopoverView.frame
        infoPopoverView.addSubview(infoView)
        infoView.isHidden = false
        
        popover.show(infoPopoverView, fromView: infoButtonOutlet)
    }
    
    @IBAction func poweredByDarkSky(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://darksky.net/poweredby/")!)
    }
}

