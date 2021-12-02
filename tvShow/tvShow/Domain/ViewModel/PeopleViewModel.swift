//
//  PeopleViewModel.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 28/11/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol PeopleViewModelProtocol {
    var searchPeopleError: BehaviorRelay<Void> { get set }
    var searchPeopleSuccess: BehaviorRelay<People?> { get set }
    
    func searchPeople(with searchTerm: String)
}

final class PeopleViewModel: PeopleViewModelProtocol {
    // MARK: - Properties
    private var peopleUseCase: PeopleUseCaseProtocol
    
    var disposeBag = DisposeBag()
    var searchPeopleError = BehaviorRelay<Void>(value: ())
    var searchPeopleSuccess = BehaviorRelay<People?>(value: nil)
    
    // MARK: - Init
    init(peopleUseCase: PeopleUseCaseProtocol) {
        self.peopleUseCase = peopleUseCase
    }
    
    // MARK: - Functions
    internal func searchPeople(with searchTerm: String) {
        peopleUseCase
            .with(searchTerm: searchTerm)
            .execute { people, error in
                if let _ = error {
                    self.searchPeopleError.accept(())
                    return
                }
                self.searchPeopleSuccess.accept(people)
            }
    }
}
