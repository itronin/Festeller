//
//  AddEditProductsVC.swift
//  FestellerAdm
//
//  Created by Igor Tro on 19/09/2019.
//  Copyright © 2019 Igor Tro. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditProductsVC: UIViewController {

    // Outlets
    @IBOutlet weak var productNameTxt: UITextField!
    @IBOutlet weak var productPriceTxt: UITextField!
    @IBOutlet weak var productDescTxt: UITextView!
    @IBOutlet weak var productImgView: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addBtn: RoundedButton!
    
    // Variables
    var selectedCategory : Category!
    var productToEdit : Product?
    
    var name = ""
    var price = 0.0
    var productDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped(_:)))
        tap.numberOfTapsRequired = 1
        productImgView.isUserInteractionEnabled = true
        productImgView.addGestureRecognizer(tap)
        
        // If we are editing
        if let product = productToEdit {
            productNameTxt.text = product.name
            productDescTxt.text = product.productDescription
            productPriceTxt.text = String(product.price)
            addBtn.setTitle("Save changes", for: .normal)
            
            if let url = URL(string: product.imgURL) {
                productImgView.contentMode = .scaleAspectFit
                productImgView.kf.setImage(with: url)
            }
        }
    }

    @objc func imgTapped (_ tap: UITapGestureRecognizer) {
        launchImgPicker()
    }
    
    @IBAction func addPressed(_ sender: Any) {
        uploadImgThenDocument()
    }
    
    func uploadImgThenDocument() {
        guard let image = productImgView.image,
        let productName = productNameTxt.text, productName.isNotEmpty,
        let productDescription = productDescTxt.text, productDescription.isNotEmpty,
        let productPriceString = productPriceTxt.text,
            let productPrice = Double(productPriceString)
            else {
                simpleAlert(title: "Missing Fields", msg: "Please fill out all required fields")
                return
        }
        
        self.name = productName
        self.productDescription = productDescription
        self.price = productPrice
        
        
        activityIndicator.startAnimating()
        
        // Step 1: Turn image into Data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        // Step 2: Create a storage image reference -> A location in Firestorage for it to be stored.
        let imageRef = Storage.storage().reference().child("/productImages/\(productName).jpg")
        
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
                
                // Step 6: Upload a new Product document to the Firestore products collection
                self.uploadDocument(url: url.absoluteString)
            })
        }
    }
    
    func uploadDocument(url: String) {
        var docRef: DocumentReference!
        var product = Product.init(name: name,
                                   id: "",
                                   category: selectedCategory.id,
                                   price: price,
                                   productDescription: productDescription,
                                   imgURL: url
                                   )
        
        if let productToEdit = productToEdit {
            // We are editing a product
            docRef = Firestore.firestore().collection("products").document(productToEdit.id)
            product.id = productToEdit.id
        } else {
            // We are adding a new product
            docRef = Firestore.firestore().collection("products").document()
            product.id = docRef.documentID
        }
        
        let data = Product.modelToData(product: product)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload new product to Firestore")
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

extension AddEditProductsVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImgPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {return}
        productImgView.contentMode = .scaleAspectFill
        productImgView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
