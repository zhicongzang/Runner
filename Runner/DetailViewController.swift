//
//  DetailViewController.swift
//  Runner
//
//  Created by Zhicong Zang on 7/7/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit
import MapKit
import HealthKit

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
        let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: run.distance!.doubleValue)
        distanceLabel.text = "Distance: " + distanceQuantity.description
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateLabel.text = dateFormatter.stringFromDate(run.timestamp!)
        let secondsQuantity = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: run.duration!.doubleValue)
        timeLabel.text = "Time: " + secondsQuantity.description
        let paceUnit = HKUnit.secondUnit().unitDividedByUnit(HKUnit.meterUnit())
        let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: run.duration!.doubleValue/run.distance!.doubleValue)
        paceLabel.text = "Pace:" + paceQuantity.description
        loadMap()
    }
    
    func mapRegion() -> MKCoordinateRegion {
        let initialLoc = run.locations?.firstObject as! Location
        var minLat = initialLoc.latitude!.doubleValue
        var minLng = initialLoc.longitude!.doubleValue
        var maxLat = minLat
        var maxLng = minLng
        let locations = run.locations?.array as! [Location]
        for location in locations {
            minLat = min(minLat, location.latitude!.doubleValue)
            minLng = min(minLng, location.longitude!.doubleValue)
            maxLat = max(maxLat, location.latitude!.doubleValue)
            maxLng = max(maxLng, location.longitude!.doubleValue)
        }
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (minLat+maxLat)/2, longitude:(minLng+maxLng)/2), span: MKCoordinateSpan(latitudeDelta: (maxLat-minLat)*1.1, longitudeDelta: (maxLng-minLng)*1.1))
    }
    
    func polyline() -> MKPolyline {
        var coords = [CLLocationCoordinate2D]()
        let locations = run.locations?.array as! [Location]
        for location in locations {
            coords.append(CLLocationCoordinate2D(latitude: location.latitude!.doubleValue, longitude: location.longitude!.doubleValue))
        }
        return MKPolyline(coordinates: &coords, count: locations.count)
    }
    
    func loadMap() {
        if run.locations?.count > 0 {
            mapView.hidden = false
            mapView.region = mapRegion()
            let colorSegments = MulticolorPolylineSegment.colorSegments(forLocations: run.locations!.array as! [Location])
            mapView.addOverlays(colorSegments)
        } else {
            mapView.hidden = true
            UIAlertView(title:"Error",
                        message:"Sorry,thisrunhasnolocationssaved",
                        delegate:nil,
                        cancelButtonTitle:"OK").show()
        }
    }
    
}

// MARK: - MKMapViewDelegate
extension DetailViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if !overlay.isKindOfClass(MKPolyline) {
            return MKOverlayRenderer()
        }
        let polyline = overlay as! MulticolorPolylineSegment
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = polyline.color
        renderer.lineWidth = 3
        return renderer
    }
    
}
