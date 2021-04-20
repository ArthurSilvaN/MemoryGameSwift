//
//  MemoryGame.swift
//  Memorize
//
//  Created by Arthur Nunes on 08/04/21.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable{
    private(set) var cards: Array<Card>
    
    var indexOfTheAddOnlyFaceUpCard: Int? {
        get {
            var faceUpCardIndices = [Int]()
                for index in cards.indices {
                    if cards[index].isFaceUp{
                        faceUpCardIndices.append(index)
                    }
                }
                if faceUpCardIndices.count == 1{
                    return faceUpCardIndices.first
                }else{
                    return nil
                }
            }
        set{
            for index in cards.indices{
                if index == newValue{
                    cards[index].isFaceUp = true
                }else{
                    cards[index].isFaceUp = false
                }
            }
        }
    }

    mutating func choose(card : Card ){
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched{
            if let potentialMatchIndex = indexOfTheAddOnlyFaceUpCard{
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                self.cards[chosenIndex].isFaceUp = true
            }else{
                indexOfTheAddOnlyFaceUpCard = chosenIndex
            }
    }
}
    
    func index(of card : Card) -> Int{
        for index in 0..<self.cards.count{
            if self.cards[index].id == card.id{
                return index
            }
        }
        return 0 //TODO: bogus!
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(isFaceUp: false, isMatched: false, content: content, id: pairIndex*2))
            cards.append(Card(isFaceUp: false, isMatched: false, content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false{
            didSet{
                if isFaceUp{
                    startingUsingBonusTime()
                }else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false {
            didSet{
                stopUsingBonusTime()
            }
        }
        var content: CardContent
        var id: Int

        
        
        
        
        
        
        //MARK: - Bonus Time

        var bonusTimeLimit: TimeInterval = 6

        var lastFaceUpDate: Date?
            
        var pastFaceUpTime: TimeInterval = 0

        private var faceUpTime: TimeInterval{
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            }else{
                return pastFaceUpTime
            }
        }

        var bonusTimeRemaining: TimeInterval{
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        var BonusRemaining: Double{
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }
        
        var hasEarnedBonus: Bool{
            isMatched && bonusTimeRemaining > 0
        }
        
        var isConsumingBonusTime: Bool{
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        private mutating func startingUsingBonusTime(){
            if isConsumingBonusTime, lastFaceUpDate == nil{
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBonusTime(){
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}
