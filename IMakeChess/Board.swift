//
//  Board.swift
//  IMakeChess
//
//  Created by Ryan Salsburg on 4/5/25.
//

import SwiftUI

struct Board: View {
    
    @StateObject var boardViewModel: BoardViewModel
    @State var selectedId: Int?
    
    var body: some View {
        VStack {
            Text("Chess")
                .font(.title)
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .cornerRadius(20)
                .background(Colors.boardBlack)
            if boardViewModel.putsKingInCheck {
                Text("Check")
                    .font(.headline)
            }
            VStack(spacing: 0) {
                ForEach(0..<8) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<8) { col in
                            Square(id: row * 8 + col, isSelected: selectedId == row * 8 + col, piece: getPiece(row: row, column: col)) { id in
                                guard let selectedId else {
                                    selectedId = id
                                    return
                                }
                                if boardViewModel.move(square: selectedId, to: id) {
                                    self.selectedId = nil
                                } else {
                                    self.selectedId = id
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getPiece(row: Int, column: Int) -> AnyView? {
        let piece = boardViewModel.pieceOnSquare(row: row, column: column)
        switch piece {
        case .king(let isWhite):
            return AnyView(King(isWhite: isWhite))
        case .knight(let isWhite):
            return AnyView(Knight(isWhite: isWhite))
        case .queen(let isWhite):
            return AnyView(Queen(isWhite: isWhite))
        case .bishop(let isWhite):
            return AnyView(Bishop(isWhite: isWhite))
        case .rook(let isWhite):
            return AnyView(Rook(isWhite: isWhite))
        case .pawn(let isWhite):
            return AnyView(Pawn(isWhite: isWhite))
        case .none:
            return nil
        }
    }
}
