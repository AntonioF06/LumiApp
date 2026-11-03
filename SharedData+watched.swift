//
//  SharedData+watched.swift
//  Lumi
//
//  SharedData+Watched.swift
//  Countries
//
//  Estensione di SharedData: non tocca il tuo file con i dati.
//

import Foundation

extension SharedData {
    // Segna come watched l'opera con questo id, ovunque si trovi (paese, categoria)
    func markWatched(_ itemID: UUID) {
        for country in countries.indices {
            for category in countries[country].categories.indices {
                for item in countries[country].categories[category].items.indices {
                    if countries[country].categories[category].items[item].id == itemID {
                        countries[country].categories[category].items[item].watched = true
                    }
                }
            }
        }
    }
}
