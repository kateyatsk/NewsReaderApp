//
//  NewsCategory.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 28.04.25.
//

import Foundation

enum NewsCategory: String, CaseIterable {
    case general
    case business
    case entertainment
    case health
    case science
    case sport
    case technology
    
    var displayName: String {
        switch self {
        case .general: "General"
        case .business: "Business"
        case .entertainment: "Entertainment"
        case .health: "Health"
        case .science: "Science"
        case .sport: "Sport"
        case .technology: "Technology"
        }
    }
}
