//
//  Item.swift
//  Lumi
//
//  Created by AFP FED 025 on 30/10/2026.
//

//
//

//
//  Item.swift
//  Countries
//

import Foundation

struct Item: Identifiable {
    let id = UUID()
    var photo: String           // nome dell'immagine negli Assets
    var name: String            // nome del film / libro / canzone
    var author: String = ""     // regista / autore / artista
    var year: String = ""       // anno di uscita
    var details: String = ""    // descrizione dell'opera
    var rating: String
    var watched: Bool = false
}
