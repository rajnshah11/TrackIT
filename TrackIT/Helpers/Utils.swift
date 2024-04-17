//
//  Utils.swift
//  TrackIT
//
//  Created by Raj Shah on 4/17/24.
//
import Foundation

struct Utils {
    
    static let dateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()
    
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.isLenient = false
        formatter.numberStyle = .currency
        return formatter
    }()
    
}
