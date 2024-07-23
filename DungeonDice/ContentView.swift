//
//  ContentView.swift
//  DungeonDice
//
//  Created by Che-lun Hu on 2024/7/23.
//

import SwiftUI

struct ContentView: View {
    @State private var resultMessage = ""
    
    var body: some View {
        VStack {
            titleView
            
            Spacer()
            
            resultMessageView
            
            Spacer()
            
            ButtonLayout(resultMessage: $resultMessage)
        }
        .padding()
    }
    
    
}

extension ContentView {
    // Since we won't use these variables in any structs other than ContentView,
    // it's always a good idea to put private in front of the var keyword
    // Therefore, these variable can only be access in ContentView
    private var titleView: some View {
        Text("Dungeon Dice")
            .font(.largeTitle)
            .fontWeight(.black)
            .foregroundStyle(Color.red)
    }
    
    private var resultMessageView: some View {
        Text(resultMessage)
            .font(.largeTitle)
            .fontWeight(.medium)
            .frame(height: 150)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    ContentView()
}
