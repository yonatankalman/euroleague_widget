//
//  GameStructs.swift
//  euroleague_widgetExtension
//
//  Created by Yonatan Kalman on 09/11/2023.
//

import Foundation
import SwiftUI

struct Game: Decodable {
    let rivalTeamName: String
    let gameDate: Date
    let teamScore: Int
    let versusScore: Int
    let win: Bool
    let confirmedDate: Bool
    let isPlayed: Bool
    let isHomeGame: Bool
}

struct TeamGames: Decodable {
    let lastGame: Game
    let nextGame: Game
}

struct GameEntry : View {
    let game: Game
    
    var body: some View {
        return HStack {
            VStack(alignment: .leading) {
                HStack (alignment: .top) {
                    Text(game.isPlayed ? "Previous:" : "Next:").frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 5)
                        .foregroundStyle(.gray)
                    Text(formatDate(date:game.gameDate))
                }
                HStack {
                    HStack{
                        Image(systemName: game.isHomeGame ? "house.fill" : "airplane")
                        Text(game.rivalTeamName)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    }
                    if (game.isPlayed) {
                        Text(" \(game.teamScore) - \(game.versusScore) ")
                        Text(game.win ? " W " : " L ")
                            .foregroundStyle(.black)
                            .background(
                                game.win
                                ? Color(red: 90/255, green: 179/255, blue: 121/255)
                                : .red
                            )
                            .clipShape(.rect(cornerRadius: 10))
                    } else {
                        Text(
                            game.gameDate.formatted(.dateTime.hour(.twoDigits(amPM:.omitted)).minute()))
                    }
                }
            }
        }
        .padding(.bottom, 10)
        .fontWeight(.semibold)
        .font(.system(size: 11))
    }
}
