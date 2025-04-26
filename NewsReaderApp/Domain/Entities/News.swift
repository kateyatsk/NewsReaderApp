//
//  News.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 25.04.25.
//
import Foundation

struct News: Equatable {
    let title: String
    let description: String
    let url: String
    let urlToImage: String?
    let publishedAt: Date
    let source: String
    let author: String?
    let content: String?
}
