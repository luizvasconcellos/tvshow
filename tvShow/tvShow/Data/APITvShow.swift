//
//  APITvShow.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 27/11/21.
//

import Foundation
import Alamofire

// MARK: - Enum & Struct
enum ErrorType: Error {
    case requestError
}

private struct TypeOfSearch {
    static let GlobalSearch = "/search"
    static let SingleSearch = "/singlesearch"
    static let Shows = "/shows"
}

private struct EndPoint {
    static let Show = "/shows?q="
    static let People = "/people?q="
    static let Episodes = "/episodes"
}

private struct Parameters {
    static let embededEpsodesParam = "&embed=epsodes"
    static let embededCastCredits = "?embed=castcredits"
}

// MARK: - Protocol
protocol APITvShowProtocol {
    func searchShows(term: String, completion: @escaping (Shows?, ErrorType?) -> Void)
    func getEpisodes(showId: Int, completion: @escaping (Episodes?, ErrorType?) -> Void)
    func searchPeople(term: String, completion: @escaping (People?, ErrorType?) -> Void)
    func getPersonWithCastCredit(for personUrl: String, completion: @escaping (PersonClass?, ErrorType?) -> Void)
    func getShows(for urlList: [String], completion: @escaping ([ShowClass]?) -> Void)
}

// MARK: - Class
final class APITvShow: APITvShowProtocol {
    
    // MARK: - Properties
    private let cacher = ResponseCacher(behavior: .cache)
    private let baseUrl = "https://api.tvmaze.com"
    
    // MARK: - Functions
    internal func searchShows(term: String, completion: @escaping (Shows?, ErrorType?) -> Void) {
        
        let searchTerm = term.replacingOccurrences(of: " ", with: "+")
        let url = "\(baseUrl)\(TypeOfSearch.GlobalSearch)\(EndPoint.Show)\(searchTerm)"
        
        fetch(for: url, completion: completion)
    }
    
    internal func getEpisodes(showId: Int, completion: @escaping (Episodes?, ErrorType?) -> Void) {
        
        let url = "\(baseUrl)\(TypeOfSearch.Shows)/\(showId)\(EndPoint.Episodes)"
        
        fetch(for: url, completion: completion)
    }
    
    internal func searchPeople(term: String, completion: @escaping (People?, ErrorType?) -> Void) {

        let searchTerm = term.replacingOccurrences(of: " ", with: "+")
        let url = "\(baseUrl)\(TypeOfSearch.GlobalSearch)\(EndPoint.People)\(searchTerm)"
        
        fetch(for: url, completion: completion)
    }
    
    internal func getPersonWithCastCredit(for personUrl: String, completion: @escaping (PersonClass?, ErrorType?) -> Void) {
        let url = personUrl + Parameters.embededCastCredits
        
        fetch(for: url, completion: completion)
    }
    
    internal func getShows(for urlList: [String], completion: @escaping ([ShowClass]?) -> Void) {
        fetchList(urlList, of: ShowClass.self, completion: completion)
    }
    
    private func fetch<T: Decodable>(for url: String, type: T.Type = T.self, completion: @escaping (T?, ErrorType?) -> Void) {
        AF.request(url)
            .validate()
            .responseDecodable(of: type) { response in
                switch response.result {
                case .success:
                    guard let response = response.value else { return }
                    completion(response, nil)
                case .failure( _):
                    completion(nil, .requestError)
                }
            }
    }
    
    private func fetchList<T: Decodable>(_ list: [String], of: T.Type, completion: @escaping ([T]?) -> Void) {
        var items: [T] = []
        let fetchGroup = DispatchGroup()
        
        list.forEach { (url) in
            fetchGroup.enter()

            AF.request(url).validate().responseDecodable(of: T.self) { (response) in
                if let value = response.value {
                    items.append(value)
                }
                fetchGroup.leave()
            }
        }
        
        fetchGroup.notify(queue: .main) {
            completion(items)
        }
    }
}
