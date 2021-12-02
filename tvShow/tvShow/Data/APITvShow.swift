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

// MARK: - Protocol
protocol APITvShowProtocol {
    func searchShows(term: String, completion: @escaping (Shows?, ErrorType?) -> Void)
    func getEpisodes(showId: Int, completion: @escaping (Episodes?, ErrorType?) -> Void)
    func searchPeople(term: String, completion: @escaping (People?, ErrorType?) -> Void)
}

// MARK: - Class
final class APITvShow: APITvShowProtocol {
    
    // MARK: - Properties
    private let cacher = ResponseCacher(behavior: .cache)
    private let baseUrl = "https://api.tvmaze.com"
    private let embededEpsodesParam = "&embed=epsodes"
    
    // MARK: - Functions
    internal func searchShows(term: String, completion: @escaping (Shows?, ErrorType?) -> Void) {
        
        let searchTerm = term.replacingOccurrences(of: " ", with: "+")
        let url = "\(baseUrl)\(TypeOfSearch.GlobalSearch)\(EndPoint.Show)\(searchTerm)"
        
        AF.request(url)
            .cacheResponse(using: cacher)
            .validate()
            .responseDecodable(of: Shows.self) { response in
                switch response.result {
                case .success:
                    guard let shows = response.value else { return }
                    completion(shows, nil)
                case .failure( _):
                    completion(nil, .requestError)
                }
            }
    }
    
    internal func getEpisodes(showId: Int, completion: @escaping (Episodes?, ErrorType?) -> Void) {
        
        let url = "\(baseUrl)\(TypeOfSearch.Shows)/\(showId)\(EndPoint.Episodes)"
        
        AF.request(url)
            .cacheResponse(using: cacher)
            .validate()
            .responseDecodable(of: Episodes.self) { response in
                switch response.result {
                case .success:
                    guard let episodes = response.value else { return }
                    completion(episodes, nil)
                case .failure( _):
                    completion(nil, .requestError)
                }
            }
    }
    
    internal func searchPeople(term: String, completion: @escaping (People?, ErrorType?) -> Void) {

        let searchTerm = term.replacingOccurrences(of: " ", with: "+")
        let url = "\(baseUrl)\(TypeOfSearch.GlobalSearch)\(EndPoint.People)\(searchTerm)"
        
        AF.request(url)
            .cacheResponse(using: cacher)
            .validate()
            .responseDecodable(of: People.self) { response in
                switch response.result {
                case .success:
                    guard let people = response.value else { return }
                    completion(people, nil)
                case .failure( _):
                    completion(nil, .requestError)
                }
            }
    }
}
