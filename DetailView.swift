//
//  DetailView.swift
//  Lumi
//
//  Created by AFP FED 025 on 30/10/2026.
//
//  DetailView.swift
//  Lumi
//
//  Created by AFP FED 025 on 30/10/2026.
//

//
//
//  ItemDetailSheet.swift
//  Countries
//

import SwiftUI

struct ItemDetailSheet: View {
    let item: Item

    @Environment(\.dismiss) private var dismiss
    @Environment(TaskStore.self) private var store

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PhotoView(name: item.photo)
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 32))

                Text(item.name)
                    .font(.title.weight(.heavy))

                // Autore e Anno
                if !item.author.isEmpty || !item.year.isEmpty {
                    HStack {
                        Text(item.author)
                        if !item.author.isEmpty && !item.year.isEmpty {
                            Text("·")
                        }
                        Text(item.year)
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                }

                // Rating con Stella
                if !item.rating.isEmpty {
                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text(item.rating)
                            .font(.subheadline.weight(.bold))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.yellow.opacity(0.2), in: Capsule())
                }

                // Descrizione / Dettagli
                if !item.details.isEmpty {
                    Text(item.details)
                        .font(.body)
                }

                // Pulsante inserito direttamente nel contenuto scorrevole
                Button {
                    store.choose(item)
                    dismiss()
                } label: {
                    Text(store.targetHasTask ? "Change Task" : "Choose Task")
                        .font(.headline.weight(.heavy))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(Color.black, in: Capsule())
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
            }
            .padding(20)
        }
        .scrollIndicators(.hidden)
        .background(Color.appBackground.ignoresSafeArea())
    }
}

#Preview {
    ItemDetailSheet(
        item: Item(
            photo: "esempio",
            name: "Titolo",
            author: "Autore",
            year: "2000",
            details: "Qui va la descrizione dell'opera.",
            rating: "8.5/10 (IMDb)"
        )
    )
    .environment(TaskStore())
}
