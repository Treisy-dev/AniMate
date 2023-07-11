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
        
        addLabelIfNeeded()
    }
    
    private func addLabelIfNeeded() {
        if favoriteAnimeArray.isEmpty {
            let label = UILabel(frame: CGRect(x: 0, y: 150, width: view.bounds.width, height: 30))
            label.textAlignment = .center
            label.text = "No favorite anime found"
            label.textColor = UIColor.white
            label.font = label.font.withSize(30)
            label.tag = 123
            view.addSubview(label)
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
        
        cell.setUp(favoriteAnimeArray[indexPath.row], tableView, self) 
        return cell
    }
    
    func updateTavleView(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateLabelVisibility()
        }
    }
    
    func updateLabelVisibility() {
        if favoriteAnimeArray.isEmpty {
            showNoFavoriteAnimeLabel()
        } else {
            hideNoFavoriteAnimeLabel()
        }
    }

    func showNoFavoriteAnimeLabel() {
        if let label = view.viewWithTag(123) as? UILabel {
            label.isHidden = false
        } else {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 30))
            label.textAlignment = .center
            label.text = "No favorite anime found."
            label.tag = 123 // Assign a tag to the label
            view.addSubview(label)
        }
    }

    func hideNoFavoriteAnimeLabel() {
        if let label = view.viewWithTag(123) as? UILabel {
            label.isHidden = true
        }
    }

}
