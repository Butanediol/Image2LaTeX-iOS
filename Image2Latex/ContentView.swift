//
//  ContentView.swift
//  Image2Latex
//
//  Created by Butanediol on 11/4/2021.
//

import SwiftUI
import SwiftUIX

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var selectedView: Int?
    @State var searchText: String?

    var body: some View {
        if horizontalSizeClass == .compact {
            // 如果横向布局为紧凑 (iPhone, iPad portrait mode)
            TabView {
                ImageView()
                    .tabItem {
                        Image(systemName: "photo.on.rectangle.angled")
                        Text("Mathpix")
                    }
                
                NavigationView {
                    HistoryView()
                        .navigationBarTitle("History")
                }
                .tabItem{
                    Image(systemName: "calendar")
                    Text("History")
                }
                
                NavigationView {
                    SettingsView()
                        .navigationBarTitle("Settings")
                }
                .tabItem{
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
            }
        }
        else {
            // 否则 (iPad & iPhone Max / Plus Series landscape mode)
            NavigationView {
                List {
                    NavigationLink(
                        destination: ImageView().navigationBarTitle("Mathpix"),
                        tag: 1,
                        selection: self.$selectedView
                    ) {
                        Label("Mathpix", systemImage: "photo.on.rectangle.angled")
                    }
                    NavigationLink(
                        destination: HistoryView().navigationBarTitle("History"),
                        tag: 2,
                        selection: self.$selectedView
                    ) {
                        Label("History", systemImage: "calendar")
                    }
                    NavigationLink(
                        destination: SettingsView().navigationBarTitle("Settings"),
                        tag: 3,
                        selection: self.$selectedView
                    ) {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                }
                .listStyle(SidebarListStyle())
                .navigationBarTitle("Image2LaTeX")
                ImageView().navigationBarTitle("Mathpix")
            }
        }
    }
}
