//
//  FavoriteViewController.swift
//  AniMate
//
//  Created by Кирилл Щёлоков on 06.07.2023.
//

import UIKit

class FavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var anime: AnimeData = AnimeData(data: [])
    var favoriteAnimeArray: [Anime] = []
    let likedImage = UIImage(named: "LikedIcon")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Извлекаем данные из UserDefaults
        if let data = UserDefaults.standard.data(forKey: "favoriteArrayKey"),
           let decodedArray = try? PropertyListDecoder().decode([Anime].self, from: data) {
            favoriteAnimeArray = decodedArray
        }
        
        tableView.reloadData()
    }
    
    @objc func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteAnimeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteListTableViewCell", for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setUp(favoriteAnimeArray[indexPath.row], anime)
        
        return cell
    }
    
    private func checkFavorite() {
        for (index, anime) in anime.data.enumerated() {
            if favoriteAnimeArray.contains(where: { $0.id == anime.id }) {
                let indexPath = IndexPath(row: index, section: 0)
                if let cell = tableView.cellForRow(at: indexPath) as? ListTableViewCell {
                    cell.likeButton.setImage(likedImage, for: .normal)
                }
            }
        }
    }
}
