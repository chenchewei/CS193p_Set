//
//  CardView.swift
//  Set
//
//  Created by Anderson Chen on 2022/7/14.
//

import SwiftUI

struct CardView: View {
    
    let card: SetGame.Card
    // TODO: fix
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Text("card.content")
//                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1.3).repeatForever(autoreverses: false), value: UUID())
                // deprecated
//                    .animation(Animation.linear(duration: 1.3).repeatForever(autoreverses: false))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        return min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private func font(in size: CGSize) -> Font {
        return Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let matchedOpacity: Double = 0
        static let fontScale: CGFloat = 0.75
        static let fontSize: CGFloat = 32
        static let piePadding: CGFloat = 4
        static let pieOpacity: Double = 0.4
    }
}
