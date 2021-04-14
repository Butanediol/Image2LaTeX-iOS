//
//  CodeView.swift
//  Image2Latex
//
//  Created by Butanediol on 11/4/2021.
//

import SwiftUI
import MobileCoreServices

struct CodeView: View {
    
    @State var type: String
    @State var content: String
    @State var showCopyAlert = false
    @State var showRichTextView = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundColor(.secondarySystemBackground)
            Text(type)
                .font(.system(size: 72, weight: .bold))
                .italic()
                .opacity(0.1)
            Text(content)
                .font(.system(.body, design: .monospaced))
                .padding()
                .onDrag {
                    NSItemProvider(item: content.data(using: .utf8)! as NSData, typeIdentifier: kUTTypePlainText as String)
                }
        }
        .onTapGesture {
            UIPasteboard.general.string = content
            showCopyAlert = true
//            showRichTextView = true
        }
        .sheet(isPresented: $showRichTextView) {
            LaTeXView(latexContent: content)
        }
        .alert(isPresented: $showCopyAlert) {
            Alert(title: Text("\(type) copied to clipboard."), message: Text(content), dismissButton: .none)
        }
    }
    
}
