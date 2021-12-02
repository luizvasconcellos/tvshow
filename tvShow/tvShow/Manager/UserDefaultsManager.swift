//
//  UserDefaultsManager.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 28/11/21.
//

import Foundation

private struct UserDefaultsKeys {
    static let Favorite = "Favorites"
}

class UserDefaultsManager {
    
    
    // MARK: - Properties
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    
    // MARK: - Public Functions
    func getUserFavoriteList() -> [Show] {
        do {
            let favoriteList  = try defaults.getObject(forKey: UserDefaultsKeys.Favorite, castTo: [Show].self)
            return favoriteList.sorted(by: { $0.show?.name ?? "" < $1.show?.name ?? "" })
        } catch {
            print(error.localizedDescription)
        }
        return []
    }

    func isFavorited(show: Show) -> Bool {
        return getUserFavoriteList().contains { $0.show?.id == show.show?.id }
    }

    func addToFavorite(show: Show) -> Bool {
        var favoriteList = getUserFavoriteList()
        favoriteList.append(show)
        do {
            try defaults.setObject(favoriteList, forKey: UserDefaultsKeys.Favorite)
            return true
        } catch {
            print (error.localizedDescription)
        }
        return false
    }

    func removeFromFavorite(show: Show) -> Bool {
        
        var favoriteList = getUserFavoriteList()
        guard let index = favoriteList.firstIndex( where: { $0.show?.id == show.show?.id } ) else  { return false }
        favoriteList.remove(at: index)
        do {
            try defaults.setObject(favoriteList, forKey: UserDefaultsKeys.Favorite)
            return true
        } catch {
            print (error.localizedDescription)
        }
        return false
    }
}
