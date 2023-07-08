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
    @IBOutlet weak var readButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    let unLikedImage = UIImage(named: "UnLikedIcon")
    let likedImage = UIImage(named: "LikedIcon")
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        readButton.layer.cornerRadius = 18
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLable.text = nil
        pictureImageView.image = nil
        
    }
    
    func setUp(_ data: Anime){
        let name: String = data.attributes.titles.en ?? data.attributes.titles.en_jp ?? data.attributes.slug
        nameLable.text = name
        readButton.layer.cornerRadius = 9
        readButton.layer.borderWidth = 1
        readButton.layer.borderColor = UIColor.appYellowColor?.cgColor
        guard let url = URL(string: data.attributes.posterImage.tiny) else { return }
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
        if likeButton.image(for: .normal) == unLikedImage{
            likeButton.setImage(likedImage, for: .normal)
        } else {
            likeButton.setImage(unLikedImage, for: .normal)
        }
    }
}
