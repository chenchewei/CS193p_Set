//
//  SetGameModel.swift
//  Set
//
//  Created by Anderson Chen on 2022/7/14.
//

import Foundation

/// Model [ Must be UI-independent ]

struct SetGameModel<CardSymbolShape, CardSymbolColor, CardSymbolPattern, NumberOfShapes> where CardSymbolShape: Hashable, CardSymbolColor: Hashable, CardSymbolPattern: Hashable {
    private(set) var isGameOver: Bool = false   // isEndOfGame
    private(set) var score: Int = 0
    /// 牌堆總共有幾張牌
    private(set) var totalCards: Int
    /// 已經發出去的牌
    private(set) var numberOfPlayedCards: Int = 0
    /// 一次總共要顯示幾張牌
    private(set) var displayCardCount: Int          // initialNumberOfPlayingCards
    /// 正在顯示給使用者看的卡牌
    private(set) var playingCards: Array<Card>
    /// 剩餘卡牌
    private(set) var remainingCards: Array<Card>?
    /// 計算額外獎勵分數用的時間戳記
    private(set) var timeStamp: Date = Date()
    
    private var selectedCards: Array<Card> = [] // chosenCards
    /// 建置卡牌的內容
    private let createCardContent: (Int) -> Card.CardContent
    
    struct Card: Identifiable, Equatable {
        let id: Int
        var isSelected: Bool = false
        var isMatched: Bool = false
        var matchFailed: Bool = false
        let content: CardContent
        
        struct CardContent {
            let shape: CardSymbolShape
            let color: CardSymbolColor
            let pattern: CardSymbolPattern
            let numberOfShapes: Int
        }
        
        static func == (lhs: SetGameModel<CardSymbolShape, CardSymbolColor, CardSymbolPattern, NumberOfShapes>.Card, rhs: SetGameModel<CardSymbolShape, CardSymbolColor, CardSymbolPattern, NumberOfShapes>.Card) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    init(displayCardCount: Int, totalCards: Int, createCardContent: @escaping (Int) -> Card.CardContent) {
        self.displayCardCount = displayCardCount
        self.totalCards = totalCards
        self.createCardContent = createCardContent
        playingCards = []
        
        for index in 0..<displayCardCount {
            let content = createCardContent(numberOfPlayedCards)
            playingCards.append(Card(id: index, content: content))
            numberOfPlayedCards = index
        }
    }
    
    mutating func choose(_ card: Card) {
        if let index = playingCards.firstIndex(where: { $0.id == card.id }) {
            if playingCards[index].isSelected {
                // 已經選過了，取消選擇
                selectedCards.remove(at: selectedCards.firstIndex(of: card) ?? 0)
            } else {
                selectedCards.append(playingCards[index])
                
                // 選了三張牌
                if selectedCards.count > 2 {
                    let newTime = Date()
                    let timeSpent = Int(newTime.timeIntervalSince(timeStamp))
                    // 判斷是否能夠組成Set
                    if isSetValid(selectedCards) {
                        score += max(20 - timeSpent, 1) * 2
                        
                        selectedCards.forEach { card in
                            guard let index = playingCards.firstIndex(of: card) else { return }
                            playingCards[index].isMatched = true
                        }
                        
                        if numberOfPlayedCards == totalCards {
                            isGameOver = isGameOver(playingCards)
                        }
                    } else {
                        score -= max(20 - timeSpent, 1) * 2
                        selectedCards.forEach { card in
                            guard let index = playingCards.firstIndex(of: card) else { return }
                            playingCards[index].matchFailed = true
                        }
                    }
                    timeStamp = newTime
                }
            }
            playingCards[index].isSelected.toggle()
        }
    }
    /// 提示還有可以配對的Set
    mutating func showAlert() {
        // TODO: Alert
        // 點發牌後先跳showalert
        // 確定後才發牌並扣分
    }
    
    mutating func dealCards() {
        if remainingCards != nil { score -= 3 }
        
        switch selectedCards.count {
        case 3:
            // 選到最後一組，要發新的
            if let card = playingCards.first(where: { $0 == selectedCards.first }) {
                resetSelectedCards()
                if !card.isMatched { fallthrough }
            }
        default:
            for _ in 0..<3 {
                dealOneCard(to: playingCards.endIndex)
            }
        }
        
        guard numberOfPlayedCards == totalCards else { return }
        isGameOver = isGameOver(playingCards)
    }
    
    mutating func dealOneCard(to index: Int) {
        guard numberOfPlayedCards < totalCards else { return }
        let content = createCardContent(numberOfPlayedCards)
        playingCards.insert(Card(id: numberOfPlayedCards, content: content), at: index)
        numberOfPlayedCards += 1
    }
    
    mutating func resetSelectedCards() {
        selectedCards.forEach { card in
            if let index = playingCards.firstIndex(of: card) {
                playingCards[index].matchFailed = false
                playingCards[index].isSelected = false
            }
        }
    }
    
    mutating func getRemainingSets(in cards: [Card]) -> [Card]? {
        guard !cards.isEmpty else { return nil }
        let cardsCount: Int = cards.count
        // TODO: 這裡怪怪的
        for i in 0..<cardsCount - 2 {
            for j in (i + 1)..<cardsCount - 1 {
                for k in (j + 1)..<cardsCount where isSetValid([cards[i], cards[j], cards[k]]) {
                    return [cards[i], cards[j], cards[k]]
                }
            }
        }
        return nil
    }
    
    /// 確認選中的三張牌是否可以消除
    mutating func isSetValid(_ cards: [Card]) -> Bool {
        var shapes = Set<CardSymbolShape>()
        var patterns = Set<CardSymbolPattern>()
        var colors = Set<CardSymbolColor>()
        var numberOfShapes = Set<Int>()
        
        cards.forEach { card in
            shapes.insert(card.content.shape)
            patterns.insert(card.content.pattern)
            colors.insert(card.content.color)
            numberOfShapes.insert(card.content.numberOfShapes)
        }
        
        return !(shapes.count == 2 || colors.count == 2 || patterns.count == 2 || numberOfShapes.count == 2)
    }
    
    mutating func isGameOver(_ playingCards: [Card]) -> Bool {
        var cards = playingCards
        
        if selectedCards.count > 2 {
            selectedCards.forEach { card in
                guard let matchedIndex = cards.firstIndex(of: card) else { return }
                cards.remove(at: matchedIndex)
            }
        }
        
        return getRemainingSets(in: cards) == nil
    }
    
}
