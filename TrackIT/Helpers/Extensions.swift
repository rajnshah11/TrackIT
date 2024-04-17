//
//  Extensions.swift
//  TrackIT
//
//  Created by Raj Shah on 4/17/24.
//


import Foundation

extension Double {
    
    var formattedCurrencyText: String {
        return Utils.numberFormatter.string(from: NSNumber(value: self)) ?? "0"
    }
    
}

