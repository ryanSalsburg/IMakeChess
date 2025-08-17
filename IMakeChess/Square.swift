//
//  Square.swift
//  IMakeChess
//
//  Created by Ryan Salsburg on 4/5/25.
//

import SwiftUI

struct Square: View {
    
    let id: Int
    let isSelected: Bool
    let piece: AnyView? // Should Be piece type but couldn't get that working
    let onSelect: (Int) -> Void
        
    var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
                .frame(width: size, height: size)
            if let piece {
                AnyView(piece)
                    .frame(width: pieceSize, height: pieceSize)
            }
        }
        .onTapGesture {
            onSelect(id)
        }
    }
    
    var size: CGFloat {
        Constants.boardWidth / 8
    }
    
    var pieceSize: CGFloat {
        Constants.boardWidth / 12
    }
    
    var color: Color {
        isSelected ? Colors.boardHighlight : isWhite ? Colors.boardWhite : Colors.boardBlack
    }
    
    var isWhite: Bool { (id/8)%2 + id%2 != 1 }
}
