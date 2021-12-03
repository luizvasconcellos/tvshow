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
    func executeGetPersonInfo(completion: @escaping (PersonClass?, ErrorType?) -> Void)
    func with(searchTerm: String) -> PeopleUseCase
    func with(url: String) -> PeopleUseCase
}

// MARK: - Class
final class PeopleUseCase: PeopleUseCaseProtocol {
    // MARK: - Properties
    private var api: APITvShowProtocol
    private var searchTerm: String?
    private var url: String?
    
    // MARK: - Init
    init(api: APITvShowProtocol) {
        self.api = api
    }
    
    // MARK: - Functions
    internal func execute(completion: @escaping (People?, ErrorType?) -> Void) {
        api.searchPeople(term: searchTerm  ?? "", completion: completion)
    }
    
    internal func executeGetPersonInfo(completion: @escaping (PersonClass?, ErrorType?) -> Void) {
        api.getPersonWithCastCredit(for: url ?? "", completion: completion)
    }
    
    internal func with(searchTerm: String) -> PeopleUseCase {
        self.searchTerm = searchTerm
        return self
    }
    
    internal func with(url: String) -> PeopleUseCase {
        self.url = url
        return self
    }
}
