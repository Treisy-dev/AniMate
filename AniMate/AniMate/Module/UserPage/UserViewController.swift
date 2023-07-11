//
//  UserViewController.swift
//  AniMate
//
//  Created by Кирилл Щёлоков on 06.07.2023.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var countFavoritesLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var favoriteAnimeArray: [Anime] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesLabel.layer.cornerRadius = 10
        favoritesLabel.layer.masksToBounds = true
        
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.clipsToBounds = true
        userImageView.backgroundColor = UIColor.gray
        userImageView.layer.borderWidth = 1.0
        userImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        if let imageData = UserDefaults.standard.data(forKey: "userImage"),
           let image = UIImage(data: imageData) {
            userImageView.image = image
            userImageView.contentMode = .scaleAspectFill
        } else {
            userImageView.contentMode = .center
            userImageView.image = UIImage(systemName: "person")
            userImageView.tintColor = .systemGray4
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        userImageView.addGestureRecognizer(tapGesture)
        userImageView.isUserInteractionEnabled = true
        
        editButton.layer.cornerRadius = editButton.frame.size.width / 2
        editButton.clipsToBounds = true
        
        usernameTextField.isEnabled = false
        usernameTextField.text = UserDefaults.standard.string(forKey: "username")
        usernameTextField.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 110, height: 180)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FavoriteAnimeCell.self, forCellWithReuseIdentifier: "FavoriteAnimeCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let data = UserDefaults.standard.data(forKey: "favoriteArrayKey"),
           let decodedArray = try? PropertyListDecoder().decode([Anime].self, from: data) {
            favoriteAnimeArray = decodedArray
        }
        
        countFavoritesLabel.text = "\(favoriteAnimeArray.count)"
        collectionView.reloadData()
    }
    
    @objc func imageViewTapped(_ sender: UITapGestureRecognizer) {
        textFieldDidEndEditing(usernameTextField)
        
        if userImageView.image != nil {
            let alertController = UIAlertController(title: nil, message: "Выберите действие", preferredStyle: .actionSheet)
            
            if userImageView.image != UIImage(systemName: "person") {
                let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] (_) in
                    self?.removeImage()
                }
                alertController.addAction(deleteAction)
            }
            
            let changeAction = UIAlertAction(title: "Изменить", style: .default) { [weak self] (_) in
                self?.pickImageFromGallery()
            }
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            
            alertController.addAction(changeAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            pickImageFromGallery()
        }
    }
    
    @IBAction func editButtonIsPressed(_ sender: Any) {
        usernameTextField.isEnabled = true
        usernameTextField.becomeFirstResponder()
    }
    
    private func pickImageFromGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func removeImage() {
        userImageView.image = nil
        userImageView.contentMode = .center
        userImageView.image = UIImage(systemName: "person")
        userImageView.tintColor = .systemGray4
        
        UserDefaults.standard.removeObject(forKey: "userImage")
    }
    
    private func saveImageToUserDefaults(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            UserDefaults.standard.set(imageData, forKey: "userImage")
        }
    }
    
    private func saveUsernameToUserDefaults(username: String?) {
        UserDefaults.standard.set(username, forKey: "username")
    }
}

extension UserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            userImageView.image = pickedImage
            userImageView.contentMode = .scaleAspectFill
            saveImageToUserDefaults(image: pickedImage)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        usernameTextField.isEnabled = false
        saveUsernameToUserDefaults(username: textField.text)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text, text.hasPrefix("@") {
            let formattedText = String(text.dropFirst())
            textField.text = formattedText
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()

        if let username = textField.text {
            if !username.hasPrefix("@") && !username.isEmpty {
                let formattedUsername = "@\(username)"
                textField.text = formattedUsername
            }
            usernameTextField.isEnabled = false
            saveUsernameToUserDefaults(username: textField.text)
        }
    }
}

extension UserViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteAnimeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteAnimeCell", for: indexPath) as! FavoriteAnimeCell
        
        let anime = favoriteAnimeArray[indexPath.item]
        cell.setUp(anime)
        
        return cell
    }
}

class FavoriteAnimeCell: UICollectionViewCell {
    let animeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupImageView()
    }
    
    private func setupImageView() {
        contentView.addSubview(animeImageView)
        animeImageView.layer.cornerRadius = 10
        animeImageView.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            animeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            animeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            animeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            animeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func setUp(_ data: Anime) {
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
                self.animeImageView.image = image
            }
        }
        task.resume()
    }
}
