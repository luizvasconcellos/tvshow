//
//  ShowUseCase.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 27/11/21.
//

import Foundation

// MARK: - Protocol
protocol ShowUseCaseProtocol {
    func execute(completion: @escaping (Shows?, ErrorType?) -> Void)
    func with(searchTerm: String) -> ShowUseCase
}

// MARK: - Class
final class ShowUseCase: ShowUseCaseProtocol {
    // MARK: - Properties
    private var api: APITvShowProtocol
    private var searchTerm: String?
    
    // MARK: - Init
    init(api: APITvShowProtocol){
        self.api = api
    }
    
    // MARK: - Functions
    internal func execute(completion: @escaping (Shows?, ErrorType?) -> Void) {
        api.searchShows(term: searchTerm ?? "", completion: completion)
    }
    
    internal func with(searchTerm: String) -> ShowUseCase {
        self.searchTerm = searchTerm
        return self
    }
}
