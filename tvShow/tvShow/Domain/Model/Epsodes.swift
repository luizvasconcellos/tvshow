//
//  Epsodes.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 27/11/21.
//

import Foundation

typealias Episodes = [Episode]

struct Episode: Codable {
    let id: Int?
    let url: String?
    let name: String?
    let season, number: Int?
    let image: Image?
    let summary: String?

    enum CodingKeys: String, CodingKey {
        case id, url, name, season, number
        case image, summary
    }
}
