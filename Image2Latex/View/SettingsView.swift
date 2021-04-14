//
//  SettingsView.swift
//  Image2Latex
//
//  Created by Butanediol on 11/4/2021.
//

import SwiftUI
import SafariServices

struct SettingsView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State var mySettings = Settings()
    
    @State var showSafari = false
    
    var body: some View {
        List {
            Section(header: Text("API")) {
                HStack { // API ID
                    Text("App ID")
                    TextField("ID", text: $mySettings.app_id)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .lineLimit(1)
                        .multilineTextAlignment(.trailing)
                        .font(.system(.body, design: .monospaced))
                        .onChange(of: mySettings.app_id) { app_id in
                            print(app_id)
                            UserDefaults.standard.set(app_id, forKey: "Settings.app_id")
                        }
                }
                
                HStack { // API Key
                    Text("App Key")
                    TextField("Key", text: $mySettings.app_key)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .lineLimit(1)
                        .multilineTextAlignment(.trailing)
                        .font(.system(.body, design: .monospaced))
                        .onChange(of: mySettings.app_key) { app_key in
                            print(app_key)
                            UserDefaults.standard.set(app_key, forKey: "Settings.app_key")
                        }
                }
                
                Button("Get an API key") {
                    self.showSafari = true
                }
                .sheet(isPresented: $showSafari) {
                    SafariView(url: URL(string: "https://accounts.mathpix.com/ocr-api")!)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct SafariView: UIViewControllerRepresentable {
    
    let url: URL
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
