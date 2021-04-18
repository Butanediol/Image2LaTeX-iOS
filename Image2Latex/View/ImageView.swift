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
    
    @ObservedObject var viewModel = imageViewModel()
    @State private var selectImage = false
    @State private var cropImage = false
    
    let dropShadowRadius: CGFloat = 2.0
    
    var body: some View {
        VStack(spacing: 8) {
            
            // Image not loaded
            Button(action: {
                self.selectImage = true
            }) {
                AddImageButtonView()
                    .opacity(viewModel.imageData == nil ? 1 : 0)
                    .scaleEffect(x: viewModel.imageData == nil ? 1 : 0, y: viewModel.imageData == nil ? 1 : 0)
                    .frame(maxWidth: viewModel.imageData == nil ? .infinity : 0, maxHeight: viewModel.imageData == nil ? .infinity : 0)
            }.sheet(isPresented: $selectImage, onDismiss: {cropImage = true}) {
                ImagePicker(image: $viewModel.imageData)
            }
            
            if let imageData = viewModel.imageData { // Image loaded
                Spacer()
                
                Image(uiImage: imageData)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .shadow(color: Color(hexadecimal: "d3d3d3"), radius: dropShadowRadius, x: 0, y: 0)
                    .frame(maxHeight: viewModel.isLoading || viewModel.response != nil ? 200 : 400)
                    .onTapGesture { cropImage.toggle() }
                    .fullScreenCover(isPresented: $cropImage) {
                        MantisController(image: viewModel.imageData!, showView: $cropImage) { image in
                            if let image = image {
                                viewModel.imageData = image
                            }
                        }
                        .edgesIgnoringSafeArea(.vertical)
                    }
                Spacer()
                
                // Loading
                if viewModel.isLoading {
                    CodeView(type: "", content: String(repeating: "Placeholder", count: Int.random(in: 20...40)))
                        .redacted(reason: .placeholder)
                    CodeView(type: "", content: String(repeating: "Placeholder", count: Int.random(in: 20...40)))
                        .redacted(reason: .placeholder)
                }
                
                // Results
                if let response = viewModel.response {
                    if response.error != nil {
                        CodeView(type: "Error", content: "\(response.error_info != nil ? "\(response.error_info!.message)" : "")")
                    } else {
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
                
                // Control Buttons
                HStack {
                    if (!viewModel.isLoading) { // Request not finished.
                        Button(action: {
                            viewModel.imageData = nil
                            viewModel.response = nil
                        }) {
                            Text("Remove")
                        }
                        .padding(8)
                        .background(.secondarySystemBackground)
                        .clipShape(Capsule())
                    }
                    
                    if (!viewModel.isLoading && viewModel.response == nil) { // Not requesting or request not finished.
                        Button("Process") {
                            viewModel.processImageV2(context: viewContext)
                        }
                        .padding(8)
                        .background(.secondarySystemBackground)
                        .clipShape(Capsule())
                    }
                }
            }
        }
        .padding()
        .animation(.spring())
        .navigationBarHidden(true)
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
