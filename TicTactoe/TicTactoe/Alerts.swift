//
//  Alerts.swift
//  TicTactoe
//
//  Created by Emil Hotkowski on 17/03/2022.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
    
}

struct AlertContext {
    static let humanWin        = AlertItem(title: Text("You Win!"), message: Text("You are so smart!"), buttonTitle: Text("Hell yeah!"))
    static let computerWin     = AlertItem(title: Text("You Lost!"), message: Text("You programed a super AI!"), buttonTitle: Text("Rematch"))
    static let draw            = AlertItem(title: Text("Draw!"), message: Text("What a battle of wits..."), buttonTitle: Text("Try again"))
    
}
