//
//  People.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 28/11/21.
//

import Foundation

typealias People = [Person]

// MARK: - Person
struct Person: Codable {
    let person: PersonClass?
}

// MARK: - PersonClass
struct PersonClass: Codable {
    let id: Int?
    let url: String?
    let name: String?
    let image: Image?

    enum CodingKeys: String, CodingKey {
        case id, url, name, image
    }
}
