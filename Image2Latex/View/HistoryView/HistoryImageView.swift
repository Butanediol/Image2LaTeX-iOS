//
//  HIstoryDetailView.swift
//  Image2Latex
//
//  Created by Butanediol on 20/4/2021.
//

import SwiftUI
import SwiftUIX

struct HistoryImageView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State var image: HistoryImage
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                Image(data: image.imageData ?? Data())?
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .clipped()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.sRGB, red: 150 / 255, green: 150 / 255, blue: 150 / 255, opacity: 0.1), lineWidth: 1)
                    )
                
                if let confidence = image.confidence {
                    ConfidenceBar(confidence: confidence)
                }
                
                if let text = image.text {
                    CodeView(type: "Text", content: text, paddingSize: 54)
                }
                if let latex = image.latex {
                    CodeView(type: "LaTeX", content: latex, paddingSize: 54)
                }
                if let html = image.html {
                    CodeView(type: "HTML", content: html, paddingSize: 54)
                }
            }
            .padding()
        }
        .fixFlickering()
        .navigationBarTitle(DateFormatter.localizedString(from: image.timestamp!, dateStyle: .long, timeStyle: .medium), displayMode: .inline)
    }
    
    private func deleteAfter() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {

                viewContext.delete(image)
                
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
}
