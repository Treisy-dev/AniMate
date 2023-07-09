//
//  SearchViewController.swift
//  AniMate
//
//  Created by Кирилл Щёлоков on 06.07.2023.
//
import Foundation
import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var animeMangaSelector: UISegmentedControl!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var backgroundCloudImage: UIImageView!
    @IBOutlet weak var backgroundBoyImage: UIImageView!
    @IBOutlet weak var backgroundLable: UILabel!
    
    let likedImage = UIImage(named: "LikedIcon")

    
    let textFieldsAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.appYellowColor!
    ]
    
    var anime : AnimeData = AnimeData(data: [])
                
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTop(using: getTopAnime)
        
        nameTextField.delegate = self
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Поиск", attributes: textFieldsAttributes)
        
        listTableView.dataSource = self
        listTableView.delegate = self
    }

    // MARK: - Anime
    
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
    
    private func getTopAnime(completion: @escaping (Result<AnimeData, Error>) -> Void) {
        let nc = NetworkService.shared

        nc.getTopAnimeInfo() { result in
            switch result {
            case .success(let anime):
                completion(.success(anime))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Manga
    private func getManga(name: String, completion: @escaping (Result<AnimeData, Error>) -> Void) {
        let nc = NetworkService.shared

        nc.getMangaInfo(for: name) { result in
            switch result {
            case .success(let anime):
                completion(.success(anime))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func getTopManga(completion: @escaping (Result<AnimeData, Error>) -> Void) {
        let nc = NetworkService.shared

        nc.getTopMangaInfo() { result in
            switch result {
            case .success(let anime):
                completion(.success(anime))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        122
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return anime.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell") as? ListTableViewCell else {return UITableViewCell()}
        
        cell.setUp(anime.data[indexPath.row], anime)
        
        return cell
    }
    
    private func checkFavorite(){
        if let data = UserDefaults.standard.data(forKey: "favoriteArrayKey"),
              let favoriteAnimeArray = try? PropertyListDecoder().decode([Anime].self, from: data) {
            for i in favoriteAnimeArray{
                for (index, anime) in anime.data.enumerated(){
                    if i.id == anime.id {
                        let indexPath = IndexPath(row: index, section: 0)
                        if let cell = listTableView.cellForRow(at: indexPath) as? ListTableViewCell {
                            cell.likeButton.setImage(likedImage, for: .normal)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Search
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        SearchAaction(name: newText)
        return true
        }
    
    private func SearchAaction(name: String) {
        headerLabel.text = "Результаты поиска по запросу \(name)"
    
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if animeMangaSelector.selectedSegmentIndex == 0 {
            search(for: encodedName, using: getAnime)
        } else {
            search(for: encodedName, using: getManga)
        }
    }
    
    private func search(for name: String, using apiMethod: @escaping (String, @escaping (Result<AnimeData, Error>) -> Void) -> Void) {
            apiMethod(name) { result in
                switch result {
                case .success(let anime):
                    self.anime = anime
                    self.updateTavleView()
                case .failure(let error):
                    self.showErrorMessage()
                    print(error)
                }
            }
        }
    
    private func searchTop(using apiMethod: @escaping (@escaping (Result<AnimeData, Error>) -> Void) -> Void) {
            apiMethod() { result in
                switch result {
                case .success(let anime):
                    self.anime = anime
                    self.updateTavleView()
                case .failure(let error):
                    self.showErrorMessage()
                    print(error)
                }
            }
        }
    
    @IBAction func segmentDidChangeAction(_ sender: Any) {
        nameTextField.text = ""
        if animeMangaSelector.selectedSegmentIndex == 0 {
            searchTop(using: getTopAnime)
            headerLabel.text = "Top-10 Аниме:"
        } else {
            searchTop(using: getTopManga)
            headerLabel.text = "Top-10 Манги:"
        }
    }
    
    private func updateTavleView(){
        DispatchQueue.main.async {
            self.listTableView.reloadData()
            self.checkFavorite()
        }
    }
    
    private func showErrorMessage(){
        self.backgroundLable.text = "Что-то пошло не так...\n Проверьте подключение к интернету\n"
        self.listTableView.isHidden = true
        self.backgroundLable.isHidden = false
        self.backgroundBoyImage.isHidden = false
        self.backgroundCloudImage.isHidden = false
    }
    
    
    
}
    
