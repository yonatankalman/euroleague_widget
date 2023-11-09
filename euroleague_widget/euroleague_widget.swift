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
            lastGame: Game(rivalTeamName: "Team A", gameDate: .now, teamScore: 100, versusScore: 0, win: true, confirmedDate: true, isPlayed: true),
            nextGame: Game(rivalTeamName: "Team B", gameDate: .now, teamScore: 100, versusScore: 0, win: true, confirmedDate: true, isPlayed: false)
        ))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleGameEntry) -> ()) {
        let entry = SimpleGameEntry(date: .now, games: TeamGames(
            lastGame: Game(rivalTeamName: "Team A", gameDate: .now, teamScore: 100, versusScore: 0, win: true, confirmedDate: true, isPlayed: true),
            nextGame: Game(rivalTeamName: "Team B", gameDate: .now, teamScore: 100, versusScore: 0, win: true, confirmedDate: true, isPlayed: false  )
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

struct GameEntry : View {
    let game: Game
    
    var body: some View {
        return HStack {
            VStack(alignment: .leading) {
                HStack (alignment: .top) {
                    Text(game.isPlayed ? "Previous:" : "Next:").frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 5)
                    Text(formatDate(date:game.gameDate))
                }
                HStack {
                    Text(game.rivalTeamName)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
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

struct widgetEntryView : View {
    var entry: Provider.Entry
    var team: String = "Maccabi Tel Aviv"
    let image = Image("maccabi")

    var body: some View {
        VStack {
            HStack{
                HStack() {
                    Image("maccabi")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding(.bottom, 5)
                        .padding(.top, 5)
                    Text(team)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 15))
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .padding(.bottom, 5)
                Image("euroleague")
                    .resizable()
                    .frame(width: 40, height: 20)
                    .padding(.trailing, -10.0)
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            GameEntry(game: entry.games.lastGame)
            Divider()
                .padding(.bottom, 10)
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

#Preview(as: .systemSmall) {
    widget()
} timeline: {
    SimpleGameEntry(date: .now, games: TeamGames(
        lastGame: Game(rivalTeamName: "Team A", gameDate: .now, teamScore: 100, versusScore: 0, win: true, confirmedDate: true, isPlayed: true),
        nextGame: Game(rivalTeamName: "Team B", gameDate: .now, teamScore: 100, versusScore: 0, win: true, confirmedDate: true, isPlayed: false)
    ))
}
