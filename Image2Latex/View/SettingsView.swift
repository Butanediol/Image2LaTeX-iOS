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
    
    // View States
    @State var showSafari = false
    
    @State var app_id = UserDefaults.standard.string(forKey: "Settings.app_id") ?? ""
    @State var app_key = UserDefaults.standard.string(forKey: "Settings.app_key") ?? ""
    @State var statistics_total = UserDefaults.standard.string(forKey: "Settings.statistics.total") ?? "0"
    
    var body: some View {
        List {
            Section(header: Text("API"), footer: Text("To get an API Token")) {
                HStack { // API ID
                    Text("App ID")
                    TextField("ID", text: $app_id)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .lineLimit(1)
                        .multilineTextAlignment(.trailing)
                        .font(.system(.body, design: .monospaced))
                        .onChange(of: app_id) { app_id in
                            print(app_id)
                            UserDefaults.standard.set(app_id, forKey: "Settings.app_id")
                        }
                }
                
                HStack { // API Key
                    Text("App Key")
                    TextField("Key", text: $app_key)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .lineLimit(1)
                        .multilineTextAlignment(.trailing)
                        .font(.system(.body, design: .monospaced))
                        .onChange(of: app_key) { app_key in
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
            
            Section(header: Text("Statistics")) {
                HStack {
                    Text("Total")
                    Spacer()
                    Text(statistics_total)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .onAppear{ refreshSettingsData() }
    }
    
    func refreshSettingsData() {
        self.app_id = UserDefaults.standard.string(forKey: "Settings.app_id") ?? ""
        self.app_key = UserDefaults.standard.string(forKey: "Settings.app_key") ?? ""
        self.statistics_total = UserDefaults.standard.string(forKey: "Settings.statistics.total") ?? "0"
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
