//
//  teamConfig.swift
//  euroleague_widgetExtension
//
//  Created by Yonatan Kalman on 09/11/2023.
//

import Foundation

struct TeamConfigRecord {
    let name: String;
    let teamCode: String;
    let teamIcon: String;
}

let TEAM_CONFIG: [Team: TeamConfigRecord] = [
    .tEL: TeamConfigRecord(name: "Maccabi Tel Aviv", teamCode: "TEL", teamIcon: "maccabi"),
    .bER: TeamConfigRecord(name: "Alba Berlin", teamCode: "BER", teamIcon: "alba"),
    .mUN: TeamConfigRecord(name: "FC Bayern Munich", teamCode: "MUN", teamIcon: "munich"),
    .mAD: TeamConfigRecord(name: "Real Madrid", teamCode: "MAD", teamIcon: "madrid"),
    .bAR: TeamConfigRecord(name: "FC Barcelona", teamCode: "BAR", teamIcon: "barcelona"),
]
