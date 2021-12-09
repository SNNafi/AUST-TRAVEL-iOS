//
//  GoogleMapView.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 6/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI
import GoogleMaps
import GoogleMapsUtils
import Defaults

enum MapBinding {
    case busLatestMarker
    case markers
    case selectedMarker
    case selectedMarker2
    case currentLocation
    case centerToBus
    case multiple
}

struct GoogleMapView: UIViewControllerRepresentable {
    
    @Binding var selectedCoordinater: CLLocationCoordinate2D?
    @Binding var busLatestMarker: GMSMarker?
    @Binding var markers: [GMSMarker]
    @Binding var currentLocation: CLLocation?
    @Binding var mapBinding: MapBinding
    var didTap: (GMSMarker) -> (Bool)
    var didTapInfoWindowOf: (GMSMarker) -> ()
    var locationManager = CLLocationManager()
    let mapViewController = MapViewController()
    let preciseLocationZoomLevel: Float = 15.0
    let approximateLocationZoomLevel: Float = 10.0
    
    func makeUIViewController(context: Context) -> MapViewController {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 10
        locationManager.delegate = context.coordinator
        locationManager.requestLocation()
        mapViewController.map.selectedMarker = nil
        mapViewController.map.delegate = context.coordinator
        return mapViewController
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        switch mapBinding {
        case .busLatestMarker:
            print("busLatestMarker")
            busLatestMarker?.map = uiViewController.map
        case .markers:
            print("markers")
            markers.forEach { $0.map = uiViewController.map }
        case .selectedMarker: fallthrough
        case .selectedMarker2:
            print("selectedMarker")
            if let selectedCoordinater = selectedCoordinater {
                uiViewController.cbounds =  uiViewController.cbounds.includingCoordinate(selectedCoordinater)
                let update = GMSCameraUpdate.fit(uiViewController.cbounds)
                uiViewController.map.animate(with: update)
            }
        case .currentLocation:
            break
        case .centerToBus:
            print("centerToBus")
            busLatestMarker?.map = uiViewController.map
            if let busLatestMarker = busLatestMarker {
                uiViewController.cbounds =  uiViewController.cbounds.includingCoordinate(busLatestMarker.position)
                let update = GMSCameraUpdate.fit(uiViewController.cbounds)
                uiViewController.map.animate(with: update)
            }
        case .multiple:
            print("multiple")
            busLatestMarker?.map = uiViewController.map
        }
        markers.forEach { $0.map = uiViewController.map }
    }
    
    
    final class MapViewCoordinator: NSObject, GMSMapViewDelegate, CLLocationManagerDelegate {
        var googleMapView: GoogleMapView
        
        init(_ mapViewControllerBridge: GoogleMapView) {
            self.googleMapView = mapViewControllerBridge
        }
        
        
        // MARK: GMSMapViewDelegate
        
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            
        }
        
        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        }
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            return self.googleMapView.didTap(marker)
        }
        
        func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
            if let route = marker.userData as? Route {
                let infoWindow = UIHostingController(rootView: MapInfoView(route: route)).view!
                infoWindow.frame = CGRect(x: 0, y: 0, width: 200.dWidth() , height: 150.dWidth())
                infoWindow.backgroundColor = UIColor.clear
                return infoWindow
            }
            return nil
        }
        
        func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
            self.googleMapView.didTapInfoWindowOf(marker)
        }
        
        // MARK: CLLocationManagerDelegate
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let location: CLLocation = locations.last!
            print("Location: \(location)")
            var zoomLevel = googleMapView.approximateLocationZoomLevel
            if #available(iOS 14.0, *) {
                zoomLevel = manager.accuracyAuthorization == .fullAccuracy ? googleMapView.preciseLocationZoomLevel : googleMapView.approximateLocationZoomLevel
            }
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: zoomLevel)
            let mapView = self.googleMapView.mapViewController.map
            if mapView.isHidden {
                mapView.isHidden = false
                mapView.camera = camera
            } else {
                mapView.animate(to: camera)
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            
            if #available(iOS 14.0, *) {
                let accuracy = manager.accuracyAuthorization
                switch accuracy {
                case .fullAccuracy:
                    print("Location accuracy is precise.")
                case .reducedAccuracy:
                    print("Location accuracy is not precise.")
                @unknown default:
                    fatalError()
                }
            }
            
            switch status {
            case .restricted:
                print("Location access was restricted.")
            case .denied:
                print("User denied access to location.")
            case .notDetermined:
                print("Location status not determined.")
            case .authorizedAlways: fallthrough
            case .authorizedWhenInUse:
                print("Location status is OK.")
                manager.requestLocation()
            @unknown default:
                fatalError()
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            manager.stopUpdatingLocation()
        }
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(self)
    }
}

