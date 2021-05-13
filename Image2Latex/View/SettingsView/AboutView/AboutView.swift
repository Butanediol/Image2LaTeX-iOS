//
//  AboutView.swift
//  Image2Latex
//
//  Created by Butanediol on 12/5/2021.
//

import SwiftUI

struct AboutView: View {
    
    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                Image("Icon")
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 25.263, style: .continuous))
                    .frame(width: 144, height: 144)
                Spacer()
            }
            .padding(.top, 16)
            
            Text("Image2LaTeX")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 16)
            
            VStack(alignment: .leading, spacing: 16) {
                
                Text("Open Source")
                    .font(.title2)
                    .bold()
            
                CreditView(
                    image: Image("Mantis"),
                    title: "Mantis",
                    detail: "Mantis is an open-source swift library that provides rich cropping interactions for your iOS/Mac app."
                )
                                
                CreditView(
                    image: Image("SwiftUIX"),
                    title: "SwiftUIX",
                    detail: "An extension to the standard SwiftUI library."
                )
            }
            .padding()
            
            VStack(alignment: .leading, spacing: 16) {
                
                Text("Developer")
                    .font(.title2)
                    .bold()
            
                CreditView(
                    image: Image("Butanediol"),
                    title: "Butanediol",
                    detail: "A newbie swift developer."
                )
            }
            .padding()
            
        }
        .fixFlickering()
        .navigationBarTitle("About", displayMode: .inline)
    }
    
}

struct CreditView: View {
    
    let image: Image
    let title: LocalizedStringKey
    let detail: LocalizedStringKey
    
    var body: some View {
        HStack(alignment: .top) {
            image
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(10)
                .clipShape(
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.sRGB, red: 150 / 255, green: 150 / 255, blue: 150 / 255, opacity: 0.1), lineWidth: 2)
                )
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.heavy)
                
                Divider()
                
                Text(detail)
                    .font(.callout)
                    .lineLimit(.none)
            }
            
            Spacer()
        }
    }
    
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutView()
        }
    }
}
