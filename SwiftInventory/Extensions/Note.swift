//
//  Note.swift
//  SwiftInventory
//
//  Created by Alvaro  on 14/07/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Note: Identifiable, Codable {
    @DocumentID var id: String?
    
    var note: String
    var timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case note
        case timestamp
    }
}
