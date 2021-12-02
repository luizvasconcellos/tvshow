//
//  String+Html.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 28/11/21.
//

import Foundation

extension String {
    func removeHtml() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
