//
//  Constants.swift
//  IMakeChess
//
//  Created by Ryan Salsburg on 4/5/25.
//

import SwiftUI

struct Constants {
    static var boardWidth: CGFloat {
        UIScreen.main.bounds.width * 0.9
    }
}

struct Colors {
    static let boardBlack = Color(red: 118/255, green: 150/255, blue: 86/255)
    static let boardWhite = Color(red: 238/255, green: 238/255, blue: 210/255)
    
    static let boardHighlight = Color(red: 186/255, green: 202/255, blue: 68/255)
}
