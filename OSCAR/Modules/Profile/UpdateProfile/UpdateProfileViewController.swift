//
//  UpdateProfileViewController.swift
//  OSCAR
//
//  Created by Asmaa Tarek on 07/07/2021.
//

import UIKit

class UpdateProfileViewController: BaseViewController {
    // o first name 1 last name 2 mobile 3 email 4 password
    
    @IBOutlet private var textFieldsArray: [GeneralTextField]!
    @IBOutlet private weak var profileImage: CircleImageView!
    @IBOutlet weak var cameraImageView: UIImageView!
    
    private var profileImageData: Data?
    let viewModel = ProfileViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
    }
    
    @IBAction private func backAction(_ sender: UIButton) {
        pop()
    }
    
    @IBAction func deleteAccountTapped(_ sender: BackGroundButton) {
        push(DeleteAccountConfirmationVC())
    }
    @IBAction private func saveAction(_ sender: BackGroundButton) {
        dismissKeyBoard()
        let name = (textFieldsArray[0].text ?? "") + " " + (textFieldsArray[1].text ?? "")
        let updateProfileParameters = UpdateProfileParameters(image: profileImageData,
                                                              name: name,
                                                              email: textFieldsArray[3].text)
        viewModel.updateProfile(with: updateProfileParameters)
    }
}

fileprivate extension UpdateProfileViewController {
    
    func setupViewModel() {
        setupViewModel(viewModel: viewModel)
        
        viewModel.updateProfileCompletion = { [weak self] message in
            self?.showAlert(message: message)
        }
    }
    
    func setupView() {
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImagePickerTypeAlert)))
        //o first name 1 last name 2 mobile 3 email 4 password
        guard let user = CurrentUser.shared.user else { return }
        let nameExploded = user.name?.split(separator: " ")
        textFieldsArray[0].text = nameExploded?.first?.description
        textFieldsArray[1].text = nameExploded?.last?.description
        textFieldsArray[2].text = user.phone
        textFieldsArray[3].text = user.email
        profileImage.setImage(with: user.image ?? "")
    }
    
    @objc func showImagePickerTypeAlert() {
        let alert = UIAlertController(title: "", message: "choose_source_type".localized, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "camera".localized, style: .default) {[weak self] _ in
            self?.openImagePicker(isCamera: true)
        }
        
        let photoAction = UIAlertAction(title: "photo".localized, style: .default) {[weak self] _ in
            self?.openImagePicker(isCamera: false)
        }
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .default, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @objc func openImagePicker(isCamera: Bool) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = isCamera ? .camera : .photoLibrary
        present(imagePicker, animated: true)
    }
}

extension UpdateProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        profileImage.image = selectedImage
        cameraImageView.isHidden = true
        profileImageData = selectedImage.jpegData(compressionQuality: 0.5)
        picker.dismiss()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss()
    }
}



