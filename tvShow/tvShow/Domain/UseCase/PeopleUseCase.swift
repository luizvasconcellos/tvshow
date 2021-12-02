//
//  PeopleUseCase.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 28/11/21.
//

import Foundation

// MARK: - Protocol
protocol PeopleUseCaseProtocol {
    func execute(completion: @escaping (People?, ErrorType?) -> Void)
    func with(searchTerm: String) -> PeopleUseCase
}

// MARK: - Class
final class PeopleUseCase: PeopleUseCaseProtocol {
    // MARK: - Properties
    private var api: APITvShowProtocol
    private var searchTerm: String?
    
    // MARK: - Init
    init(api: APITvShowProtocol) {
        self.api = api
    }
    
    // MARK: - Functions
    internal func execute(completion: @escaping (People?, ErrorType?) -> Void) {
        api.searchPeople(term: searchTerm  ?? "", completion: completion)
    }
    
    internal func with(searchTerm: String) -> PeopleUseCase {
        self.searchTerm = searchTerm
        return self
    }
}
