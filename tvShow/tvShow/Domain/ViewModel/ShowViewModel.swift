//
//  ShowViewModel.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 27/11/21.
//

import Foundation
import RxCocoa
import RxSwift

// MARK: - Protocol
protocol ShowViewModelProtocol {
    var searchShowsError: BehaviorRelay<Void> { get set }
    var searchShowsSuccess: BehaviorRelay<Shows?> { get set }
    var getEpisodesError: BehaviorRelay<Void> { get set }
    var getEpisodesSuccess: BehaviorRelay<Episodes?> { get set }
    var getShowsSuccess: BehaviorRelay<[ShowClass]?> { get set }
    
    func searchShows(with searchTerm: String)
    func getEpisodes(for showId: Int)
    func getShows(for urls: [String])
}

// MARK: - class
final class ShowViewModel: ShowViewModelProtocol {
    
    // MARK: - Properties
    private var showUseCase: ShowUseCaseProtocol
    private var episodesUseCase: EpisodesUseCaseProtocol
    
    var searchShowsError = BehaviorRelay<Void>(value: ())
    var searchShowsSuccess = BehaviorRelay<Shows?>(value: nil)
    var getEpisodesError = BehaviorRelay<Void>(value: ())
    var getEpisodesSuccess = BehaviorRelay<Episodes?>(value: nil)
    var getShowsSuccess = BehaviorRelay<[ShowClass]?>(value: nil)
    
    // MARK: - Init
    init(showUseCase: ShowUseCaseProtocol, episodesUseCase: EpisodesUseCaseProtocol) {
        self.showUseCase = showUseCase
        self.episodesUseCase = episodesUseCase
    }
    
    // MARK: - Functions
    internal func searchShows(with searchTerm: String) {
        showUseCase
            .with(searchTerm: searchTerm)
            .execute { shows, error in
                if let _ = error {
                    self.searchShowsError.accept(())
                    return
                }
                self.searchShowsSuccess.accept(shows)
            }
    }
    
    internal func getEpisodes(for showId: Int) {
        episodesUseCase
            .with(showId: showId)
            .execute { episodes, error in
                if let _ = error {
                    self.getEpisodesError.accept(())
                    return
                }
                self.getEpisodesSuccess.accept(episodes)
            }
    }
    
    internal func getShows(for urls: [String]) {
        showUseCase
            .with(shows: urls)
            .executeGetShows { shows in
                self.getShowsSuccess.accept(shows)
            }
    }
}
