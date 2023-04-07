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
    var places : [PlaceAnnotation]
    
    
    init(userLocation:CLLocation,places:[PlaceAnnotation]) {
        self.userLocation = userLocation
        self.places = places
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlaceCell")
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        self.places.swapAt(indexForSelectedRow ?? 0, 0)
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
        content.image = UIImage(systemName: pointOfInterestCategoryToSFSymbol(place.category))
        
        
        cell.contentConfiguration = content
        cell.backgroundColor = place.isSelected ? .gray : .systemBackground
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        let placeDetailVC  = PlaceDetailViewController(place: place)
        
        present(placeDetailVC, animated: true)
    }
    
    // MARK: private functions
    
    private func calculateDistance(from : CLLocation, to : CLLocation)->String{
        let distance = from.distance(from: to)
        let meters  = Measurement(value: distance, unit: UnitLength.meters)
        return meters.converted(to:.miles).formatted()
        
    }
   
    private func pointOfInterestCategoryToSFSymbol(_ category: MKPointOfInterestCategory) -> String {
        switch category {
        case .airport:
            return "airplane"
        
        case .atm:
            return "dollarsign"
        case .cafe:
            return "cup.and.saucer.fill"
        case .hospital:
            return "stethoscope"
        case .hotel:
            return "bed.double.fill"
        case .restaurant:
            return "fork.knife"
        case .pharmacy:
            return "cross.fill"
            // and so on for other categories
        default:
            return "square.fill"
        }
    }
    
    private var indexForSelectedRow : Int? {
        places.firstIndex(where: {$0.isSelected})
    }
}
