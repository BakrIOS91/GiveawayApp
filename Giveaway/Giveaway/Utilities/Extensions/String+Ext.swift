//
//  String+Ext.swift
//  Giveaway
//
//  Created by Bakr mohamed on 27/01/2025.
//

import Foundation

extension String {
    func convertDate(from inputFormat: String, to outputFormat: String) -> String {
        let dateFormatter = DateFormatter()
        
        // Set the input date format
        dateFormatter.dateFormat = inputFormat
        
        // Convert the string into a Date object
        if let date = dateFormatter.date(from: self) {
            
            // Set the output date format
            dateFormatter.dateFormat = outputFormat
            
            // Convert the Date object back to a string in the desired format
            return dateFormatter.string(from: date)
        }
        
        return "Invalid date"
    }
}
