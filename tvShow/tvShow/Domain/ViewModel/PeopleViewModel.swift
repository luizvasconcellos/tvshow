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
    var getPersonInfoError: BehaviorRelay<Void> { get set }
    var getPersonInfoSuccess: BehaviorRelay<PersonClass?> { get set }
    
    func searchPeople(with searchTerm: String)
    func getPersonInfo(from url: String)
}

final class PeopleViewModel: PeopleViewModelProtocol {
    
    // MARK: - Properties
    private var peopleUseCase: PeopleUseCaseProtocol
    
    var disposeBag = DisposeBag()
    var searchPeopleError = BehaviorRelay<Void>(value: ())
    var searchPeopleSuccess = BehaviorRelay<People?>(value: nil)
    var getPersonInfoError = BehaviorRelay<Void>(value: ())
    var getPersonInfoSuccess = BehaviorRelay<PersonClass?>(value: nil)
    
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
    
    internal func getPersonInfo(from url: String) {
        peopleUseCase
            .with(url: url)
            .executeGetPersonInfo { person, error in
                if let _ = error {
                    self.getPersonInfoError.accept(())
                    return
                }
                self.getPersonInfoSuccess.accept(person)
            }
    }
}
