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
        VStack {
            Image(data: image.imageData ?? Data())?
                .resizable()
                .scaledToFit()
            
            Spacer()
        }
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
