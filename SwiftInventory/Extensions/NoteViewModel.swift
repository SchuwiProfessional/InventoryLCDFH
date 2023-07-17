//
//  NoteViewModel.swift
//  SwiftInventory
//
//  Created by Alvaro  on 14/07/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class NoteViewModel: ObservableObject {
    @Published var notes = [Note]()
    private let db = Firestore.firestore()
    
    func addNote(_ note: Note) {
        do {
            let _ = try db.collection("notes").addDocument(from: note)
        } catch {
            print("Error adding note: \(error)")
        }
    }
    
    func fetchNotes() {
        db.collection("notes").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching notes: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.notes = documents.compactMap { document in
                try? document.data(as: Note.self)
            }
        }
    }
}

