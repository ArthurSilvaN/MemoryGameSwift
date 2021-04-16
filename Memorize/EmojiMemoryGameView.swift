//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Arthur on 07/04/21.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    self.viewModel.choose(card: card)
                }
                .padding(5)
            }
                .padding()
                .foregroundColor(Color.orange)
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View{
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    func body(for size: CGSize) -> some View{
            ZStack{
                if card.isFaceUp{
                    RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                    RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
                    Text(card.content)
                }else{
                    if !card.isMatched{
                        RoundedRectangle(cornerRadius: 10.0).fill()
                    }
                }
            }
            .font(Font.system(size: fontSize(for: size)))
    }
    
    //MARK:  - Drawing Constants
    let cornerRadius : CGFloat = 10.0
    let edgeLineWidth : CGFloat = 3
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.75
    }
}














struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
