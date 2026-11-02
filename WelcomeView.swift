//
//  User.swift
//  MyApp
//
//  Created by AFP FED 018 on 30/10/2026.
//

import SwiftUI
import PhotosUI

// 1. Vista radice
struct User: View {
    @AppStorage("savedUsername") private var savedUsername: String = ""

    var body: some View {
        if savedUsername.isEmpty {
            OnboardingFlowView()
        } else {
            HomeView()
        }
    }
}

// 2. Flusso di Onboarding (Benvenuto -> Dati profilo)
struct OnboardingFlowView: View {
    @State private var showSetupStep = false

    var body: some View {
        Group {
            if showSetupStep {
                ProfileSetupView()
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            } else {
                WelcomeScreen(showSetupStep: $showSetupStep)
                    .transition(.move(edge: .leading).combined(with: .opacity))
            }
        }
    }
}

// 3. Schermata di Benvenuto
struct WelcomeScreen: View {
    @Binding var showSetupStep: Bool

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Welcome!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("We're excited to have you here. Let's set up your profile to get started.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                withAnimation(.easeInOut) {
                    showSetupStep = true
                }
            }) {
                Text("Get Started")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
}

// 4. Schermata con Nome (obbligatorio) e Foto (facoltativa)
struct ProfileSetupView: View {
    @AppStorage("savedUsername") private var savedUsername: String = ""
    @AppStorage("savedProfileImageData") private var savedProfileImageData: Data?

    @State private var inputUsername: String = ""
    
    // Gestione selezione foto
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImageData: Data?

    var body: some View {
        VStack(spacing: 25) {
            Text("Create Your Profile")
                .font(.title2)
                .fontWeight(.semibold)

            // Selettore Foto Profilo (Opzionale)
            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                VStack(spacing: 8) {
                    if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        ZStack {
                            Circle()
                                .fill(Color.secondary.opacity(0.15))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "camera.fill")
                                .font(.title)
                                .foregroundColor(.accentColor)
                        }
                    }

                    Text("Add Photo (Optional)")
                        .font(.footnote)
                        .foregroundColor(.accentColor)
                }
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }

            // Campo Nome (Obbligatorio)
            TextField("Username (required)", text: $inputUsername)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            // Pulsante di conferma
            Button(action: {
                // Salvataggio della foto (se selezionata)
                if let selectedImageData {
                    savedProfileImageData = selectedImageData
                }
                
                // Salvataggio username (chiude l'onboarding e apre la Home)
                savedUsername = inputUsername.trimmingCharacters(in: .whitespaces)
            }) {
                Text("Confirm")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
            // Disabilitato solo se il nome è vuoto: la foto non blocca il tasto
            .disabled(inputUsername.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding()
    }
}

// 5. Home Screen con saluto e foto profilo (o avatar di default)
struct HomeView: View {
    @AppStorage("savedUsername") private var savedUsername: String = ""
    @AppStorage("savedProfileImageData") private var savedProfileImageData: Data?

    var body: some View {
        VStack {
            // Header con Saluto a sinistra e Avatar a destra
            HStack {
                Text("Hi, \(savedUsername) 👋")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                // Mostra la foto salvata, altrimenti un'icona generica
                if let savedProfileImageData, let uiImage = UIImage(data: savedProfileImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            Spacer()
            
            Text("This is your Home Screen.")
                .foregroundColor(.secondary)
            
            Spacer()
            
            // Tasto per resettare tutti i dati e rieseguire il test
            Button(action: {
                savedUsername = ""
                savedProfileImageData = nil
            }) {
                Text("Reset App (For testing)")
                    .foregroundColor(.red)
            }
            .padding(.bottom)
        }
    }
}

#Preview {
    User()
}
