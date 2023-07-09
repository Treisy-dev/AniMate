//
//  NetworkService.swift
//  AniMate
//
//  Created by Кирилл Щёлоков on 06.07.2023.
//

import Foundation
import Alamofire

final class NetworkService{
    
    static let shared = NetworkService()
        
    private init() {}
    
    // MARK: - Get Information
    
    public func getAnimeInfo(for word: String, completion: @escaping (Result<AnimeData, Error>) -> Void) {
            search(for: word, using: makeAnimeRequest, completion: completion)
    }
    
    public func getTopAnimeInfo(completion: @escaping (Result<AnimeData, Error>) -> Void) {
        searchTop(using: makeTopAnimeRequest, completion: completion)
    }
    
    public func getTopMangaInfo(completion: @escaping (Result<AnimeData, Error>) -> Void) {
        searchTop(using: makeTopMangaRequest, completion: completion)
    }
    
    public func getMangaInfo(for word: String, completion: @escaping (Result<AnimeData, Error>) -> Void) {
        search(for: word, using: makeMangaRequest, completion: completion)
    }
    
    private func search(for word: String,
                        using apiMethod: @escaping (String, @escaping (Result<AnimeData, Error>) -> Void) -> Void,
                        completion: @escaping (Result<AnimeData, Error>) -> Void) {
        apiMethod(word) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func searchTop(using apiMethod: @escaping (@escaping (Result<AnimeData, Error>) -> Void) -> Void,
                           completion: @escaping (Result<AnimeData, Error>) -> Void) {
        apiMethod() { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - Requests
    
    private func makeAnimeRequest(with word: String, completion: @escaping (Result<AnimeData, Error>) -> Void) {
        makeRequest(url: getAnimeUrl(name: word), completion: completion)
    }
    
    private func makeTopAnimeRequest(completion: @escaping (Result<AnimeData, Error>) -> Void) {
        makeRequest(url: getTopAnimeUrl(), completion: completion)
    }
    
    private func makeTopMangaRequest(completion: @escaping (Result<AnimeData, Error>) -> Void) {
        makeRequest(url: getTopMangaUrl(), completion: completion)
    }
    
    private func makeMangaRequest(with word: String, completion: @escaping (Result<AnimeData, Error>) -> Void) {
        makeRequest(url: getMangaUrl(name: word), completion: completion)
    }
    
    private func makeRequest(url: String, completion: @escaping (Result<AnimeData, Error>) -> Void) {
        AF.request(url, method: .get).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(AnimeData.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - URLs
    
    private func getAnimeUrl(name: String) -> String{
        return "https://kitsu.io/api/edge/anime?filter[text]=\(name)&page[limit]=10"
    }
    
    private func getTopAnimeUrl() -> String{
        return "https://kitsu.io/api/edge/anime?page[limit]=10&sort=-userCount"
    }
    
    private func getMangaUrl(name: String) -> String{
        return "https://kitsu.io/api/edge/manga?filter[text]=\(name)&page[limit]=10"
    }
    
    private func getTopMangaUrl() -> String{
        return "https://kitsu.io/api/edge/manga?page[limit]=10&sort=-userCount"
    }

}
