//
//  Array+Unique.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 28/11/21.
//

import Foundation

extension Array {
    func unique<T:Hashable>(by: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>()
        var arrayOrdered = [Element]()
        for value in self {
            if !set.contains(by(value)) {
                set.insert(by(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
    }
}
