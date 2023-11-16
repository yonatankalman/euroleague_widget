//
//  timeUtils.swift
//  euroleague_widgetExtension
//
//  Created by Yonatan Kalman on 13/11/2023.
//

import Foundation

func getNextUpdateTime (nextGame: Game) -> Date {
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: .now)!
    let nextMidnight = Calendar.current.startOfDay(for: tomorrow)
    let nextGameHalftime = Calendar.current.date(byAdding: .hour, value: 1, to: nextGame.gameDate)!
    let nextGameEndtime = Calendar.current.date(byAdding: .hour, value: 2, to: nextGame.gameDate)!
    let nextGameOvertime = Calendar.current.date(byAdding: .hour, value: 3, to: nextGame.gameDate)!
    
    return [nextMidnight, nextGameHalftime, nextGameEndtime, nextGameOvertime]
        .filter { $0 > .now }
        .min()!
}
