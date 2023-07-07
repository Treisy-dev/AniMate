//
//  APIModels.swift
//  AniMate
//
//  Created by Кирилл Щёлоков on 06.07.2023.
//

import Foundation

struct Anime: Codable {
    let id: String
    let type: String
    //let links: Links
    let attributes: Attributes
    //let relationships: Relationships
    
    /*struct Links: Codable {
        let selfLink: String
        
        enum CodingKeys: String, CodingKey {
            case selfLink = "self"
        }
    }*/
    
    struct Attributes: Codable {
        //let createdAt: String
        //let updatedAt: String
        let slug: String
        //let synopsis: String
        let description: String
        //let coverImageTopOffset: Int
        //let titles: Titles
        //let canonicalTitle: String
        //let abbreviatedTitles: [String]
        let averageRating: String
        //let ratingFrequencies: [String: String]
        //let userCount: Int
        //let favoritesCount: Int
        let startDate: String
        let endDate: String?
        //let nextRelease: String?
        //let popularityRank: Int
        //let ratingRank: Int
        //let ageRating: String
        let ageRatingGuide: String
        //let subtype: String
        let status: String
        //let tba: String?
        let posterImage: PosterImage
        //let coverImage: CoverImage
        let episodeCount: Int?
        let episodeLength: Int?
        let totalLength: Int?
        let youtubeVideoId: String?  //youtube trailer link
        //let showType: String
        //let nsfw: Bool
        
        /*struct Titles: Codable {
            let en: String
            let en_jp: String
            let ja_jp: String
        }*/
        
        struct PosterImage: Codable {
            let tiny: String
            //let large: String
            let small: String
            //let medium: String
            //let original: String
            //let meta: Meta
            
            /*struct Meta: Codable {
                let dimensions: [String: Dimension]
                
                struct Dimension: Codable {
                    let width: Int
                    let height: Int
                }
            }*/
        }
        
        /*struct CoverImage: Codable {
            let tiny: String
            let large: String
            let small: String
            let original: String
            let meta: Meta
            
            struct Meta: Codable {
                let dimensions: [String: Dimension]
                
                struct Dimension: Codable {
                    let width: Int
                    let height: Int
                }
            }
        }*/
    }
    
    /*struct Relationships: Codable {
        //let genres: Relationship
        //let categories: Relationship
        //let castings: Relationship
        //let installments: Relationship
        //let mappings: Relationship
        //let reviews: Relationship
        //let mediaRelationships: Relationship
        //let characters: Relationship
        //let staff: Relationship
        //let productions: Relationship
        let quotes: Relationship
        let episodes: Relationship
        let streamingLinks: Relationship
        let animeProductions: Relationship
        let animeCharacters: Relationship
        let animeStaff: Relationship
        
        struct Relationship: Codable {
            let links: Links
            
            struct Links: Codable {
                let selfLink: String
                let related: String
                
                enum CodingKeys: String, CodingKey {
                    case selfLink = "self"
                    case related
                }
            }
        }
    }*/
}
