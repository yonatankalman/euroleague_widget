//
//  widget.swift
//  widget
//
//  Created by Yonatan Kalman on 04/11/2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleGameEntry {
        SimpleGameEntry(date: .now, games: TeamGames(
            lastGame: Game(rivalTeamName: "Team A", gameDate: .now, teamScore: 100, versusScore: 0, win: true, confirmedDate: true, isPlayed: true, isHomeGame: false),
            nextGame: Game(rivalTeamName: "Team B", gameDate: .now, teamScore: 100, versusScore: 0, win: true, confirmedDate: true, isPlayed: false, isHomeGame: true)
        ))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleGameEntry) -> ()) {
        let entry = SimpleGameEntry(date: .now, games: TeamGames(
            lastGame: Game(rivalTeamName: "Team A", gameDate: .now, teamScore: 100, versusScore: 0, win: true, confirmedDate: true, isPlayed: true, isHomeGame: false),
            nextGame: Game(rivalTeamName: "Team B", gameDate: .now, teamScore: 100, versusScore: 0, win: true, confirmedDate: true, isPlayed: false, isHomeGame: true  )
        ))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            guard let games = try? await GamesFetcher.fetchGames() else {
                return
            }
            let entry = SimpleGameEntry(date: .now, games: games)
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
}

func formatDate(date: Date)-> String{
    switch true {
    case Calendar.current.isDateInToday(date):
        return "Today"
    case Calendar.current.isDateInTomorrow(date):
        return "Tomorrow"
    default:
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd/MM"
        let weekDay = dateFormatter.string(from: date)
        return weekDay
    }
}

struct widgetEntryView : View {
    var entry: Provider.Entry
    var team: String = "Maccabi Tel Aviv"
    let image = Image("maccabi")
    @Environment(\.widgetFamily) var widgetSize

    var body: some View {
        VStack {
            if (widgetSize != .systemSmall) {
                WidgetHeader(team: team)
            }
            GameEntry(game: entry.games.lastGame)
            Divider().padding(.bottom, 10)
            GameEntry(game: entry.games.nextGame)
        }
        .font(.system(size: 10))
        .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .top)
    }
}

struct widget: Widget {
    let kind: String = "widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                widgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                widgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemMedium) {
    widget()
} timeline: {
    SimpleGameEntry(date: .now, games: TeamGames(
        lastGame: Game(rivalTeamName: "Team A", gameDate: .now, teamScore: 100, versusScore: 0, win: true, confirmedDate: true, isPlayed: true, isHomeGame: true),
        nextGame: Game(rivalTeamName: "Team B", gameDate: .now, teamScore: 100, versusScore: 0, win: true, confirmedDate: true, isPlayed: false, isHomeGame: false)
    ))
}
