//
//  ShowDetailViewController.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 27/11/21.
//

import UIKit
import Kingfisher
import RxSwift

class ShowDetailViewController: UIViewController {

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
    
    private lazy var showPoster: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 4
        view.distribution = .fillProportionally
        
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
    
    private lazy var genres: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.textColor = .darkGray
        
        return view
    }()
    
    private lazy var schedule: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.textColor = .darkGray
        
        return view
    }()
    
    private lazy var summary: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.textAlignment = .justified
        view.lineBreakMode = .byWordWrapping
        
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    // MARK: - Properties
    var viewModel: ShowViewModelProtocol?
    var show: Show?
    private var disposeBag = DisposeBag()
    private let favoriteImage = UIImage(systemName: "heart.fill")?.withTintColor(.systemGray4, renderingMode: .alwaysOriginal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = show?.show?.name
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addObservables()
        setupUI()
        addFavoriteButton()
        bindUI()
    }
    
    // MARK: - Add Observable
    private func addObservables() {
        viewModel?.getEpisodesError.asObservable().skip(1).subscribe(onNext: { _ in
            print("Error to get Episodes")
            ToastMessage.show(message: "Sorry, we had an internal problem to get episodes list :( Please, try again later",
                              position: .bottom,
                              type: .error)
            self.tableView.isHidden = true
        }).disposed(by: disposeBag)
        
        viewModel?.getEpisodesSuccess.asObservable().skip(1).subscribe(onNext: { episodes in
            guard let episodes = episodes else { return }
            self.show?.show?.episodes = episodes
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Private Functions
    private func setupUI() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(showPoster)

        stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(genres)
        stackView.addArrangedSubview(schedule)
        stackView.addArrangedSubview(summary)
        contentView.addSubview(stackView)
        
        contentView.addSubview(tableView)
        
        let navigationHeight = navigationController?.navigationBar.intrinsicContentSize.height ?? 0.0
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationHeight),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
            showPoster.topAnchor.constraint(equalTo: contentView.topAnchor),
            showPoster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            showPoster.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: showPoster.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 240),
            tableView.topAnchor.constraint(greaterThanOrEqualTo: stackView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func addFavoriteButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: favoriteImage, style: .plain, target: self, action: #selector(saveFavorite))
    }
    
    private func bindUI() {
        getEpisodes()
        
        name.text = show?.show?.name
        genres.text = show?.show?.genres?.joined(separator: ", ")
        if let weekDays = show?.show?.schedule?.days?.joined(separator: ", ") {
            schedule.text = "On \(weekDays) "
        }
        if let hour = show?.show?.schedule?.time,
           !hour.isEmpty {
            schedule.text = "\(schedule.text ?? "")at \(hour)"
        }
        
        summary.text = show?.show?.summary?.removeHtml()
        displayImage()
        checkFavorite()
    }
    
    private func displayImage() {
        if let imageUrl = show?.show?.image?.medium {
            KF.url(URL(string: imageUrl))
                .cacheOriginalImage(true)
                .waitForCache(true)
                .onSuccess({ (result) in }).set(to: showPoster)
            return
        }
    }
    
    private func getEpisodes() {
        guard let showId = show?.show?.id else { return }
        viewModel?.getEpisodes(for: showId)
    }
    
    private func removeHtml(string: String) -> String {
        return string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    @objc private func saveFavorite() {
        guard let show = show else { return }
        if UserDefaultsManager.shared.isFavorited(show: show) {
            if UserDefaultsManager.shared.removeFromFavorite(show: show) {
                navigationItem.rightBarButtonItem?.image = favoriteImage
                ToastMessage.show(message: "The TV Show was removed from your favorite list with success.",
                                  position: .bottom,
                                  type: .success)
            } else {
                ToastMessage.show(message: "We have a problem to remove this Show from your list, please try again later.",
                                  position: .bottom,
                                  type: .error)
            }
            return
        }
        if UserDefaultsManager.shared.addToFavorite(show: show) {
            navigationItem.rightBarButtonItem?.image = favoriteImage?.withTintColor(.red, renderingMode: .alwaysOriginal)
            ToastMessage.show(message: "The TV Show was included to your favorite list with success.",
                              position: .bottom,
                              type: .success)
        } else {
            ToastMessage.show(message: "We have a problem to include this Show from your list, please try again later.",
                              position: .bottom,
                              type: .error)
        }
    }
    
    private func checkFavorite() {
        navigationItem.rightBarButtonItem?.image = favoriteImage
        guard let show = show else { return }
        if UserDefaultsManager.shared.isFavorited(show: show) {
            navigationItem.rightBarButtonItem?.image = favoriteImage?.withTintColor(.red, renderingMode: .alwaysOriginal)
        }
    }
}

// MARK: - TableView delegate and datasource
extension ShowDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let episodesInSection = show?.show?.episodes.filter({ $0.season == indexPath.section + 1 }),
              let number = episodesInSection[indexPath.row].number,
              let name = episodesInSection[indexPath.row].name else { return UITableViewCell() }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "EpisodeCell")
        cell.textLabel?.text = "Ep \(number) - \(name)"
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return show?.show?.episodes.filter{ $0.season == section + 1 }.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return show?.show?.episodes.unique{ $0.season }.count ?? 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Season \(section + 1)"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EpisodeDetailViewController") as? EpisodeDetailViewController {
            let episode = show?.show?.episodes.filter({ $0.season == indexPath.section + 1 })[indexPath.row]
            vc.episode = episode
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
