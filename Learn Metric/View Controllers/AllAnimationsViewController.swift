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
    lazy var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: allAnimationsView.frame.width, height: allAnimationsView.frame.height))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // backgroundColor not being set causes visual bugs
        skyconView.backgroundColor = .black
        skyconView.setColor = #colorLiteral(red: 0.6980392157, green: 0.8431372549, blue: 1, alpha: 1)
        skyconView.setType = .cloudy
        allAnimationsView.addSubview(skyconView)
        
        activityIndicatorView.color = #colorLiteral(red: 0.6980392157, green: 0.8431372549, blue: 1, alpha: 1)
        activityIndicatorView.type = .ballClipRotatePulse
    }
    
    @IBAction func changeAnimation(_ sender: UITapGestureRecognizer) {
        
        skyconView.removeFromSuperview()
        activityIndicatorView.removeFromSuperview()
        
        allAnimationsView.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
    //        // "circleStrokeSpin" is the last value listed under NVActivityIndicatorType
    //
    //        let totalLoadingViews = (NVActivityIndicatorType.circleStrokeSpin.rawValue)
    //
    //        // Blank is 0
    //        let randomNumber = Int(arc4random_uniform(UInt32(totalLoadingViews))) + 1
    //
    //
    //        // If NVActivityIndicatorType can not be set, sets a default value colored red
    //
    //        guard let activityIndicator = NVActivityIndicatorType(rawValue: randomNumber) else {
    //
    //            loadingView.type = .pacman
    //            loadingView.color = .purple
    //            loadingView.startAnimating()
    //
    //            return
    //        }
    //
    //        loadingView.type = activityIndicator
    //        loadingView.startAnimating()
}

