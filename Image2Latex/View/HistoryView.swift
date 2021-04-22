//
//  HistoryView.swift
//  Image2Latex
//
//  Created by Butanediol on 11/4/2021.
//

import CoreData
import SwiftUI
import SwiftUIX

struct HistoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \HistoryImage.timestamp, ascending: true)],
                  animation: .easeInOut)
    private var historyImages: FetchedResults<HistoryImage>

    // View States
    @State var searchText: String?
    @State private var selectedHistoryImage: HistoryImage?
    @State var isEditing: Bool = false

    var body: some View {
        List {
            ForEach(historyImages.filter {
                searchText == nil ? true : dateFormatter.string(from: $0.timestamp ?? Date()).contains(searchText!)
            }) { image in
                HStack {
                    Image(data: image.imageData!)?.resizable().scaledToFill().frame(width: 50, height: 50)
                        .onTapGesture {
                            selectedHistoryImage = image
                            print("Date: \(dateFormatter.string(from: image.timestamp!))")
                        }
                    NavigationLink(destination: HistoryImageView(image: image), label: {EmptyView()})
                }
            }
            .onDelete(perform: deleteHistory)
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
                // TODO: Replace with proper handle implementation
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
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
