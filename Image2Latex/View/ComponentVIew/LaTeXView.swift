//
//  RichTextView.swift
//  Image2Latex
//
//  Created by Butanediol on 11/4/2021.
//

import SwiftUI
import WebKit

struct LaTeXView: View {
    
    @State var latexContent: String
    
    var body: some View {
        WebView(text: latexContent)
    }
}

struct WebView: UIViewRepresentable {
  var text: String
   
  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }
   
  func updateUIView(_ uiView: WKWebView, context: Context) {
    uiView.loadHTMLString(text, baseURL: nil)
  }
}
