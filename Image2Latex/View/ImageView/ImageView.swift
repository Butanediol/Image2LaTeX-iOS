//
//  ContentView.swift
//  Image2Latex
//
//  Created by Butanediol on 8/4/2021.
//

import SwiftUI
//import SwiftUIX

struct ImageView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @ObservedObject var viewModel = imageViewModel()
    @State private var selectImage = false
    @State private var cropImage = false
    
    private let dropShadowRadius: CGFloat = 2.0
    
    var body: some View {
        VStack(spacing: 8) {
            
            // Image not loaded
            Button(action: {
                self.selectImage = true
            }) {
                AddImageButtonView()
                    .opacity(viewModel.image == nil ? 1 : 0)
                    .scaleEffect(x: viewModel.image == nil ? 1 : 0, y: viewModel.image == nil ? 1 : 0)
                    .frame(maxWidth: viewModel.image == nil ? .infinity : 0, maxHeight: viewModel.image == nil ? .infinity : 0)
            }.sheet(isPresented: $selectImage, onDismiss: { cropImage = true }) {
                ImagePicker(image: $viewModel.image)
                    .edgesIgnoringSafeArea(.bottom)
            }
            
            if let imageData = viewModel.image { // Image loaded
                Spacer()
                
                Image(uiImage: imageData)
                    .resizable()
                    .aspectRatio(contentMode: (viewModel.isLoading || viewModel.response != nil) ? .fill : .fit)
                    .cornerRadius(10)
                    .frame(maxWidth: UIScreen.main.bounds.width - 16, maxHeight: (viewModel.isLoading || viewModel.response != nil) ? 200 : .infinity).cornerRadius(10)
                    .clipped()
                    .onTapGesture {
                        if !viewModel.isLoading {
                            cropImage.toggle()
                        }
                    }
                    .fullScreenCover(isPresented: $cropImage) { // If requesting, ban cropping
                        MantisController(image: viewModel.image!, showView: $cropImage) { image in
                            if let image = image {
                                viewModel.image = image
                            }
                        }
                        .edgesIgnoringSafeArea(.vertical)
                        .transition(.scale)
                    }
                
                // Loading
                if viewModel.isLoading {
                    CodeView(type: "", content: String(repeating: "Placeholder", count: Int.random(in: 20...40)), disableCopy: true)
                        .redacted(reason: .placeholder)
                    CodeView(type: "", content: String(repeating: "Placeholder", count: Int.random(in: 20...40)), disableCopy: true)
                        .redacted(reason: .placeholder)
                }
                
                // Results
                if let response = viewModel.response {
                    if response.error != nil {
                        CodeView(type: "Error", content: "\(response.error_info != nil ? "\(response.error_info!.message)" : "")")
                    } else {
                        
                        if let confidence = response.confidence {
                            ConfidenceBar(confidence: confidence)
                        }
                        
                        if let text = response.text {
                            CodeView(type: "Text", content: text)
                        }
                        if let latex = response.latex_styled {
                            CodeView(type: "LaTeX", content: latex)
                        }
                        if let html = response.html {
                            CodeView(type: "HTML", content: html)
                        }
                    }
                }
                
                Spacer()
                
                // Control Buttons
                HStack {
                    
                    if (!viewModel.isLoading) { // Request not finished.
                        Button(action: {
                            viewModel.image = nil
                            viewModel.response = nil
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.blue)
                                Text("Remove")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    if (!viewModel.isLoading && viewModel.response == nil) { // Not requesting or request not finished.
                        Button(action: {
                            viewModel.processImageV2(context: viewContext)
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.blue)
                                Text("Process")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .frame(height: 45)
            }
        }
        .padding()
        .animation(.spring())
        .navigationBarHidden(horizontalSizeClass == .compact ? true : false)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
}
