//
//  Extensions.swift
//  Near Me
//
//  Created by Nathan Getachew on 4/6/23.
//

import Foundation
import CoreLocation

extension CLLocation {
    static let defaultLocation = CLLocation (latitude: 36.063457, longitude: -95.880516)
}


extension String {
    
    var formatPhoneForCall: String {
        self.replacingOccurrences(of: " " , with : "#")
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-" , with: "")
    }
}
