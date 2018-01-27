//
//  MapKitStuff.swift
//  Linky
//
//  Created by Alican Yilmaz on 22/11/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import Foundation
import MapKit

extension CheckinViewController {
    func addAnnotationAndRange(checkin:CheckinModel){
            self.clearAnnotationAndRange()
            let circle = MKCircle(center: checkin.coordinate, radius: Double(checkin.range))
            self.mapView.add(circle)
            self.mapView.addAnnotation(checkin) 
    }
    
    func clearAnnotationAndRange(){
            for annotation in self.mapView.annotations{
                self.mapView.removeAnnotation(annotation)
            }
            for overlay in self.mapView.overlays{
                self.mapView.remove(overlay)
            }           
    }
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = .green
            circleRenderer.fillColor = UIColor.green.withAlphaComponent(0.4)
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "myGeotification"
        if annotation is CheckinModel {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.leftCalloutAccessoryView = UIButton(type: .infoDark)
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
        if annotation is MKUserLocation {
            return nil
        }
        return nil
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "editCheckinSegue", sender: self)
        
    }
    
}
