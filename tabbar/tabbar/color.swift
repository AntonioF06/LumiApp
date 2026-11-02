//
//  color.swift
//  tabbar
//
//  Created by AFP FED 021 on 30/10/2026.
//

import SwiftUI
import UIKit // Necessario per usare i tratti di sistema di UIColor

extension Color {
    // Funzione helper per creare colori che cambiano in base al tema
    static func dynamicColor(light: String, dark: String) -> Color {
        return Color(UIColor { traitCollection in
            // Controlla se il sistema è in dark mode e restituisce l'HEX corrispondente
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor(hex: dark)
            } else {
                return UIColor(hex: light)
            }
        })
    }
    
    // I tuoi colori con le due varianti (Chiaro, Scuro)
    // Puoi modificare i codici HEX del parametro "dark" con la tua palette ideale
    static let appGreen = dynamicColor(light: "6FA38C", dark: "4A7B65")
    static let appTan = dynamicColor(light: "C9B58E", dark: "A8936A")
    
    // Sfondo: Beige in light mode, Grigio scuro/Nero in dark mode
    static let appBackground = dynamicColor(light: "F7F1E7", dark: "1C1C1E")
    
    // Testo/Icone: Verde scuro in light mode, Bianco/Grigio chiaro in dark mode
    static let appDarkGreen = dynamicColor(light: "2F5B4A", dark: "F2F2F7")
    
    // Elementi secondari
    static let appLightGray = dynamicColor(light: "D8D0C0", dark: "3A3A3C")
}

extension UIColor {
    // L'inizializzatore Hex spostato su UIColor per supportare i colori dinamici
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
