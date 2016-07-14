//
//  ViewController.swift
//  CustomMapAnnotation
//
//  Created by Luke Van In on 2016/07/14.
//  Copyright © 2016 Luke Van In. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var locationManager: CLLocationManager?

    var currentLocation: MKUserLocation? {
        didSet {
            button.hidden = (currentLocation == nil)
        }
    }

    lazy var formatter: NSDateFormatter = {

        let formatter = NSDateFormatter()
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        return formatter
    }()

    @IBOutlet var button: UIButton!
    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {

        super.viewDidLoad()

        if CLLocationManager.locationServicesEnabled() {

            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest

            switch CLLocationManager.authorizationStatus() {

            case .AuthorizedAlways, .AuthorizedWhenInUse:
                locationManager?.startUpdatingLocation()
                mapView.showsUserLocation = true

            default:
                locationManager?.requestWhenInUseAuthorization()
            }
        }
    }

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        switch status {

        case .AuthorizedAlways, .AuthorizedWhenInUse:
            locationManager?.startUpdatingLocation()
            mapView.showsUserLocation = true

        case .Denied, .Restricted:
            locationManager?.startUpdatingLocation()
            mapView.showsUserLocation = false
            currentLocation = nil

        default:
            currentLocation = nil
        }
    }

    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {

        currentLocation = userLocation
    }

    @IBAction func addButtonTapped(sender: AnyObject) {

        guard let coordinate = currentLocation?.coordinate else {
            return
        }

        let reportTime = NSDate()
        let formattedTime = formatter.stringFromDate(reportTime)

        let annotation = MKPointAnnotation()
        annotation.title = "Annotation Created"
        annotation.subtitle = formattedTime
        annotation.coordinate = coordinate

        mapView.addAnnotation(annotation)
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

        guard !annotation.isKindOfClass(MKUserLocation) else {

            return nil
        }

        let annotationIdentifier = "AnnotationIdentifier"

        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }

        annotationView!.image = UIImage(named: "smile")

        return annotationView

    }
}

