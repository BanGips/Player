//
//  LibraryCell.swift
//  BanGipsMusic
//
//  Created by Sergei Kast on 13.02.21.
//

import SwiftUI

struct LibraryCell: View {
    var body: some View {
        HStack {
            Image("Knob").resizable().frame(width: 50, height: 50)
            VStack {
                Text("Placeholder")
                Text("Placeholder")
            }
        }
    }
}

struct LibraryCell_Previews: PreviewProvider {
    static var previews: some View {
        LibraryCell()
    }
}
