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
    let links: PersonLinks?
    let embedded: Embedded?

    enum CodingKeys: String, CodingKey {
        case id, url, name, image
        case links = "_links"
        case embedded = "_embedded"
    }
}

// MARK: - Embedded
struct Embedded: Codable {
    let castcredits: [Castcredit]?
}

// MARK: - Castcredit
struct Castcredit: Codable {
    let castcreditSelf, voice: Bool?
    let links: CastcreditLinks?

    enum CodingKeys: String, CodingKey {
        case castcreditSelf = "self"
        case voice
        case links = "_links"
    }
}

// MARK: - CastcreditLinks
struct CastcreditLinks: Codable {
    let show, character: SelfClass?
}

// MARK: - SelfClass
struct SelfClass: Codable {
    let href: String?
}

// MARK: - Links
struct PersonLinks: Codable {
    let linksSelf: SelfClass?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}
