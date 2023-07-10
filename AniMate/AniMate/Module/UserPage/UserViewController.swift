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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackgroundColor
        
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.clipsToBounds = true

        userImageView.backgroundColor = UIColor.gray
        userImageView.layer.borderWidth = 1.0
        userImageView.layer.borderColor = UIColor.lightGray.cgColor

        if userImageView.image == nil {
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
    }
    
    @objc func imageViewTapped(_ sender: UITapGestureRecognizer) {
        if userImageView.image != nil {
            let alertController = UIAlertController(title: nil, message: "Выберите действие", preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] (_) in
                self?.removeImage()
            }
            
            let changeAction = UIAlertAction(title: "Изменить", style: .default) { [weak self] (_) in
                self?.pickImageFromGallery()
            }
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            
            alertController.addAction(deleteAction)
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
    
    func pickImageFromGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func removeImage() {
        userImageView.image = nil
        userImageView.contentMode = .center
        userImageView.image = UIImage(systemName: "person")
        userImageView.tintColor = .systemGray4
    }
}

extension UserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            userImageView.image = pickedImage
            userImageView.contentMode = .scaleAspectFill
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
