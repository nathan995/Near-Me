//
//  PlacesTableViewController.swift
//  Near Me
//
//  Created by Nathan Getachew on 4/6/23.
//

import Foundation
import UIKit
import MapKit

class PlacesTableViewController : UITableViewController {
    
    var userLocation : CLLocation
    let places : [PlaceAnnotation]
    
    
    init(userLocation:CLLocation,places:[PlaceAnnotation]) {
        self.userLocation = userLocation
        self.places = places
        super.init(nibName: nil, bundle: nil)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlaceCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell",for: indexPath)
        let place = places[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = place.name
        content.secondaryText = calculateDistance(from: userLocation, to: place.location)
        
        cell.contentConfiguration = content
        return cell
    }
    
    private func calculateDistance(from:CLLocation,to:CLLocation)->String{
        let distance = from.distance(from: to)
        let meters  = Measurement(value: distance, unit: UnitLength.meters)
        return meters.converted(to:.miles).formatted()
        
    }
    
}
