//
//  ContentView.swift
//  IMakeChess
//
//  Created by Ryan Salsburg on 4/5/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Board(boardViewModel: BoardViewModel())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
