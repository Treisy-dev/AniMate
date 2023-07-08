//
//  SearchViewController.swift
//  AniMate
//
//  Created by Кирилл Щёлоков on 06.07.2023.
//
import Foundation
import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var TestTextField: UITextField!
    @IBOutlet weak var listTableView: UITableView!
    
    var anime : AnimeData = AnimeData(data: [])
                
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.dataSource = self
        listTableView.delegate = self
    }
    
    /*private func getAnime(name: String) {
        let nc = NetworkService.shared
        let semaphore = DispatchSemaphore(value: 0)

        nc.getAnimeInfo(for: name) { result in
            switch result {
            case .success(let anime):
                self.anime = anime
            case .failure(let error):
                print(error)
            }
            semaphore.signal()
        }

        semaphore.wait()
    }*/
    
    private func getAnime(name: String, completion: @escaping (Result<AnimeData, Error>) -> Void) {
        let nc = NetworkService.shared

        nc.getAnimeInfo(for: name) { result in
            switch result {
            case .success(let anime):
                completion(.success(anime))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        122
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return anime.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell") as? ListTableViewCell else {return UITableViewCell()}
        
        cell.setUp(anime.data[indexPath.row])
        
        return cell
    }
    
    
    @IBAction func searchButtonAction(_ sender: Any) {
        //getAnime(name: TestTextField.text ?? "11")
        getAnime(name: TestTextField.text ?? "11") { result in
            switch result {
            case .success(let anime):
                // Обработка полученных данных
                self.anime = anime
                DispatchQueue.main.async {
                    self.listTableView.reloadData()
                }
                //self.listTableView.reloadData()
            case .failure(let error):
                // Обработка ошибки
                print(error)
            }
        }
    }
    
    private func updateContent(data: Anime){
        DispatchQueue.main.async {
            
        }
    }
    
        
}
    
