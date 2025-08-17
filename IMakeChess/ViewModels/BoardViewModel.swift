//
//  BoardViewModel.swift
//  IMakeChess
//
//  Created by Ryan Salsburg on 4/5/25.
//

import Foundation

class BoardViewModel: ObservableObject {
        
    var board: [[PieceType?]] = []
    
    var isWhitesTurn = true
    
    var putsKingInCheck: Bool = false
    
    init() {
        for row in 0..<8 {
            var rowSetup: [PieceType?] = []
            for col in 0..<8{
                rowSetup.append(initialSetupForSquare(row: row, column: col))
            }
            board.append(rowSetup)
        }
    }
    
    func pieceOnSquare(row: Int, column: Int) -> PieceType? {
        guard board.count > row, board[row].count > column else { return nil }
        return board[row][column]
    }
    
    func initialSetupForSquare(row: Int, column: Int) -> PieceType? {
        if row == 1 {
            return .pawn(false)
        } else if row == 6 {
            return .pawn(true)
        } else if row == 0 {
            if column == 0 || column == 7 {
                return .rook(false)
            } else if column == 1 || column == 6 {
                return .knight(false)
            } else if column == 2 || column == 5 {
                return .bishop(false)
            } else if column == 3 {
                return .queen(false)
            } else {
                return .king(false)
            }
        } else if row == 7 {
            if column == 0 || column == 7 {
                return .rook(true)
            } else if column == 1 || column == 6 {
                return .knight(true)
            } else if column == 2 || column == 5 {
                return .bishop(true)
            } else if column == 3 {
                return .queen(true)
            } else {
                return .king(true)
            }
        }
        return nil
    }
    
    func getRowAndColumnFromId(_ id: Int) -> (row: Int, column: Int) {
        (row: id / 8, column: id % 8)
    }
    
    func getIdFromRowAndColumn(row: Int, column: Int) -> Int {
        row * 8 + column
        
    }
    
    /// - Returns: true if successful move
    func move(square: Int, to newSquare: Int, isHypothetical: Bool = false) -> Bool {
        let squareCoordinates = getRowAndColumnFromId(square)
        let newSquareCoordinates = getRowAndColumnFromId(newSquare)
        
        if let piece = board[squareCoordinates.row][squareCoordinates.column], piece.isWhite == isWhitesTurn || isHypothetical {
            
            switch piece {
            case .pawn(let isWhite):
                if isWhite {
                    // Initial position 2 out move
                    if squareCoordinates.row == 6 && newSquareCoordinates.row == 4 && squareCoordinates.column == newSquareCoordinates.column {
                        if board[newSquareCoordinates.row][newSquareCoordinates.column] != nil ||
                            board[newSquareCoordinates.row + 1][newSquareCoordinates.column] != nil {
                            return false
                        } else {
                            return finalCheck(piece: piece)
                        }
                        // after first move
                    } else if squareCoordinates.row - 1 == newSquareCoordinates.row && squareCoordinates.column == newSquareCoordinates.column {
                        if board[newSquareCoordinates.row][newSquareCoordinates.column] != nil {
                            return false
                        } else {
                            return finalCheck(piece: piece)
                        }
                    } else if abs(squareCoordinates.column - newSquareCoordinates.column) == 1
                                && newSquareCoordinates.row == squareCoordinates.row - 1
                                && board[newSquareCoordinates.row][newSquareCoordinates.column]?.isWhite == false {
                        return finalCheck(piece: piece)
                    } else {
                        return false
                    }
                } else {
                    // Initial position 2 out move
                    if squareCoordinates.row == 1 && newSquareCoordinates.row == 3 && squareCoordinates.column == newSquareCoordinates.column {
                        if board[newSquareCoordinates.row][newSquareCoordinates.column] != nil ||
                            board[newSquareCoordinates.row - 1][newSquareCoordinates.column] != nil {
                            return false
                        } else {

                            return finalCheck(piece: piece)
                        }
                        // after first move
                    } else if squareCoordinates.row + 1 == newSquareCoordinates.row && squareCoordinates.column == newSquareCoordinates.column {
                        if board[newSquareCoordinates.row][newSquareCoordinates.column] != nil {
                            return false
                        } else {
                            return finalCheck(piece: piece)
                        }
                    } else if abs(squareCoordinates.column - newSquareCoordinates.column) == 1
                                && newSquareCoordinates.row == squareCoordinates.row + 1
                                && board[newSquareCoordinates.row][newSquareCoordinates.column]?.isWhite == true {

                        return finalCheck(piece: piece)
                    } else {
                        return false
                    }
                }
            case .rook:
                if newSquareCoordinates.row == squareCoordinates.row || newSquareCoordinates.column == squareCoordinates.column{
                    
                    return finalCheck(piece: piece)
                } else {
                    return false
                }
            case .king:
                // TODO: Castling
                if abs(newSquareCoordinates.row - squareCoordinates.row) <= 1 && abs(newSquareCoordinates.column - squareCoordinates.column) <= 1 {
                    return finalCheck(piece: piece)
                } else {
                    return false
                }
            case .bishop:
                if abs(newSquareCoordinates.row - squareCoordinates.row) == abs(newSquareCoordinates.column - squareCoordinates.column) {
                    return finalCheck(piece: piece)
                } else {
                    return false
                }
            case .queen:
                if abs(newSquareCoordinates.row - squareCoordinates.row) == abs(newSquareCoordinates.column - squareCoordinates.column) ||
                    newSquareCoordinates.row == squareCoordinates.row || newSquareCoordinates.column == squareCoordinates.column {
                    return finalCheck(piece: piece)
                } else {
                    return false
                }
            case .knight:
                if abs(newSquareCoordinates.row - squareCoordinates.row) + abs(newSquareCoordinates.column - squareCoordinates.column) == 3,
                   newSquareCoordinates.row != squareCoordinates.row, newSquareCoordinates.column != squareCoordinates.column {
                    return finalCheck(piece: piece)
                    
                } else {
                    return false
                }
            }
            
        }
        return false
        
        func finalCheck(piece: PieceType) -> Bool { // TODO: Check for mate
            if case .knight = piece { }
            else {
                guard noneBetween(squareCoordinates: squareCoordinates, newSquareCoordinates: newSquareCoordinates) else {
                    return false
                }
            }
            
            if let locationPiece = board[newSquareCoordinates.row][newSquareCoordinates.column] {
                if locationPiece.isWhite != piece.isWhite {
                    if !isHypothetical {
                        board[newSquareCoordinates.row][newSquareCoordinates.column] = piece
                        board[squareCoordinates.row][squareCoordinates.column] = nil
                        if isKingInCheck(whiteKing: isWhitesTurn) {
                            board[newSquareCoordinates.row][newSquareCoordinates.column] = locationPiece
                            board[squareCoordinates.row][squareCoordinates.column] = piece
                            return false
                        } else {
                            if isKingInCheck(whiteKing: !isWhitesTurn) {
                                putsKingInCheck = true
                            } else {
                                putsKingInCheck = false
                            }
                            isWhitesTurn = !isWhitesTurn
                        }
                    }
                    return true
                }
            } else {
                if !isHypothetical {
                    board[newSquareCoordinates.row][newSquareCoordinates.column] = piece
                    board[squareCoordinates.row][squareCoordinates.column] = nil
                    if isKingInCheck(whiteKing: isWhitesTurn) {
                        board[newSquareCoordinates.row][newSquareCoordinates.column] = nil
                        board[squareCoordinates.row][squareCoordinates.column] = piece
                        return false
                    } else {
                        if isKingInCheck(whiteKing: !isWhitesTurn) {
                            putsKingInCheck = true
                        } else {
                            putsKingInCheck = false
                        }
                        isWhitesTurn = !isWhitesTurn
                    }
                }
                return true
            }
            return false
        }
    }
    
    func noneBetween(squareCoordinates: (row: Int, column: Int), newSquareCoordinates: (row: Int, column: Int)) -> Bool {
        // create function for pieces to check
        guard abs(squareCoordinates.row - newSquareCoordinates.row) > 1 || abs(squareCoordinates.column - newSquareCoordinates.column) > 1 else {
            return true
        }
        
        let yChange = squareCoordinates.row > newSquareCoordinates.row ? -1 : squareCoordinates.row == newSquareCoordinates.row ? 0 : 1
        
        let xChange = squareCoordinates.column > newSquareCoordinates.column ? -1 : squareCoordinates.column == newSquareCoordinates.column ? 0 : 1
        
        for check in 1..<(yChange != 0 ? abs(squareCoordinates.row - newSquareCoordinates.row) : abs(squareCoordinates.column - newSquareCoordinates.column))  {
            if board[squareCoordinates.row + check * yChange][squareCoordinates.column + check * xChange] != nil {
                return false
            }
        }
        
        return true
    }
    
    func isKingInCheck(whiteKing: Bool) -> Bool {
        var kingCoordinates: (row: Int, column: Int)?
        for row in 0..<8 {
            for col in 0..<8{
                if case .king(let isWhite) = board[row][col], isWhite == whiteKing {
                    kingCoordinates = (row: row, column: col)
                }
            }
        }
        
        guard let kingCoordinates else { return false }
        
        for row in 0..<8 {
            for col in 0..<8{
                if let piece = board[row][col], piece.isWhite != whiteKing {
                    if move(square: getIdFromRowAndColumn(row: row, column: col),
                            to: getIdFromRowAndColumn(row: kingCoordinates.row, column: kingCoordinates.column),
                            isHypothetical: true) {
                        return true
                    }
                }
            }
        }
        return false
    }
}


enum PieceType {
    case pawn(Bool)
    case rook(Bool)
    case knight(Bool)
    case bishop(Bool)
    case queen(Bool)
    case king(Bool)
    
    var isWhite: Bool {
        switch self {
        case .pawn(let isWhite), .rook(let isWhite), .queen(let isWhite), .knight(let isWhite), .king(let isWhite), .bishop(let isWhite):
            return isWhite
        }
    }
}
