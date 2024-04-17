//
//  Sort.swift
//  TrackIT
//
//  Created by Raj Shah on 4/17/24.
//

import Foundation

enum SortType: String, CaseIterable {
    case date
}

enum SortOrder: String, CaseIterable {
    case ascending
    case descending
}

extension SortType: Identifiable {
    var id: String {rawValue}
}

extension SortOrder: Identifiable {
    var id: String {rawValue}
}
