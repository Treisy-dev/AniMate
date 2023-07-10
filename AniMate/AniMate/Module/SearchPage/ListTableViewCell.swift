//
//  ListTableViewCell.swift
//  AniMate
//
//  Created by Кирилл Щёлоков on 07.07.2023.
//

import UIKit

final class ListTableViewCell : UITableViewCell {
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    let unLikedImage = UIImage(named: "UnLikedIcon")
    let likedImage = UIImage(named: "LikedIcon")
        
    let userDefaults = UserDefaults.standard
    let favoriteArrayKey = "favoriteArrayKey"

    
    var animeList: AnimeData = AnimeData(data: [])
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        moreButton.layer.cornerRadius = 18
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLable.text = nil
        pictureImageView.image = nil
        
    }
    
    func setUp(_ data: Anime, _ animeData: AnimeData){
        animeList = animeData
        let name: String = data.attributes.titles.en ?? data.attributes.titles.en_jp ?? data.attributes.canonicalTitle
        nameLable.text = name
        moreButton.layer.cornerRadius = 9
        moreButton.layer.borderWidth = 1
        moreButton.layer.borderColor = UIColor.appYellowColor?.cgColor
        likeButton.setImage(unLikedImage, for: .normal)
    
        guard let url = URL(string: (data.attributes.posterImage.tiny ?? data.attributes.posterImage.small) ?? data.attributes.posterImage.original) else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Invalid image data")
                return
            }
            
            DispatchQueue.main.async {
                self.pictureImageView.image = image
            }
        }
        task.resume()
    }
    
    
    @IBAction func likeButtonAction(_ sender: Any) {
        let indexPath = getIndexPath()

        if likeButton.image(for: .normal) == unLikedImage {
            addToUserDefaults(indexPath: indexPath!)
            likeButton.setImage(likedImage, for: .normal)
        } else {
            deleteFromUserDefaults(indexPath: indexPath!)
            likeButton.setImage(unLikedImage, for: .normal)
        }

        /*if let savedData = userDefaults.value(forKey: "favoriteArrayKey") as? Data,
            let savedAnimeArray = try? PropertyListDecoder().decode([Anime].self, from: savedData) {
            
            guard let domainName = Bundle.main.bundleIdentifier else {
                return
            }
            UserDefaults.standard.removePersistentDomain(forName: domainName)  // очищает userDefaults
            print(savedAnimeArray)
        }*/
    }
    
    private func getIndexPath() -> IndexPath? {
            guard let tableView = superview as? UITableView else {
                return nil
            }
            return tableView.indexPath(for: self)
        }
    
    private func deleteFromUserDefaults(indexPath : IndexPath){
        if let data = userDefaults.value(forKey: "favoriteArrayKey") as? Data,
            var favoriteAnimeArray = try? PropertyListDecoder().decode([Anime].self, from: data) {
            for (index, anime) in favoriteAnimeArray.enumerated(){
                if animeList.data[indexPath.row].id == anime.id{
                    let index = index
                    favoriteAnimeArray.remove(at: index)
                    UserDefaults.standard.set(favoriteAnimeArray, forKey: "favoriteArrayKey")
                    break
                }
            }
        }
    }
    
    private func addToUserDefaults(indexPath : IndexPath){
        if let data = userDefaults.value(forKey: "favoriteArrayKey") as? Data,
            var favoriteAnimeArray = try? PropertyListDecoder().decode([Anime].self, from: data) {
            favoriteAnimeArray.append(animeList.data[indexPath.row])
            userDefaults.set(try? PropertyListEncoder().encode(favoriteAnimeArray), forKey: "favoriteArrayKey")
        } else {
            var favoriteAnimeArray = [Anime]()
            favoriteAnimeArray.append(animeList.data[indexPath.row])
            userDefaults.set(try? PropertyListEncoder().encode(favoriteAnimeArray), forKey: "favoriteArrayKey")
        }
    }
}
