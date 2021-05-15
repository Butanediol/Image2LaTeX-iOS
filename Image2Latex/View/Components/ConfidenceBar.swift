//
//  ConfidenceBar.swift
//  Image2Latex
//
//  Created by Butanediol on 13/5/2021.
//

import SwiftUI

struct ConfidenceBar: View {
    
    let confidence: Float
    
    @State private var animated = false
    @State var lengthRatio: CGFloat = 0
    
    var color: Color {
        if lengthRatio > 0.66 {
            return .green
        } else if lengthRatio > 0.33 {
            return .yellow
        } else {
            return .red
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10, style: .continuous).frame(width: geometry.size.width ,height: 30)
                    .foregroundColor(color)
                    .opacity(0.3)
                RoundedRectangle(cornerRadius: 10, style: .continuous).frame(width: lengthRatio * geometry.size.width ,height: 30)
                    .foregroundColor(color)
                HStack {
                    Spacer()
                    Text("Confidence: \(Int(confidence * 100))%")
                    Spacer()
                }
            }
        }
        .onAppear {
            if animated == false {
                withAnimation(.spring(dampingFraction: 1).delay(0.2)) {
                    lengthRatio += CGFloat(confidence)
                }
                animated.toggle()
            }
        }
        .frame(height: 30)
    }
    
}
