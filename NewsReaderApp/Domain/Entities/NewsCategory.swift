//
//  NewsCategory.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 28.04.25.
//

import Foundation

enum NewsCategory: String, CaseIterable {
    case business
    case entertainment
    case general
    case health
    case science
    case sport
    case technology
    
    var displayName: String {
        switch self {
        case .business: "Бизнес"
        case .entertainment: "Развлечения"
        case .general: "Общие"
        case .health: "Здоровье"
        case .science: "Наука"
        case .sport: "Спорт"
        case .technology: "Технологии"
        }
    }
}
