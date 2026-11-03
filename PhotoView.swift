//
//  PhotoView.swift
//  Lumi
//
//  Created by AFP FED 025 on 30/10/2026.
//

//
//  PhotoView.swift
//  Countries
//

import SwiftUI
import UIKit

// Mostra la foto dagli Assets; se non esiste ancora, mostra un segnaposto grigio.
struct PhotoView: View {
    let name: String

    var body: some View {
        if UIImage(named: name) != nil {
            Image(name)
                .resizable()
                .scaledToFill()
        } else {
            ZStack {
                Color.gray.opacity(0.15)
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    PhotoView(name: "esempio")
        .frame(width: 50, height: 50)
}
