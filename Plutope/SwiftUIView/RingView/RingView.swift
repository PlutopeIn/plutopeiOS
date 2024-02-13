//
//  RingView.swift
//  Plutope
//
//  Created by Priyanka Poojara on 17/07/23.
//

import SwiftUI

struct GradientRingView: View {
    @State private var trimValue: CGFloat = 0
    @State private var isRotating = 0.0
    var animation: Animation {
        Animation.easeOut
    }
    let gradientColor: [Color]
    let lineWidth: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.black.opacity(0.1), style: StrokeStyle(lineWidth: lineWidth))
            Circle()
                .trim(from: 0, to: 1)
                .stroke(
                    AngularGradient(gradient: Gradient(colors: gradientColor), center: .center),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [20, 0], dashPhase: 0)
                )
                .padding(10)
        }
        .rotationEffect(.degrees(isRotating))
        .onAppear {
            withAnimation(.linear(duration: 3)
                .repeatForever(autoreverses: false)) {
                    isRotating = 360.0
                }
        }
    }
    
}

struct GradientRingView_Previews: PreviewProvider {
    static var previews: some View {
        GradientRingView(gradientColor: [Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))], lineWidth: 20)
    }
}
