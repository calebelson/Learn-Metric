//
//  IconAndLoadingViewController.swift
//  Learn Metric
//
//  Created by Caleb Elson on 6/15/18.
//  Copyright © 2018 Caleb Elson. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AllAnimationsViewController: UIViewController {
    
    @IBOutlet weak var allAnimationsView: UIView!
    lazy var skyconView = SKYIconView(frame: CGRect(x: 0, y: 0, width: allAnimationsView.frame.width, height: allAnimationsView.frame.height))
    lazy var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: allAnimationsView.frame.width, height: allAnimationsView.frame.height), color: #colorLiteral(red: 0.6980392157, green: 0.8431372549, blue: 1, alpha: 1))
    
    // "circleStrokeSpin" is the last value listed under NVActivityIndicatorType, 1 added after random number generation to avoid .blank
    let totalActivityViews = (NVActivityIndicatorType.circleStrokeSpin.rawValue)

    override func viewDidLayoutSubviews() {
        // backgroundColor not being set causes visual bugs
        skyconView.backgroundColor = .black
        skyconView.setColor = #colorLiteral(red: 0.6980392157, green: 0.8431372549, blue: 1, alpha: 1)
        skyconView.setType = .cloudy
        allAnimationsView.addSubview(skyconView)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    @IBAction func changeAnimation(_ sender: UITapGestureRecognizer) {
        
        // Clears allAnimationsView
        skyconView.removeFromSuperview()
        activityIndicatorView.removeFromSuperview()
        
        // 1 added here to avoid .blank
        let randomNumber = Int(arc4random_uniform(UInt32(totalActivityViews))) + 1
        
        guard let activityIndicatorType = NVActivityIndicatorType(rawValue: randomNumber) else {
            
            activityIndicatorView.type = .pacman
            activityIndicatorView.color = #colorLiteral(red: 0.944022473, green: 0.4014404026, blue: 0.4582167554, alpha: 1)
            allAnimationsView.addSubview(activityIndicatorView)
            activityIndicatorView.startAnimating()
            
            print("Unexpected failure setting random NVActivityIndicatorType, number: \(randomNumber)")
            
            return
        }
        
        // Randomly selected NVActivityIndicatorType
        activityIndicatorView.type = activityIndicatorType
        
        allAnimationsView.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
     
    }
}

