//
//  FavoriteListTableViewCell.swift
//  AniMate
//
//  Created by Данил Клементьев on 10.07.2023.
//

import UIKit

final class FavoriteListTableViewCell: UITableViewCell{
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    var favoriteVC: UIViewController = FavoriteViewController()

    
    let unLikedImage = UIImage(named: "UnLikedIcon")
    let likedImage = UIImage(named: "LikedIcon")
    var tableView : UITableView = UITableView()
    let userDefaults = UserDefaults.standard
    
    var anime: Anime? = nil
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        moreButton.layer.cornerRadius = 18
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    func setUp(_ data: Anime, _ tableView : UITableView, _ VC: UIViewController){
        favoriteVC = VC
        self.anime = data
        self.tableView = tableView
        let name: String = data.attributes.titles.en ?? data.attributes.titles.en_jp ?? data.attributes.canonicalTitle
        nameLable.text = name
        moreButton.layer.cornerRadius = 9
        moreButton.layer.borderWidth = 1
        moreButton.layer.borderColor = UIColor.appYellowColor?.cgColor
        likeButton.setImage(likedImage, for: .normal) //
        
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
            addToUserDefaults(indexPath: indexPath!, key: "favoriteArrayKey")
            likeButton.setImage(likedImage, for: .normal)
        } else {
            deleteFromUserDefaults(indexPath: indexPath!, key: "favoriteArrayKey")
            likeButton.setImage(unLikedImage, for: .normal)
        }
    }
    
    @IBAction func moreButtonAction(_ sender: Any) {
        let indexPath = getIndexPath()
        
        let storyboard = UIStoryboard(name: "MoreInfoPage", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MoreInfoViewController") as! MoreInfoViewController
        viewController.anime = anime
        favoriteVC.present(viewController, animated: true)
        
        addToUserDefaults(indexPath: indexPath!, key: "showedRecentlyKey")
        clearExtraElementsInUD(key: "showedRecentlyKey", id: anime!.id)
    }
    
    private func getIndexPath() -> IndexPath? {
            guard let tableView = superview as? UITableView else {
                return nil
            }
            return tableView.indexPath(for: self)
        }
    
    private func deleteFromUserDefaults(indexPath : IndexPath, key: String){
        if let data = userDefaults.value(forKey: key) as? Data,
            var favoriteAnimeArray = try? PropertyListDecoder().decode([Anime].self, from: data) {
            favoriteAnimeArray.remove(at: indexPath.row)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(favoriteAnimeArray), forKey: key)
        }
    }
    
    private func addToUserDefaults(indexPath : IndexPath, key: String){
        if let data = userDefaults.value(forKey: key) as? Data,
            var favoriteAnimeArray = try? PropertyListDecoder().decode([Anime].self, from: data) {
            favoriteAnimeArray.append(favoriteAnimeArray[indexPath.row])
            UserDefaults.standard.set(try? PropertyListEncoder().encode(favoriteAnimeArray), forKey: key)
        }
    }
    
    private func clearExtraElementsInUD(key:String, id: String){
        if let data = userDefaults.value(forKey: key) as? Data,
           var showedRecentlyArray = try? PropertyListDecoder().decode([Anime].self, from: data) {
            if showedRecentlyArray.count > 15 {
                showedRecentlyArray.remove(at: 0)
            }
            for i in 0..<showedRecentlyArray.count-1{
                if showedRecentlyArray[i].id == id {
                    showedRecentlyArray.remove(at: i)
                    break
                }
            }
            UserDefaults.standard.set(try? PropertyListEncoder().encode(showedRecentlyArray), forKey: key)
        }
    }
}
