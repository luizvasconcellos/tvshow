//
//  PersonDetailViewController.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 02/12/21.
//

import UIKit
import RxSwift
import Kingfisher

class PersonDetailViewController: UIViewController {

    // MARK: - UI Elements
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var photo: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private lazy var name: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        view.textColor = .darkGray
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    // MARK: - Properties
    var viewModel: PeopleViewModelProtocol?
    var showViewModel: ShowViewModelProtocol?
    var personUrl: String?
    private var shows: [ShowClass]? = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var person: PersonClass?
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = "Person Info"
        
        addObservable()
        setupUI()
        guard let personUrl = personUrl else {
            return
        }
        viewModel?.getPersonInfo(from: personUrl)
    }

    // MARK: - Private Functions
    private func addObservable() {
        viewModel?.getPersonInfoError.asObservable().skip(1).subscribe(onNext: { _ in
            ToastMessage.show(message: "Sorry, we had to get person info :( Please, try again later",
                              position: .bottom,
                              type: .error)
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        viewModel?.getPersonInfoSuccess.asObservable().skip(1).subscribe(onNext: { [weak self] person in
            guard let self = self else { return }
            self.person = person
            var showsUrls: [String] = []
            person?.embedded?.castcredits?.forEach({ cast in
                if let url = cast.links?.show?.href {
                    showsUrls.append(url)
                }
            })
            if showsUrls.count > 0 {
                self.showViewModel?.getShows(for: showsUrls)
            }
            self.bindUI()
        }).disposed(by: disposeBag)
        
        showViewModel?.getShowsSuccess.asObservable().skip(1).subscribe(onNext: { [weak self] shows in
            guard let self = self else { return }
            self.tableView.isHidden = false
            if shows?.count == 0 {
                self.tableView.isHidden = true
                return
            }
            self.shows = shows
        }).disposed(by: disposeBag)
    }
    
    private func setupUI() {
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(photo)
        contentView.addSubview(name)
        contentView.addSubview(tableView)
        
        let navigationHeight = navigationController?.navigationBar.intrinsicContentSize.height ?? 0.0
        let tabBarHeight = tabBarController?.tabBar.intrinsicContentSize.height ?? 0.0
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationHeight),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarHeight)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            photo.topAnchor.constraint(equalTo: contentView.topAnchor),
            photo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 12),
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 350),
            tableView.topAnchor.constraint(greaterThanOrEqualTo: name.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func bindUI() {
        name.text = person?.name
        displayImage()
        view.layoutIfNeeded()
    }
    
    private func displayImage() {
        if let imageUrl = person?.image?.medium {
            KF.url(URL(string: imageUrl))
                .cacheOriginalImage(true)
                .waitForCache(true)
                .onSuccess({ (result) in }).set(to: photo)
            return
        }
    }
}

extension PersonDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Casting Shows"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "personShowCell")
        cell.textLabel?.text = shows?[indexPath.row].name
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ShowDetailViewController") as? ShowDetailViewController {
            
            if let showObj = shows?[indexPath.row] {
                vc.show = Show(show: showObj)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
