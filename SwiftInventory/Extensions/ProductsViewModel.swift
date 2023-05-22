//
//  ProductsViewModel.swift
//  SwiftInventory
//
//  Created by Alvaro  on 18/05/23.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class ProductsViewModel: ObservableObject {
    
    @Published var products = [Product]()
    @Published var outOfStockProducts = [Product]()

    
    private var db = Firestore.firestore().collection("products")
    private var listenerRegistration: ListenerRegistration?
    
    deinit {
        unsubscribe()
    }
    
    func unsubscribe() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    
    func subscribe() {
        if listenerRegistration == nil {
            listenerRegistration = db.addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.products = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Product.self)
                }
                
                self.outOfStockProducts = self.products.filter { $0.amount < 5 }
            }
        }
    }

    
    func removeProducts(atOffsets indexSet: IndexSet) {
        let products = indexSet.lazy.map { self.products[$0] }
        products.forEach { product in
            if let documentId = product.id {
                db.document(documentId).delete {error in
                    if let error = error {
                        print("Unable to remove document: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
