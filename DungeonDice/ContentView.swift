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
    @State private var buttonsLeftOver = 0
    
    let horizontalPadding: CGFloat = 16
    let spacing: CGFloat = 0    // between buttons
    let buttonWidth: CGFloat = 130
    
    var body: some View {
        GeometryReader(content: { geo in
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
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: buttonWidth), spacing: spacing)], content: {
                    ForEach(Dice.allCases.dropLast(buttonsLeftOver), id: \.self) { dice in
                        Button("\(dice.rawValue)-sided") {
                            resultMessage = "You rolled a \(dice.roll()) on a \(dice.rawValue)-sided dice."
                        }
                        .frame(width: buttonWidth)
                    }
                })
                .buttonStyle(.borderedProminent)
                .tint(.red)
                
                HStack {
                    ForEach(Dice.allCases.suffix(buttonsLeftOver), id: \.self) { dice in
                        Button("\(dice.rawValue)-sided") {
                            resultMessage = "You rolled a \(dice.roll()) on a \(dice.rawValue)-sided dice."
                        }
                        .frame(width: buttonWidth)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
            }
            .padding()
            .onChange(of: geo.size.width, { oldValue, newValue in
                arrangeGridItems(geo: geo)
            })
            .onAppear() {
                arrangeGridItems(geo: geo)
            }
        })
    }
    
    func arrangeGridItems(geo: GeometryProxy) {
        var screenWidth = geo.size.width - horizontalPadding * 2    // padding on both side
        if Dice.allCases.count > 1 {
            screenWidth += spacing
        }
        
        // calculate numOfButtonsPerRow
        let numberOfButtonsPerRow = Int(screenWidth) / Int(buttonWidth + spacing)
        buttonsLeftOver = Dice.allCases.count % numberOfButtonsPerRow
    }
    
}

#Preview {
    ContentView()
}
