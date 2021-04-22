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
        Image(data: image.imageData ?? Data())?
            .resizable()
            .scaledToFit()
        
        ZStack {
            
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "arrow.left")
                            .font(.system(.title))
                            .frame(width: 50, height: 50)
                            .foregroundColor(.primary)
                    })
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        deleteAfter()
                    }, label: {
                        Image(systemName: "trash")
                            .font(.system(.title))
                            .frame(width: 50, height: 50)
                            .foregroundColor(.red)
                    })
                }
                .background(.systemBackground)
                .cornerRadius(25)
                .padding()
                .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 0)
            }
        }
        .hideNavigationBar()
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
