//
//  HistoryView.swift
//  Image2Latex
//
//  Created by Butanediol on 11/4/2021.
//

import SwiftUI
import SwiftUIX
import CoreData

struct HistoryView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \HistoryImage.timestamp, ascending: true)],
                  animation: .easeInOut)
    private var historyImages: FetchedResults<HistoryImage>
    
    @State var searchText: String?
    @State var isEditing: Bool = false
    @State var showDetail: Bool = false
    
    let list = 0..<100
    
    var body: some View {
//        List(list.filter { searchText == nil ? true : String($0).contains(searchText!) }, id: \.self) { item in
//            Text("Item \(item)")
//        }
        List {
            ForEach(historyImages.filter {
                searchText == nil ? true : dateFormatter.string(from: $0.timestamp ?? Date()).contains(searchText!)
            } ) { image in
                Image(data: image.imageData!)?.resizable().scaledToFit()
                    .onTapGesture {
                        showDetail = true
                    }
                    .sheet(isPresented: $showDetail) {
                        NavigationView {
                            ScrollView {
                                Image(data: image.imageData!)?.resizable().scaledToFit()
                                Text("还没写，别着急")
                            }
                            .navigationBarTitle(dateFormatter.string(from: image.timestamp ?? Date()), displayMode: .inline)
                        }
                    }
            }
            .onDelete(perform: deleteHistory)
        }
        .navigationSearchBar{
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

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
