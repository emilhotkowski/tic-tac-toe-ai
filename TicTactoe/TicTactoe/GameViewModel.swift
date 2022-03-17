//
//  GameViewModel.swift
//  TicTactoe
//
//  Created by Emil Hotkowski on 17/03/2022.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisabled = false
    @Published var alertItem: AlertItem?
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        let winPatterns: Set<Set<Int>> = [
            [0,1,2], [3,4,5], [6,7,8],
            [0,3,6], [1,4,7], [2,5,8],
            [0,4,8], [2,4,6]
        ]
        // MARK: If AI can win, then win
        let computerMoves = moves.compactMap { $0 }.filter{ $0.player == .computer }
        let computerPositions = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        // MARK: If can't win, block
        let humanMoves = moves.compactMap { $0 }.filter{ $0.player == .human }
        let humanPositions = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        // MARK: Take middle if possible
        let middleSquare = 4
        if !isSquareOccupied(in: moves, forIndex: middleSquare) { return middleSquare }
    
        // MARK: Random as last step
        var movePosition: Int = .random(in: 0..<9)
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = determineComputerMovePosition(in: moves)
        }
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [
            [0,1,2], [3,4,5], [6,7,8],
            [0,3,6], [1,4,7], [2,5,8],
            [0,4,8], [2,4,6]
        ]
        let playerMoves = moves.compactMap { $0 }.filter{ $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        
        return winPatterns.map { $0.isSubset(of: playerPositions) }.contains(true)
    }
    
    func checkForDrawInMoves(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
        isGameboardDisabled = false
    }
    
    func processMove(for i: Int) {
        if(!isSquareOccupied(in: moves, forIndex: i)) {
            moves[i] = Move(player: .human, boardIndex: i)
            isGameboardDisabled.toggle()
            
            // MARK: Check if win
            if checkWinCondition(for: .human, in: moves) {
                alertItem = AlertContext.humanWin
            } else if checkForDrawInMoves(in: moves) {
                alertItem = AlertContext.draw
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                    let pos = determineComputerMovePosition(in: moves)
                    moves[pos] = Move(player: .computer, boardIndex: pos)
                    isGameboardDisabled.toggle()
                    if checkWinCondition(for: .computer, in: moves) {
                        alertItem = AlertContext.computerWin
                    } else if checkForDrawInMoves(in: moves) {
                        alertItem = AlertContext.draw
                    }
                }
            }
        }
    }
    
}
