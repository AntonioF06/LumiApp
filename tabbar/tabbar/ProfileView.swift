//
//  ProfileView.swift
//  tabbar
//
//  Created by AFP FED 021 on 30/10/2026.
//
import SwiftUI

struct ProfileView: View {
    @State private var preference1: String = "Romance"
    @State private var preference2: String = "History"
    @State private var preference3: String = "Drama"
    
    //Genres on the menu
    let availableGenres = ["Romance", "Action", "Comedy", "Drama", "Sci-Fi", "Horror", "Documentary", "Thriller","Crime","History"]
    
    // Nuovi dati mock con libri, film e canzoni italiane famose
    let historyItems = [
        ("La Dolce Vita", "film.fill"),
        ("Il Nome della Rosa", "book.closed.fill"),
        ("Volare", "music.note"),
        ("I Promessi Sposi", "book.fill"),
        ("Cinema Paradiso", "ticket.fill")
    ]
    
    var body: some View {
        NavigationStack {
        ScrollView {
            
            VStack(spacing: 50) {
                
                //Profile
                VStack(spacing: 16) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 160)
                        .foregroundColor(.appLightGray)
                        .background(
                            Circle().fill(Color.white)
                        )
                        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
                    
                    Spacer()
                    Spacer()
              
                    Text("Siria Scognamiglio")
                        .font(.title.weight(.bold))
                        .foregroundColor(.appDarkGreen)
                }
                .padding(.top, 60)
                
                // Preferences
                VStack(alignment: .leading, spacing: 18) {
                    Text("PREFERENCES")
                        .font(.headline.weight(.bold))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 30)
                    
                    
                    // We instantiate three custom 'PreferenceMenu' components to create three separate dropdowns.
                    // The '$' symbol creates a two-way Binding to the @State variables (preference1, preference2, preference3).
                    // This allows each menu to read the current value and directly update the parent's state when a user makes a selection.
                    // We pass the same 'availableGenres' array to all three menus so they share the exact same list of options.
                    HStack(spacing: 15) {
                        PreferenceMenu(selection: $preference1, options: availableGenres)
                        PreferenceMenu(selection: $preference2, options: availableGenres)
                        PreferenceMenu(selection: $preference3, options: availableGenres)
                    }
                    .padding(.horizontal, 30)
                }
                
                // Sezione History (Scorrimento Orizzontale)
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        Text("HISTORY")
                            // Font aumentato
                            .font(.headline.weight(.bold))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        NavigationLink(destination: HistoryView()) {
                            Image(systemName: "chevron.right")
                                .font(.headline.weight(.bold))
                                .foregroundColor(.appDarkGreen)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) { // Maggiore spaziatura tra le card
                            ForEach(0..<historyItems.count, id: \.self) { index in
                                VStack(spacing: 12) {
                                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                                        .fill(Color.appTan.opacity(0.3))
                                        // Card ingrandite
                                        .frame(width: 100, height: 120)
                                        .overlay(   //elemento al centro
                                            Image(systemName: historyItems[index].1)
                                                .font(.system(.largeTitle))
                                                .foregroundColor(.appDarkGreen)
                                        )
                                    
                                    Text(historyItems[index].0)
                                        
                                        .font(.subheadline.weight(.medium))
                                        .foregroundColor(.appDarkGreen)
                                        .lineLimit(1)
                                        .frame(width: 110)
                                }
                            }
                        }
                        // Aggiunto padding extra laterale per invitare l'utente allo scorrimento orizzontale
                        .padding(.horizontal, 30)
                        .padding(.bottom, 10)
                    }
                }
                
                Spacer(minLength: 140)
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
    }
}

struct PreferenceMenu: View {
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: { selection = option }) {
                    Text(option)
                }
            }
        } label: {
            Text(selection.isEmpty ? "       " : selection)
            // Font aggiornato per migliore leggibilità (callout)
                .font(.callout.weight(.medium))
                .foregroundColor(.appDarkGreen)
                .frame(maxWidth: .infinity)
            // Altezza adattiva maggiore
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(selection.isEmpty ? Color.appLightGray.opacity(0.5) : Color.appTan.opacity(0.3))
                )
        }
    }
    }
}
