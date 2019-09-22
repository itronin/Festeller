//
//  AddEditCategoryVC.swift
//  FestellerAdm
//
//  Created by Igor Tro on 01/09/2019.
//  Copyright © 2019 Igor Tro. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditCategoryVC: UIViewController {

    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var categoryImg: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addBtn: UIButton!
    
    var categoryToEdit : Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped(_:)))
        tap.numberOfTapsRequired = 1
        categoryImg.isUserInteractionEnabled = true
        categoryImg.addGestureRecognizer(tap)
        
        // If we are editing, categoryToEdit will != nil
        if let category = categoryToEdit {
            nameTxt.text = category.name
            addBtn.setTitle("Save changes", for: .normal)
            
            if let url = URL(string: category.imgURL) {
                categoryImg.contentMode = .scaleAspectFit
                categoryImg.kf.setImage(with: url)
            }
        }
    }
    
    @objc func imgTapped (_ tap: UITapGestureRecognizer) {
        launchImgPicker()
    }
    
    @IBAction func addCategoryPressed(_ sender: Any) {
        uploadImgThenDocument()
    }
    
    func uploadImgThenDocument() {
        guard let image = categoryImg.image,
            let categoryName = nameTxt.text, categoryName.isNotEmpty
            else {
                simpleAlert(title: "Error", msg: "Please add category image and name")
                return
        }
        
        activityIndicator.startAnimating()
        
        // Step 1: Turn image into Data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        // Step 2: Create a storage image reference -> A location in Firestorage for it to be stored.
        let imageRef = Storage.storage().reference().child("/categoryImages/\(categoryName).jpg")
        
        // Step 3: Set the meta data
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        // Step 4: Upload the data
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload image!")
                return
            }
            
            // Step 5: Once the image is uploaded, retrieve the download URL
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    self.handleError(error: error, msg: "Unable retrieve image url!")
                    return
                }
                guard let url = url else { return }
                
                // Step 6: Upload a new Category document to the Firestore categories collection
                self.uploadDocument(url: url.absoluteString)
            })
        }
    }
    
    func uploadDocument(url: String) {
        var docRef: DocumentReference!
        var category = Category.init(name: nameTxt.text!,
                                     id: "",
                                     imgURL: url,
                                     timeStamp: Timestamp())
        if let categoryToEdit = categoryToEdit {
            // We are editing
            docRef = Firestore.firestore().collection("categories").document(categoryToEdit.id)
            category.id = categoryToEdit.id
        } else {
            // New category
            docRef = Firestore.firestore().collection("categories").document()
            category.id = docRef.documentID
        }
        
        let data = Category.modelToData(category: category)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
              self.handleError(error: error, msg: "Unable to upload new category to Firestore")
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func handleError(error: Error, msg: String) {
        debugPrint(error.localizedDescription)
        self.simpleAlert(title: "Error", msg: msg)
        self.activityIndicator.stopAnimating()
    }
    
}

extension AddEditCategoryVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImgPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {return}
        categoryImg.contentMode = .scaleAspectFill
        categoryImg.image = image
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
