//
//  DetailViewController.swift
//  Runner
//
//  Created by Zhicong Zang on 7/7/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    var run: Run!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
    }
}

// MARK: - MKMapViewDelegate
extension DetailViewController: MKMapViewDelegate {
    
}
