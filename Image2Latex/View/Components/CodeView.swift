//
//  CodeView.swift
//  Image2Latex
//
//  Created by Butanediol on 11/4/2021.
//

import SwiftUI
import MobileCoreServices

struct CodeView: View {
    
    @State var type: LocalizedStringKey
    @State var content: String
    @State var showCopyAlert = false
    @State var showRichTextView = false
    @State var paddingSize: CGFloat = 0
    @State var disableCopy = false;
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundColor(.secondarySystemBackground)
            Text(type)
                .font(.system(size: 72, weight: .bold))
                .italic()
                .opacity(0.1)
                .padding(paddingSize)
            Text(content)
                .font(.system(.body, design: .monospaced))
                .padding()
                .onDrag {
                    NSItemProvider(item: content.data(using: .utf8)! as NSData, typeIdentifier: kUTTypePlainText as String)
                }
        }
//        .frame(minHeight: 180)
        .onTapGesture {
            if !disableCopy {
                UIPasteboard.general.string = content
                showCopyAlert = true
            }
            showRichTextView = true
        }
        .sheet(isPresented: $showRichTextView) {
            LaTeXView(latexContent: content)
        }
        .alert(isPresented: $showCopyAlert) {
            Alert(title: Text(type) + Text(" copied to clipboard."), message: Text(content), dismissButton: .none)
        }
    }
    
}
