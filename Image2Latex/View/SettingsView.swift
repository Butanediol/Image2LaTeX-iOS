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
    @State var showDeleteAlert = false
    @State var deletedSuccessfully = false
    @State var resetStatisticsConfirm = false

    @State var app_id = UserDefaults.standard.string(forKey: "Settings.app_id") ?? ""
    @State var app_key = UserDefaults.standard.string(forKey: "Settings.app_key") ?? ""
    @State var dev_mode = UserDefaults.standard.bool(forKey: "Settings.devmode")
    @State var statistics_total = UserDefaults.standard.integer(forKey: "Settings.statistics.total")

    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \HistoryImage.timestamp, ascending: true)])
    private var historyImages: FetchedResults<HistoryImage>

    var body: some View {
        List {
            Section(header: Text("API"), footer: Text("To get your App ID and App Key, you need to create your own Mathpix account and add a payment method.")) {
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

                HStack { // MARK: - DEV MODE
                    Toggle("Development Mode", isOn: $dev_mode).onChange(of: dev_mode, perform: { mode in UserDefaults.standard.set(dev_mode, forKey: "Settings.devmode") })
                }

                Button(action: {
                    self.showSafari = true
                }) { Text("Get an API key") }
                    .sheet(isPresented: $showSafari) {
                    SafariView(url: URL(string: "https://accounts.mathpix.com/ocr-api")!)
                }
            }

            Section(header: Text("Statistics")) {
                HStack {
                    Text("Total")
                    Spacer()
                    Text("\(statistics_total)")
                }

                Button(action: {
                    resetStatisticsConfirm.toggle()
                }) { Text("Reset Statistics") }
                    .alert(isPresented: $resetStatisticsConfirm) {
                    Alert(
                        title: Text("Are you sure you want to reset statistics?"),
                        primaryButton: .destructive(Text("Reset")) { UserDefaults.standard.set(0, forKey: "Settings.statistics.total"); refreshSettingsData() },
                        secondaryButton: .cancel()
                    )
                }
            }

            Section(header: Text("History")) {
                Button(action: {
                    showDeleteAlert.toggle()
                }) { Text("Delete all history") }
                    .foregroundColor(.systemRed)
                    .alert(isPresented: $showDeleteAlert) {
                    Alert(
                        title: Text("Are you sure you want to delete all history images?"),
                        message: Text("There is no undo"),
                        primaryButton: .destructive(Text("Delete")) {
                            deleteAllHistory()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
            .listStyle(InsetGroupedListStyle())
            .onAppear { refreshSettingsData() }
    }

    func refreshSettingsData() {
        self.app_id = UserDefaults.standard.string(forKey: "Settings.app_id") ?? ""
        self.app_key = UserDefaults.standard.string(forKey: "Settings.app_key") ?? ""
        self.statistics_total = UserDefaults.standard.integer(forKey: "Settings.statistics.total")
    }
}

extension SettingsView {
    func deleteAllHistory() {
        for image in historyImages {
            viewContext.delete(image)
        }
        do {
            try viewContext.save()
        } catch {
            // TODO: - Replace with proper handle implementation
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
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
