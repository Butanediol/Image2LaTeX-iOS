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
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \HistoryImage.timestamp, ascending: true)])
    private var historyImages: FetchedResults<HistoryImage>
    
    // View States
    @State var searchText: String?
    @State private var selectedHistoryImage: HistoryImage?
    @State private var isEditing: Bool = false
    
    var body: some View {
        
        if (historyImages.isEmpty) {
            Text("No history")
                .foregroundColor(.secondary)
//                .hideNavigationBar()
        } else {
            
            List {
                ForEach(historyImages.filter {
                    searchText == nil ? true : dateFormatter.string(from: $0.timestamp ?? Date()).contains(searchText!)
                }) { image in
                    NavigationLink(destination: HistoryImageView(image: image)) {
                        HStack(alignment: .bottom) {
                            Image(data: image.thumbnailImageData ?? image.imageData ?? Data())?
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipped()
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(.sRGB, red: 150 / 255, green: 150 / 255, blue: 150 / 255, opacity: 0.1), lineWidth: 1)
                                )
                            
                            VStack(alignment: .leading) {
                                Text(dateFormatter.string(from: image.timestamp!))
                                HistoryImageBadgeRow(image: image)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .onDelete(perform: deleteHistory)
                
            }
            .listStyle(PlainListStyle())
            .navigationSearchBar {
                SearchBar("Search history...", text: $searchText, isEditing: $isEditing)
                    .showsCancelButton(isEditing)
                    .onCancel {
                        searchText = nil
                    }
            }
            .navigationSearchBarHiddenWhenScrolling(true)
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

struct HistoryImageBadgeRow: View {
    
    var image: HistoryImage
    
    var body: some View {
        HStack {
            if image.latex != nil {
                Text("LaTeX")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(2)
                    .background(RoundedRectangle(cornerRadius: 4).fill(Color.green))
            }
            if image.html != nil {
                Text("HTML")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(2)
                    .background(RoundedRectangle(cornerRadius: 4).fill(Color.orange))
            }
            if image.text != nil {
                Text("Text")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(2)
                    .background(RoundedRectangle(cornerRadius: 4).fill(Color.yellow))
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
