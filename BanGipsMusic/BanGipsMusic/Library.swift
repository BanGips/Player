//
//  Library.swift
//  BanGipsMusic
//
//  Created by Sergei Kast on 13.02.21.
//

import SwiftUI

struct Library: View {
    let tracks = UserDefaults.standard.savedTracks()
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        Button(action: {
                            print(123)
                        }, label: {
                            Image(systemName: "play.fill")
                        })
                        .frame(width: geometry.size.width / 2 - 10, height: 50)
                        .accentColor(Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)))
                        .background(Color(#colorLiteral(red: 0.869320976, green: 0.869320976, blue: 0.869320976, alpha: 1)))
                        .cornerRadius(10)
                        Button(action: {

                        }, label: {
                            Image(systemName: "arrow.2.circlepath")
                        })
                        .frame(width: geometry.size.width / 2 - 10, height: 50)
                        .accentColor(Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)))
                        .background(Color(#colorLiteral(red: 0.869320976, green: 0.869320976, blue: 0.869320976, alpha: 1)))
                        .cornerRadius(10)
                    }
                }.padding().frame(height: 70)

                Divider()
                List(tracks) { track in
                    LibraryCell(cell: track)
                    

                }.listRowBackground(Color.clear)
            }
            .navigationTitle("Library")
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
