//
//  widgetHeader.swift
//  euroleague_widgetExtension
//
//  Created by Yonatan Kalman on 09/11/2023.
//

import Foundation
import SwiftUI

struct WidgetHeader: View {
    let team: String
    
    var body: some View {
        HStack{
            HStack() {
                Image("maccabi")
                    .resizable()
                    .frame(width: 25, height: 25)
                Text(team)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 15))
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            .padding(.bottom, 5)
            .padding(.top, 10)
            Image("euroleague")
                .resizable()
                .frame(width: 40, height: 20)
                .padding(.trailing, -10.0)
        }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
    }
}
