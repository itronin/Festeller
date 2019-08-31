//
//  ProductsVC.swift
//  Festeller
//
//  Created by Igor Tro on 24/08/2019.
//  Copyright © 2019 Igor Tro. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class ProductsVC: UIViewController {

    // Outlets
    @IBOutlet weak var productsTableView: UITableView!
    
    // Variables
    var products = [Product]()
    var category: Category!
    var selecredProduct: Product!
    var listener: ListenerRegistration!
    var db: Firestore!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        productsTableView.delegate = self
        productsTableView.dataSource = self
        productsTableView.register(UINib(nibName: Identifiers.ProductCell, bundle: nil), forCellReuseIdentifier: Identifiers.ProductCell)
        
        setProductsListener()
    }
    
    func setProductsListener() {
            listener = db.products(category: category.id).addSnapshotListener({ (snap, error) in
                if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let product = Product.init(data: data)

                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, product: product)
                case .modified:
                    self.onDocumentModified(change: change, product: product)
                case .removed:
                    self.onDocumentRemoved(change: change)
                }
            })
        })
    }
}



extension ProductsVC: UITableViewDelegate, UITableViewDataSource {
    
    func onDocumentAdded(change: DocumentChange, product: Product) {
        let newIndex = Int(change.newIndex)
        products.insert(product, at: newIndex)
        productsTableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .fade)
    }

    func onDocumentModified(change: DocumentChange, product: Product) {
        if change.newIndex == change.oldIndex{
            // Item changed but remained at the same position
            let index = Int(change.newIndex)
            products[index] = product
            productsTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        } else {
            // Item changed and changed position
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            products.remove(at: oldIndex)
            products.insert(product, at: newIndex)

            productsTableView.moveRow(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
        }
    }

    func onDocumentRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        products.remove(at: oldIndex)
        productsTableView.deleteRows(at: [IndexPath(row: oldIndex, section: 0)], with: .left)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ProductCell, for: indexPath) as? ProductCell {
            cell.configureCell(product: products[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProductDetailVC()
        let selectedProduct = products[indexPath.row]
        vc.product = selectedProduct
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
