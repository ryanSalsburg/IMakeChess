//
//  Piece.swift
//  IMakeChess
//
//  Created by Ryan Salsburg on 4/5/25.
//

import SwiftUI

protocol Piece: View {
    var isWhite: Bool { get set }
}

extension Piece {
    var colorString: String { isWhite ? "white" : "black"}
}

struct Rook: Piece {
    var isWhite: Bool
    
    var body: some View {
        Image(colorString + "_rook")
    }
}

struct Queen: Piece {
    var isWhite: Bool
    
    var body: some View {
        Image(colorString + "_queen")
    }
}

struct Pawn: Piece {
    var isWhite: Bool
    
    var body: some View {
        Image(colorString + "_pawn")
    }
}

struct Knight: Piece {
    var isWhite: Bool
    
    var body: some View {
        Image(colorString + "_knight")
    }
}

struct King: Piece {
    var isWhite: Bool
    
    var body: some View {
        Image(colorString + "_king")
    }
}

struct Bishop: Piece {
    var isWhite: Bool
    
    var body: some View {
        Image(colorString + "_bishop")
    }
}
