//
//  Country.swift
//  Lumi
//
//  Created by AFP FED 025 on 30/10/2026.
//

//
//  Country.swift
//  Countries
//

import Foundation

struct Country: Identifiable {
    let id = UUID()
    var name: String
    var flag: String
    var categories: [Category]
}
