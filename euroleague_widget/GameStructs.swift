//
//  GameStructs.swift
//  euroleague_widgetExtension
//
//  Created by Yonatan Kalman on 09/11/2023.
//

import Foundation

struct Game: Decodable {
    let rivalTeamName: String
    let gameDate: Date
    let teamScore: Int
    let versusScore: Int
    let win: Bool
    let confirmedDate: Bool
    let isPlayed: Bool
}

struct TeamGames: Decodable {
    let lastGame: Game
    let nextGame: Game
}
