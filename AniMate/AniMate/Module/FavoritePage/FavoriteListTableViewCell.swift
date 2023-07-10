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
    
    let unLikedImage = UIImage(named: "UnLikedIcon")
    let likedImage = UIImage(named: "LikedIcon")
    
    let userDefaults = UserDefaults.standard
    
    var animeList: AnimeData = AnimeData(data: [])
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        moreButton.layer.cornerRadius = 18
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
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
}
