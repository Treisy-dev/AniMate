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
    
    public func getWordInfo(for word: String, completion: @escaping (Result<[Anime], Error>) -> Void)  {
        makeRequest(with: word) { result in
            switch result {
            case .success(let words):
                completion(.success(words))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    private func makeRequest(with word: String,  completion: @escaping (Result<[Anime], Error>) -> Void) {
        AF.request(makeUrl(word: word), method: .get).responseData { response in
            switch response.result {
            case .success(let word):
                do{
                    let result = try JSONDecoder().decode([Anime].self, from: word)
                    completion(.success(result))
                } catch let error{
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func makeUrl(word: String) -> String{
        return "https://kitsu.io/api/edge/anime?filter[text]=\(word)&page[limit]=5"
    }
}
