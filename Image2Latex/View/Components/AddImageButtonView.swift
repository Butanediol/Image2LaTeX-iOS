//
//  AddImageButtonView.swift
//  Image2Latex
//
//  Created by Butanediol on 11/4/2021.
//

import SwiftUI

struct AddImageButtonView: View {
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle().strokeBorder(Color.secondary, lineWidth: 5)
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 72))
            }
            .frame(maxWidth: 144, maxHeight: 144)
            Text("Tap to select an image")
                .font(.caption)
        }
        .foregroundColor(.secondary)
    }
}

struct AddImageButtonView_Previews: PreviewProvider {
    static var previews: some View {
        AddImageButtonView()
    }
}
