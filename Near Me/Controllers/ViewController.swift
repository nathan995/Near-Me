//
//  ViewController.swift
//  Near Me
//
//  Created by Nathan Getachew on 4/6/23.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    private var places : [PlaceAnnotation] = []
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        //
        setupUI()
    }
    
    
    // MARK: lazy vars
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var searchBar: UITextField = {
        let searchTextField = UITextField()
        searchTextField.delegate = self
        searchTextField.layer.cornerRadius = 10
        searchTextField.clipsToBounds = true
        searchTextField.backgroundColor = .systemBackground
        searchTextField.placeholder = "Search"
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        searchTextField.leftViewMode = .always
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        return searchTextField
    }()
    
    
    // MARK: Private functions
    
    private func setupUI(){
        view.addSubview(mapView)
        mapView.widthAnchor.constraint(equalTo:  view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(searchBar)
        searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalToConstant: view.bounds.size.width/1.2).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.topAnchor,constant: 60).isActive = true
        searchBar.returnKeyType = .search
    }
    
    private func findNearbyPlaces(near query : String){
        mapView.removeAnnotations(mapView.annotations)
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start {[weak self] response, error in
            guard let response = response, error == nil else { return }
            
            self?.places = response.mapItems.map(PlaceAnnotation.init)
            self?.places.forEach { place in
                self?.mapView.addAnnotation(place)
            }
            if let places = self?.places {
                self?.presentPlacesSheet(places:places)
            }
            print(response.mapItems)
        }
        
    }
    
    private func presentPlacesSheet(places:[PlaceAnnotation]){
        let placesTVC = PlacesTableViewController(userLocation: locationManager?.location ?? CLLocation.defaultLocation, places: places)
        placesTVC.modalPresentationStyle = .pageSheet
        
        
        if let sheet = placesTVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.large(),.medium()]
            
            present(placesTVC, animated: true)
        }
    }
    
}


extension ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let locationManager = locationManager,
              let location = locationManager.location else { return }
        
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        case .denied:
            print("Location access denied.")
        case .notDetermined,.restricted:
            print("Location not determined")
        @unknown default:
            print("Unknown case. Unable to get location.")
            
            
        }
    }
}

extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        if !text.isEmpty {
            textField.resignFirstResponder()
            findNearbyPlaces(near: text)
        }
        
        return true
    }
}



extension ViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        
        self.places = self.places.map { place in
            place.isSelected = false
            return place
        }
        
        
        guard let selectedAnnotation = annotation as? PlaceAnnotation else { return }
        
        
        let placeAnnotation = self.places.first(where: {
            $0.id == selectedAnnotation.id
        })
        placeAnnotation?.isSelected = true
        presentPlacesSheet(places: self.places)
    }
}
