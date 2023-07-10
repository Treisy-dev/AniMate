//
//  FavoriteViewController.swift
//  AniMate
//
//  Created by Кирилл Щёлоков on 06.07.2023.
//

import UIKit

class FavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var favoriteAnimeArray: [Anime] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        if let data = UserDefaults.standard.data(forKey: "favoriteArrayKey"),
           let decodedArray = try? PropertyListDecoder().decode([Anime].self, from: data) {
            favoriteAnimeArray = decodedArray
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let data = UserDefaults.standard.data(forKey: "favoriteArrayKey"),
           let decodedArray = try? PropertyListDecoder().decode([Anime].self, from: data) {
            favoriteAnimeArray = decodedArray
        }
        updateTavleView()
    }
    
    @objc func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteAnimeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteListTableViewCell", for: indexPath) as? FavoriteListTableViewCell else { return UITableViewCell() }
        
        cell.setUp(favoriteAnimeArray[indexPath.row], tableView) 
        return cell
    }
    
    private func updateTavleView(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
