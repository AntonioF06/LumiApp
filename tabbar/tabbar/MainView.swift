//
//  MainView.swift
//  tabbar
//
//  Created by AFP FED 021 on 30/10/2026.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab: TabType = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Sfondo dell'app basato sulla palette
            Color.appBackground.ignoresSafeArea()
            
            // Gestione dei contenuti
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .globe:
                    GlobeView()
                case .profile:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // Aggiungi un padding inferiore nelle view per non coprire i contenuti con la tab bar
            
            // La Tab Bar in primo piano
            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}

// MARK: - Pagine di Esempio
struct HomeView: View {
    var body: some View {
        VStack {
            Text("Home Page")
                .font(.largeTitle).bold()
                .foregroundColor(.appDarkGreen)
        }
    }
}

struct GlobeView: View {
    var body: some View {
        VStack {
            Text("Globe Page")
                .font(.largeTitle).bold()
                .foregroundColor(.appDarkGreen)
        }
    }
}

#Preview {
    MainView()
}
