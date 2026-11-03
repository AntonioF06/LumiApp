//
//  ItemsView.swift
//  Lumi
//
//  ItemsView.swift
//  Countries
//

import SwiftUI

struct ItemsView: View {
    let category: Category

    @State private var selectedItem: Item?

    // Solo le opere non ancora completate
    private var availableItems: [Item] {
        category.items.filter { !$0.watched }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(category.name.uppercased())
                    .font(.title.weight(.heavy))

                ForEach(availableItems) { item in
                    Button {
                        selectedItem = item
                    } label: {
                        RowCard(showsChevron: false) {
                            PhotoView(name: item.photo)
                                .frame(width: 64, height: 64)
                                .clipShape(RoundedRectangle(cornerRadius: 16))

                            Text(item.name)
                                .font(.title3.weight(.bold))
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .buttonStyle(.plain)
                }

                if availableItems.isEmpty {
                    Text("You've completed everything in this category!")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(20)
        }
        .scrollIndicators(.hidden)
        .background(Color.appBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedItem) { item in
            ItemDetailSheet(item: item)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(32)
                .presentationBackground(Color.appBackground)
        }
    }
}

#Preview {
    NavigationStack {
        ItemsView(category: infoData.countries[0].categories[0])
    }
    .environment(TaskStore())
}
