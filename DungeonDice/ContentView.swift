//
//  ContentView.swift
//  DungeonDice
//
//  Created by Che-lun Hu on 2024/7/23.
//

import SwiftUI

struct ContentView: View {
    enum Dice: Int, CaseIterable {
        case four = 4, six = 6, eight = 8, ten = 10, twelve = 12, twenty = 20, hundred = 100
        
        func roll() -> Int {
            return Int.random(in: 1...self.rawValue)
        }
    }
    
    @State private var resultMessage = ""
    
    var body: some View {
        VStack {
            Text("Dungeon Dice")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundStyle(Color.red)
            
            Spacer()
            
            Text(resultMessage)
                .font(.largeTitle)
                .fontWeight(.medium)
                .frame(height: 150)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], content: {
                ForEach(Dice.allCases, id: \.self) { dice in
                    Button("\(dice.rawValue)-sided") {
                        resultMessage = "You rolled a \(Dice.four.roll()) on a \(Dice.four.rawValue)-sided dice."
                    }
                }
            })
            .buttonStyle(.borderedProminent)
            .tint(.red)
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
