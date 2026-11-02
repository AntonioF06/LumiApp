//
//  HistoryView.swift
//  tabbar
//
//  Created by AFP FED 021 on 02/11/2026.
//

import SwiftUI

// Modello dei dati
struct HistoryItemModel: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let description: String
    let rating: Double
    
    var points: Int {
        return Int(rating * 100)
    }
}

struct HistoryView: View {
    // Dati mock in inglese con descrizioni
    let items: [HistoryItemModel] = [
        HistoryItemModel(title: "La Dolce Vita", icon: "film.fill", description: "A journalist embarks on a decadent journey through the glamorous and hedonistic high society of 1960s Rome.", rating: 4.8),
        HistoryItemModel(title: "The Name of the Rose", icon: "book.closed.fill", description: "A gripping medieval murder mystery set in an isolated abbey, where a friar investigates a series of dark secrets.", rating: 4.9),
        HistoryItemModel(title: "Volare", icon: "music.note", description: "The iconic Italian masterpiece that captured the world's heart with its sweeping melody and message of freedom.", rating: 5.0),
        HistoryItemModel(title: "The Betrothed", icon: "book.fill", description: "An epic tale of star-crossed lovers navigating war, plague, and corruption in 17th-century Italy.", rating: 4.5),
        HistoryItemModel(title: "Cinema Paradiso", icon: "ticket.fill", description: "A beautiful, nostalgic celebration of youth, friendship, and the enduring magic of the silver screen.", rating: 4.7)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(items) { item in
                    HStack(alignment: .top, spacing: 16) {
                        
                        // Sinistra: Immagine/Icona
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color.appTan.opacity(0.3))
                            .frame(width: 85, height: 120)
                            .overlay(
                                Image(systemName: item.icon)
                                    .font(.largeTitle)
                                    .foregroundColor(.appDarkGreen)
                            )
                        
                        // Destra: Contenuti testuali in verticale
                        VStack(alignment: .leading, spacing: 8) {
                            
                            // Prima riga: Punti con icona medaglia
                            HStack(alignment: .center, spacing: 6) {
                                Image(systemName: "medal.fill")
                                    .font(.title3)
                                    .foregroundColor(.appTan) // Usa il colore beige della palette
                                
                                Text("\(item.points) pts")
                                    .font(.title.weight(.heavy)) // HIG: Font semantico scalabile
                                    .foregroundColor(.appDarkGreen)
                            }
                            
                            // Seconda riga: Titolo
                            Text(item.title)
                                .font(.headline)
                                .foregroundColor(.primary)
                                .lineLimit(2)
                            
                            // Terza riga: Descrizione
                            Text(item.description)
                                .font(.callout)
                                .foregroundColor(.secondary)
                                .lineLimit(4)
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer(minLength: 0)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(Color(UIColor.secondarySystemGroupedBackground))
                            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 120)
        }
        .background(Color.appBackground.ignoresSafeArea())
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
    }
}
