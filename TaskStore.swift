//
//  TaskStore.swift
//
//  TaskStore.swift
//  Countries
//

import SwiftUI
import Observation

// Per quale task stiamo scegliendo: quella corrente o una delle next task
enum ChooseTarget: Equatable {
    case current
    case next(Int)      // 0 = primo posto (sinistra), 1 = secondo posto (destra)
}

@Observable
class TaskStore {
    var userName = "Siria"

    // Punteggio totale (in alto a destra nella Home)
    var points = 1256

    // nil = nessuna task scelta ancora
    var currentTask: Item?

    // Coda delle next task: al massimo 2, la prima passa a current quando finisci la principale
    var nextTasks: [Item] = []
    static let maxNextTasks = 2

    // Dove finirà la task scelta con "Choose Task" / "Change Task"
    var chooseTarget: ChooseTarget = .current

    // Schermate aperte sopra la Home
    var showCountries = false       // CountriesView
    var showCongrats = false        // CongratulationsView

    // Dati per la schermata di congratulazioni
    var finishedTask: Item?         // la task appena completata
    var earnedPoints = 0            // i punti guadagnati con quella task

    // MARK: - Next task: posti visibili

    // Quanti posti mostrare nella Home: le task già scelte + 1 vuoto, fino a un massimo di 2
    var visibleNextSlots: Int {
        min(nextTasks.count + 1, TaskStore.maxNextTasks)
    }

    // La task di un certo posto, oppure nil se il posto è vuoto
    func nextTask(at slot: Int) -> Item? {
        slot < nextTasks.count ? nextTasks[slot] : nil
    }

    // true se il posto di destinazione ha già una task (serve per scrivere "Change Task")
    var targetHasTask: Bool {
        switch chooseTarget {
        case .current:
            return currentTask != nil
        case .next(let slot):
            return slot < nextTasks.count
        }
    }

    // MARK: - Aprire CountriesView

    // "+" o "Change Task" della current task
    func openCountries() {
        chooseTarget = .current
        showCountries = true
    }

    // "+" o "Change Task" di una next task
    func openCountries(forNextSlot slot: Int) {
        chooseTarget = .next(slot)
        showCountries = true
    }

    // MARK: - Scegliere

    // Chiamata dal bottone "Choose Task" / "Change Task" della sheet:
    // salva la task nel posto giusto e torna alla Home
    func choose(_ item: Item) {
        switch chooseTarget {
        case .current:
            currentTask = item
        case .next(let slot):
            if slot < nextTasks.count {
                nextTasks[slot] = item                  // Change Task: sostituisce
            } else if nextTasks.count < TaskStore.maxNextTasks {
                nextTasks.append(item)                  // posto vuoto: aggiunge
            }
        }
        showCountries = false
    }

    // MARK: - Punti

    // Prende il primo numero del rating: "8.5/10 (IMDb)" -> 8.5
    func ratingNumber(of item: Item) -> Double? {
        let text = item.rating.replacingOccurrences(of: ",", with: ".")
        var number = ""
        for character in text {
            if character.isNumber || character == "." {
                number.append(character)
            } else if !number.isEmpty {
                break
            }
        }
        return Double(number)
    }

    // Funzione che associa il rating ai punti: rating x 100 (8.5 -> 850)
    // Se la task non ha un rating valido, i punti sono 0.
    func points(for item: Item) -> Int {
        guard let value = ratingNumber(of: item) else { return 0 }
        return Int((value * 100).rounded())
    }

    // Funzione che aumenta il punteggo totale
    func addPoints(_ amount: Int) {
        points += amount
    }

    // MARK: - Completare

    // "Update Progress": aggiunge i punti, svuota la current task e apre le congratulazioni
    func finishCurrentTask() {
        guard let task = currentTask else { return }

        let earned = points(for: task)
        addPoints(earned)
        finishedTask = task
        earnedPoints = earned

        // L'opera è fatta: non deve più comparire tra le scelte
        infoData.markWatched(task.id)
        nextTasks.removeAll { $0.id == task.id }

        currentTask = nil
        showCongrats = true
    }

    // Dopo le congratulazioni: la prima next task diventa la current task.
    // Le altre scalano a sinistra e il posto vuoto torna disponibile.
    func promoteNextTask() {
        guard currentTask == nil, !nextTasks.isEmpty else { return }
        currentTask = nextTasks.removeFirst()
    }
}
