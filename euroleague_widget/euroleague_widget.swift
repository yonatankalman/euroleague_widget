//
//  widget.swift
//  widget
//
//  Created by Yonatan Kalman on 04/11/2023.
//

import WidgetKit
import SwiftUI
import Intents


struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleGameEntry {
        SimpleGameEntry(date: .now, games: TeamGames(
            lastGame: Game(rivalTeamName: "Team A", gameDate: .now, teamScore: 100, versusScore: 0, win: true, confirmedDate: true, isPlayed: true, isHomeGame: false),
            nextGame: Game(rivalTeamName: "Team B", gameDate: .now, teamScore: 100, versusScore: 0, win: true, confirmedDate: true, isPlayed: false, isHomeGame: true)
        ), team: Team.tEL)
    }

    func getSnapshot(
        for configuration: MyTeamConfigurationIntent,
        in context: Context,
        completion: @escaping (SimpleGameEntry) -> ()) {
        let entry = SimpleGameEntry(date: .now, games: TeamGames(
            lastGame: Game(rivalTeamName: "Team A", gameDate: .now, teamScore: 100, versusScore: 0, win: true, confirmedDate: true, isPlayed: true, isHomeGame: false),
            nextGame: Game(rivalTeamName: "Team B", gameDate: .now, teamScore: 100, versusScore: 0, win: true, confirmedDate: true, isPlayed: false, isHomeGame: true  )
        ), team: Team.tEL)
        completion(entry)
    }

    func getTimeline(
        for configuration: MyTeamConfigurationIntent,
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            guard let games = try? await getGames( TEAM_CONFIG[configuration.Team]!["teamCode"]!
            ) else {
                return
            }
            let entry = SimpleGameEntry(date: .now, games: games, team: configuration.Team)
            //TODO: Set next update to when next game ends or daily
            let nextUpdate = Calendar.current.date(
                byAdding: DateComponents(day: 1), to: Date()
            )!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }
}

struct SimpleGameEntry: TimelineEntry {
    let date: Date
    let games: TeamGames
    let team: Team
}

func formatDate(date: Date)-> String{
    switch true {
    case Calendar.current.isDateInToday(date):
        return "Today"
    case Calendar.current.isDateInTomorrow(date):
        return "Tomorrow"
    case Calendar.current.isDateInYesterday(date):
        return "Yesterday"
    default:
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd/MM"
        let weekDay = dateFormatter.string(from: date)
        return weekDay
    }
}

struct widgetEntryView : View {
    var entry: Provider.Entry
    let image = Image("maccabi")
    @Environment(\.widgetFamily) var widgetSize

    var body: some View {
        //TODO: if no team, show "Select Team" screen
        let team = TEAM_CONFIG[entry.team]!
        
        return VStack {
            if (widgetSize != .systemSmall) {
                WidgetHeader(teamName: team["name"]!, teamIcon: team["teamIcon"]!)
            }
            GameEntry(game: entry.games.lastGame)
            Divider().padding(.bottom, 10)
            GameEntry(game: entry.games.nextGame)
        }
        .font(.system(size: 10))
        .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .top)
        .padding(.bottom, 10)
    }
}

struct widget: Widget {
    let kind: String = "widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: MyTeamConfigurationIntent.self,
            provider: Provider()
        ) { entry in
            if #available(iOS 17.0, *) {
                widgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                widgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
    }
}

#Preview(as: .systemMedium) {
    widget()
} timeline: {
    SimpleGameEntry(date: .now, games: TeamGames(
        lastGame: Game(rivalTeamName: "Team A", gameDate: .now, teamScore: 100, versusScore: 0, win: true, confirmedDate: true, isPlayed: true, isHomeGame: true),
        nextGame: Game(rivalTeamName: "Team B", gameDate: .now, teamScore: 100, versusScore: 0, win: true, confirmedDate: true, isPlayed: false, isHomeGame: false)
    ), team: Team.tEL)
}
