//
//  gamesFetcher.swift
//  Euroleague Widget
//
//  Created by Yonatan Kalman on 04/11/2023.
//

import Foundation
import SwiftyXMLParser

private func parseDate (dateStr: String) -> Date {
    let df = DateFormatter()
    df.locale = Locale(identifier: "en_US_POSIX")
    df.dateFormat = "MM/dd/yyyy hh:mm:ss a"
    return df.date(from: dateStr)!
}

private func createGame (game: SwiftyXMLParser.XML.Accessor) -> Game? {
    let isHomeGame = game.attributes["versustype"] == "vs"
    return Game(
        rivalTeamName: game.attributes["versus"]!,
        gameDate: parseDate(dateStr: game.attributes["gamedate"]!),
        teamScore: Int(game.attributes[isHomeGame ? "standingslocalscore" : "standingsroadscore"]!)!,
        versusScore: Int(game.attributes[isHomeGame ? "standingsroadscore" : "standingslocalscore"]!)!,
        win: game.attributes["win"] == "1",
        confirmedDate: game.attributes["confirmeddate"] == "true",
        isPlayed: game.attributes["played"] == "true",
        isHomeGame: isHomeGame
    )
}

private func fetchGames (teamCode: String) async throws -> TeamGames? {
    print("Hello World")
    let url = URL(string: "https://api-live.euroleague.net/v1/teams?seasonCode=E\(Calendar.current.component(.year, from: Date()))")!
    let (xmlString, _) = try await URLSession.shared.data(from: url)
    let xml = XML.parse(xmlString)
    if let club = xml.clubs.club.first(where: {
        $0.attributes["code"] == teamCode
    }){
        let games = club.games
        let playedGames = games.phase.game
            .filter { game in
                return game.attributes["played"] == "true"
            }.map { game in
                return createGame(game: game)
            }
        let futureGames = games.phase.game
            .filter { game in
                return game.attributes["played"] == "false"
            }.map { game in
                return createGame(game: game)
            }

        let lastGame = playedGames
            .sorted(by: {$0!.gameDate < $1!.gameDate}).last!
        let nextGame = futureGames
            .filter{game in
                return game!.confirmedDate
            }
            .sorted(by: {$0!.gameDate < $1!.gameDate}).first!
        return TeamGames(lastGame: lastGame!, nextGame: nextGame!)
    } else {
        print("failed to find team")
        return nil
    }
}

let getGames = memoizeWithMaxAge(fetchGames, maxAgeInSeconds: 60 * 60)
