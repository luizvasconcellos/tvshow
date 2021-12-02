//
//  EpisodesUseCase.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 27/11/21.
//

import Foundation

// MARK: - Protocol
protocol EpisodesUseCaseProtocol {
    func execute(completion: @escaping (Episodes?, ErrorType?) -> Void)
    func with(showId: Int) -> EpisodesUseCase
}

// MARK: - Class
final class EpisodesUseCase: EpisodesUseCaseProtocol {
    // MARK: - Properties
    private var api: APITvShowProtocol
    private var showId: Int?
    
    // MARK: - Init
    init(api: APITvShowProtocol){
        self.api = api
    }
    
    // MARK: - Functions
    internal func execute(completion: @escaping (Episodes?, ErrorType?) -> Void) {
        guard let showId = showId else { return }
        api.getEpisodes(showId: showId, completion: completion)
    }
    
    internal func with(showId: Int) -> EpisodesUseCase {
        self.showId = showId
        return self
    }
}
