//
//  MoreInfoViewController.swift
//  AniMate
//
//  Created by Кирилл Щёлоков on 11.07.2023.
//

import UIKit

class MoreInfoViewController: UIViewController {
    
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var genreLable: UILabel!
    @IBOutlet weak var episodesCountLable: UILabel!
    @IBOutlet weak var episodeDurationLable: UILabel!
    @IBOutlet weak var totalDurationLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var nextReleaseLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    let notFoundCoverImageLink : String = "https://celes.club/uploads/posts/2022-10/thumbs/1667231105_42-celes-club-p-chernvi-fon-vkontakte-43.jpg"
    
    var anime: Anime? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    private func setUp(){

        makeLabelFlex(label: summaryLabel)
        makeLabelFlex(label: nameLable)
        
        setUpCoverImage()
        
        let name: String = anime!.attributes.titles.en ?? anime!.attributes.titles.en_jp ?? anime!.attributes.canonicalTitle
        nameLable.text = name
        
        genreLable.text = "Genre:\t\t\t\t\t\(anime!.type)"
        
        setUpEpisodesNumberLabel()
        setUpEpisodeDurationLabel()
        setUpTotalDurationLabel()
        setUpStartDateLabel()
        setUpEndDateLabel()
        setUpNextReleaseLabel()
    }
    
    private func setUpCoverImage(){
        guard let url = URL(string: (((anime!.attributes.coverImage?.original ?? anime!.attributes.coverImage?.tiny) ?? anime!.attributes.coverImage?.small) ?? notFoundCoverImageLink)) else { return }
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
                self.coverImageView.image = image
            }
        }
        task.resume()
    }
    
    private func makeLabelFlex(label: UILabel){
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        let font = UIFont.appLato!
        let scaledFont = fontMetrics.scaledFont(for: font)
        
        label.font = scaledFont
        label.adjustsFontForContentSizeCategory = true
    }
    
    private func setUpEpisodesNumberLabel(){
        if let episodesNumber = anime!.attributes.episodeCount {
            episodesCountLable.text = "Episodes Count:\t\t\t\t\(episodesNumber)"
        }else if let episodesNumber = anime!.attributes.chapterCount{
            episodesCountLable.text = "Chapters Count:\t\t\t\t\(episodesNumber)"
        } else {
            episodesCountLable.text = "Episodes Count:\t\t\t\t---"
        }
    }
    
    private func setUpEpisodeDurationLabel(){
        if let episodesDuration = anime!.attributes.episodeLength {
            episodeDurationLable.text = "Episode Length:\t\t\t\(episodesDuration) min"
        }else if let episodesDuration = anime!.attributes.volumeCount{
            episodeDurationLable.text = "Volume Count:\t\t\(episodesDuration) volumes  "
        } else {
            episodeDurationLable.text = "Episode Length:\t\t\t\t---"
        }
    }
    
    private func setUpTotalDurationLabel(){
        if let totalDuration = anime!.attributes.totalLength {
            totalDurationLabel.text = "Total Length:\t\t\t\t\(totalDuration) min"
        }else{
            totalDurationLabel.text = "Total Length:\t\t\t\t\t---"
        }
    }
    
    private func setUpStartDateLabel(){
        if let startDate = anime!.attributes.startDate{
            startDateLabel.text = "Start Date:\t\t\t\(startDate)"
        } else {
            startDateLabel.text = "Start Date:\t\t\t\t\t---"
        }
    }
    
    private func setUpNextReleaseLabel(){
        if let nextRelease = anime!.attributes.nextRelease{
            nextReleaseLabel.text = "Next Release:\t\t\(nextRelease)"
        } else {
            nextReleaseLabel.text = "Next Release:\t\t\t\t---"
        }
    }
    
    private func setUpEndDateLabel(){
        if let endDate = anime!.attributes.endDate{
            endDateLabel.text = "End Date:\t\t\t\(endDate)"
        } else {
            endDateLabel.text = "End Date:\t\t\t\t\t---"
        }
    }
}
