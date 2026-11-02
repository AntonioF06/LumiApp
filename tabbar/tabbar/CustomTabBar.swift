//
//  CustomTabBar.swift
//  tabbar
//
//  Created by AFP FED 021 on 30/10/2026.
//

import SwiftUI

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabType
    @Namespace private var animation // Necessario per l'animazione di scorrimento
    
    var body: some View {
        HStack {
            ForEach(TabType.allCases, id: \.rawValue) { tab in
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }) {
                    ZStack {
                        // Sfondo scorrevole (Indicatore)
                        if selectedTab == tab {
                            Capsule()
                                .fill(Color.appTan.opacity(0.4)) // Colore della palette
                                .matchedGeometryEffect(id: "slidingBar", in: animation)
                                .frame(width: 60, height: 40)
                        }
                        
                        // Icona
                        Image(systemName: tab.rawValue)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(selectedTab == tab ? .appDarkGreen : .appLightGray)
                    }
                    .frame(width: 60, height: 50)
                }
                
                Spacer()
            }
        }
        .padding(.vertical, 10)
            // Effetto Glass
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 35, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 35, style: .continuous)
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 8)
        .padding(.horizontal, 30)
        .padding(.bottom, 10)
    }
}
