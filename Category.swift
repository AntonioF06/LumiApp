//
//  Category.swift
//  Lumi
//
//  Created by AFP FED 025 on 30/10/2026.
//

//
//

import Foundation

struct Category: Identifiable {
    let id = UUID()
    var name: String
    var icon: String    // nome di un SF Symbol
    var items: [Item]
}
