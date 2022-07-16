//
//  SetGame.swift
//  Set
//
//  Created by Anderson Chen on 2022/7/15.
//

/// ViewModel

import SwiftUI

class SetGame: ObservableObject {
    typealias Card = SetGameModel<ContentShape, ContentColor, ContentPattern, ContentNumber>.Card
    
    @Published private var model = createGame()
    
    var cards: [Card] {
        model.playingCards
    }
    
    var numberOfPlayedCards: Int {
        model.numberOfPlayedCards
    }
    
    var totalCards: Int {
        model.totalCards
    }
    
    var isGameOver: Bool {
        model.isGameOver
    }
    
    var score: Int {
        model.score
    }
    
    /// 創建新的遊戲
    static private func createGame() -> SetGameModel<ContentShape, ContentColor, ContentPattern, ContentNumber> {
        return SetGameModel(displayCardCount: 12, totalCards: cardContent.count) { cardContent[$0] }
    }

    static var cardContent: [Card.CardContent] = {
        var contents: [Card.CardContent] = []
        // 9 cards in the deck
        for shape in ContentShape.allCases {
            for color in ContentColor.allCases {
                contents.append(Card.CardContent(shape: shape, color: color, pattern: ContentPattern.solid, numberOfShapes: ContentNumber.one.rawValue))
            }
        }
        // 27 cards in the deck
//        for shape in ContentShape.allCases {
//            for color in ContentColor.allCases {
//                for pattern in ContentPattern.allCases {
//                    contents.append(Card.CardContent(shape: shape, color: color, pattern: pattern, numberOfShapes: ContentNumber.one.rawValue))
//                }
//            }
//        }
        // 81 cards in the deck
//        for shape in ContentShape.allCases {
//            for color in ContentColor.allCases {
//                for pattern in ContentPattern.allCases {
//                    for number in ContentNumber.allCases {
//                        contents.append(Card.CardContent(shape: shape, color: color, pattern: pattern, numberOfShapes: number.rawValue))
//                    }
//                }
//            }
//        }
        
        return contents.shuffled()
    }()
    
    // MARK: - Intents
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func dealCards() {
        model.dealCards()
    }
    
    
    // MARK: Enums -
    enum ContentShape: CaseIterable {
        case diamond            // 菱形
        case squiggle           // 波浪
        case oval               // 橢圓
    }
    
    enum ContentColor: CaseIterable {
        case red
        case green
        case purple
        
        /// 轉換列舉的項目為可以使用的顏色
        func getColor() -> Color {
            switch self {
            case .red:
                return .red
            case .green:
                return .green
            case .purple:
                return .purple
            }
        }
    }
    
    enum ContentPattern: CaseIterable {
        case solid      // 實心
        case striped    // 條紋
        case open       // 空心
    }
    
    enum ContentNumber: Int, CaseIterable {
        case one = 1
        case two = 2
        case three = 3
    }
}
