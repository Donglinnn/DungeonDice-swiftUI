//
//  ButtonLayout.swift
//  DungeonDice
//
//  Created by Che-lun Hu on 2024/7/23.
//

import SwiftUI

struct ButtonLayout: View {
    enum Dice: Int, CaseIterable {
        case four = 4, six = 6, eight = 8, ten = 10, twelve = 12, twenty = 20, hundred = 100
        
        func roll() -> Int {
            return Int.random(in: 1...self.rawValue)
        }
    }
    
    // A preference key struct which we'll use to pass values up frome child to parent View
    // When we conform to a protocol by putting the protocol after a colon, we tell Swift we are going to follow the rules that are defined by that protocol. SwiftUI will usually offer to fix code that doesn't follow the rules of the protocol.
    struct DeviceWidthPreferenceKey: PreferenceKey {
        
        // values marked as static can be used just by referring to the Type. We don't need to create an instance of a type(e.g. declare and initialize a variable of that type) before using something that is static.
        static var defaultValue: CGFloat = 0
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
        
        typealias Value = CGFloat
    }
    
    @State private var buttonsLeftOver = 0
    @Binding var resultMessage: String  // Declare and update the value in parent view,
    // then pass it to child view
    
    let horizontalPadding: CGFloat = 16
    let spacing: CGFloat = 0    // between buttons
    let buttonWidth: CGFloat = 102
    
    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: buttonWidth), spacing: spacing)], content: {
                // dropLast(n): 把最後n個case抓出來
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
                // suffix(n): 最後n個
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
        .overlay {
            // We need to use Preference Keys to get a value
            // from child view and pass it up to the parent view
            // Three steps for Preference Keys:
            // - Set up a struct conforming to the PreferenceKey protocol.
            // PreferenceKey protocol says - 1. we need to declare & initialize a defaultValue
            // - 2. we need to use a special reduce function
            //      struct DeviceWidthPreferenceKey: PreferenceKey { ...
            // - Use a .preference modifier in the child to get a value for your Preference Key
            //      .preference(key: DeviceWidthPreferenceKey.self, value: geo.size.width)
            // - Use an .onPreferenceChange modifier up the hierarchy to react when the PreferenceKey has changed
            //      .onPreferenceChange(DeviceWidthPreferenceKey.self) {...
            GeometryReader(content: { geo in
                Color.clear
                    .preference(key: DeviceWidthPreferenceKey.self, value: geo.size.width)
            })
        }
        .onPreferenceChange(DeviceWidthPreferenceKey.self, perform: { deviceWidth in
            arrangeGridItems(deviceWidth: deviceWidth)
        })
    }
    
    func arrangeGridItems(deviceWidth: CGFloat) {
        var screenWidth = deviceWidth - horizontalPadding * 2    // padding on both side
        if Dice.allCases.count > 1 {
            screenWidth += spacing
        }
        
        // calculate numOfButtonsPerRow
        let numberOfButtonsPerRow = Int(screenWidth) / Int(buttonWidth + spacing)
        buttonsLeftOver = Dice.allCases.count % numberOfButtonsPerRow
    }
}

#Preview {
    ButtonLayout(resultMessage: .constant(""))
}
