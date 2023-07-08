//
//  APIModels.swift
//  AniMate
//
//  Created by Кирилл Щёлоков on 06.07.2023.
//

import Foundation

struct AnimeData: Codable {
    let data: [Anime]
    
    init(data: [Anime]){
        self.data = data
    }
}

struct Anime: Codable{
    let id: String
    let type: String
    let attributes: Attributes
}

struct Attributes: Codable {
    let createdAt: String
    let slug: String
    let description: String
    let titles: Titles
    let startDate: String
    let endDate: String?
    let nextRelease: String?
    let posterImage: PosterImage
    let episodeCount: Int?
    let episodeLength: Int?
    let totalLength: Int?
    let showType: String
    let nsfw: Bool
}

struct PosterImage: Codable {
            let tiny: String
            let small: String
}

struct Titles: Codable {
    let en: String?
    let en_jp: String?
}
