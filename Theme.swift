//
//  Theme.swift
//  Lumi
//
//  Theme.swift
//  Countries
//
//  Colori e pezzi grafici condivisi, per avere lo stesso stile della Home ovunque.
//

import SwiftUI

extension Color {
    // Sfondo crema della Home
    static let appBackground = Color(red: 0.99, green: 0.97, blue: 0.94)
}

// Riga a "card" bianca semi-trasparente con angoli molto arrotondati
struct RowCard<Content: View>: View {
    let showsChevron: Bool
    let content: Content

    init(showsChevron: Bool = true, @ViewBuilder content: () -> Content) {
        self.showsChevron = showsChevron
        self.content = content()
    }

    var body: some View {
        HStack(spacing: 14) {
            content

            Spacer()

            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.6), in: RoundedRectangle(cornerRadius: 24))
        .contentShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
    }
}

extension Color {
    // Grigio-verde scuro del "+" nelle Additional tasks
    static let plusGray = Color(red: 0.29, green: 0.31, blue: 0.28)
}

// Effetto "pressione": la card si rimpicciolisce leggermente quando la tocchi
struct PressableStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(duration: 0.25), value: configuration.isPressed)
    }
}
