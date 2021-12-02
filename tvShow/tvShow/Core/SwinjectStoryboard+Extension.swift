//
//  SwinjectStoryboard+Extension.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 27/11/21.
//

import Foundation
import Swinject
import SwinjectStoryboard
import SwinjectAutoregistration
import RxCocoa

extension SwinjectStoryboard {
    @objc class func setup() {
        
        // MARK: - API
        defaultContainer.autoregister(APITvShowProtocol.self, initializer: APITvShow.init)
        
        // MARK: - Use Case
        defaultContainer.autoregister(ShowUseCaseProtocol.self, initializer: ShowUseCase.init)
        defaultContainer.autoregister(EpisodesUseCaseProtocol.self, initializer: EpisodesUseCase.init)
        defaultContainer.autoregister(PeopleUseCaseProtocol.self, initializer: PeopleUseCase.init)
        
        // MARK: - ViewModel
        defaultContainer.autoregister(ShowViewModelProtocol.self, initializer: ShowViewModel.init)
        defaultContainer.autoregister(PeopleViewModelProtocol.self, initializer: PeopleViewModel.init)
        
        // MARK: - Controller
        defaultContainer.storyboardInitCompleted(HomeCollectionViewController.self) { resolver, controller in
            controller.viewModel = resolver ~> ShowViewModelProtocol.self
        }
        
        defaultContainer.storyboardInitCompleted(ShowDetailViewController.self) { resolver, controller in
            controller.viewModel = resolver ~> ShowViewModelProtocol.self
        }
        
        defaultContainer.storyboardInitCompleted(EpisodeDetailViewController.self) { _, _ in
            
        }
        
        defaultContainer.storyboardInitCompleted(SearchPeopleCollectionViewController.self) { resolver, controller in
            controller.viewModel = resolver ~> PeopleViewModelProtocol.self
        }
    }
}
