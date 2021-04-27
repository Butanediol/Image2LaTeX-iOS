//
//  HistoryView.swift
//  Image2Latex
//
//  Created by Butanediol on 11/4/2021.
//

import CoreData
import SwiftUI
import SwiftUIX
import WaterfallGrid

struct HistoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \HistoryImage.timestamp, ascending: true)])
    private var historyImages: FetchedResults<HistoryImage>

    // View States
    @State var searchText: String?
    @State private var selectedHistoryImage: HistoryImage?
    @State var isEditing: Bool = false

    var body: some View {

        ScrollView(showsIndicators: true) {

            if (historyImages.isEmpty) {
                Text("No history.")
            } else {

                WaterfallGrid(historyImages.filter {
                    searchText == nil ? true : dateFormatter.string(from: $0.timestamp ?? Date()).contains(searchText!)
                }) { image in

                    HistoryImageCardView(image: image)

                }
                    .gridStyle(columnsInPortrait: 1, columnsInLandscape: 3, spacing: 8, animation: .spring())
            }
        }
            .navigationSearchBar {
            SearchBar("Search history...", text: $searchText, isEditing: $isEditing)
                .showsCancelButton(isEditing)
                .onCancel {
                searchText = nil
            }
        }
    }

    private func deleteHistory(offsets: IndexSet) {
        withAnimation {
            offsets.map {
                historyImages[$0]
            }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // TODO: - Replace with proper handle implementation
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
