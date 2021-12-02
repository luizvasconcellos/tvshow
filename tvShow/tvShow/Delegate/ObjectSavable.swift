//
//  ObjectSavable.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 28/11/21.
//

import Foundation

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}
