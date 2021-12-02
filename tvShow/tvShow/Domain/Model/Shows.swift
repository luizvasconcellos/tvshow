//
//  Shows.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 27/11/21.
//

import Foundation

// MARK: - Shows
typealias Shows = [Show]

// MARK: - Show
struct Show: Codable {
    var show: ShowClass?
}

// MARK: - ShowClass
struct ShowClass: Codable {
    let id: Int?
    let url: String?
    let name: String?
    let genres: [String]?
    let schedule: Schedule?
    let image: Image?
    let summary: String?
    let links: Links?
    var episodes: Episodes = []

    enum CodingKeys: String, CodingKey {
        case id, url, name, genres
        case schedule
        case image, summary
        case links = "_links"
    }
}

// MARK: - Image
struct Image: Codable {
    let medium, original: String?
}

// MARK: - Links
struct Links: Codable {
    let linksSelf: Nextepisode?
    let previousepisode, nextepisode: Nextepisode?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case previousepisode, nextepisode
    }
}

// MARK: - Nextepisode
struct Nextepisode: Codable {
    let href: String?
}

// MARK: - Schedule
struct Schedule: Codable {
    let time: String?
    let days: [String]?
}
