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
    @State private var showDatePicker: Bool = false
    @State private var selectedDate: Date = Date()

    var body: some View {
        
        if (historyImages.isEmpty) {
            Text("No history")
                .foregroundColor(.secondary)
        } else {
            
            List {
                if showDatePicker {
                    VStack {
                        DatePicker(selection: $selectedDate, in: ...Date(), displayedComponents: [.date], label: { Text("Date") }).datePickerStyle(CompactDatePickerStyle())
                    }
                }
                ForEach(historyImages.filter {
                    (showDatePicker) ?
                        (($0.timestamp! >= Calendar.current.startOfDay(for: selectedDate)) && ($0.timestamp! <= Calendar.current.startOfDay(for: selectedDate).addingTimeInterval(86400))) : true
//                    searchText == nil ? true : DateFormatter.localizedString(from: $0.timestamp!, dateStyle: .long, timeStyle: .medium).contains(searchText!)
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
                                Text(DateFormatter.localizedString(from: image.timestamp!, dateStyle: .long, timeStyle: .medium))
                                HistoryImageBadgeRow(image: image)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .onDelete(perform: deleteHistory)
                
            }
            .listStyle(PlainListStyle())
            .toolbar {
                Button(action: {
                    withAnimation(.easeInOut) {
                        showDatePicker.toggle()
                    }
                }) {
                    Label("Select date", systemImage: showDatePicker ? "calendar.circle.fill" : "calendar.circle")
                }
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
