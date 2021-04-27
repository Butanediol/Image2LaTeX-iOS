//
//  HistoryImageCardView.swift
//  Image2Latex
//
//  Created by Butanediol on 23/4/2021.
//

import SwiftUI

struct HistoryImageCardView: View {

    @Environment(\.managedObjectContext) private var viewContext

    var image: HistoryImage

    var body: some View {
        NavigationLink(destination: HistoryImageView(image: image)) {
            VStack {
                Image(data: image.imageData!)?
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                HStack {
                    VStack(alignment: .leading) {
                        Text("LaTeX, HTML, Text")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("An Image2LaTeX Sample")
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .lineLimit(3)
                        Text("\(dateFormatter.string(from: image.timestamp!))".uppercased())
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                        .layoutPriority(100)

                    Spacer()
                }
                    .padding()
            }
                .background(Color.systemBackground)
                .cornerRadius(10)
                .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.sRGB, red: 150 / 255, green: 150 / 255, blue: 150 / 255, opacity: 0.1), lineWidth: 1)
            )
                .padding([.top, .horizontal])
        }
            .contextMenu { // Long press to delete
            Button {
                deleteImage(image)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

extension HistoryImageCardView {
    private func deleteImage(_ image: HistoryImage) {
        withAnimation(.easeInOut(duration: 0.1)) {
            viewContext.delete(image)

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
