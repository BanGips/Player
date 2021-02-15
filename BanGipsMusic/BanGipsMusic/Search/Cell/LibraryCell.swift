//
//  LibraryCell.swift
//  BanGipsMusic
//
//  Created by Sergei Kast on 13.02.21.
//

import SwiftUI
import URLImage

struct LibraryCell: View {
    var cell: SearchViewModel.Cell
    
    var body: some View {
        HStack {
//            Image("Knob").resizable().frame(width: 50, height: 50)
            let url = URL(string: cell.iconUrlString!)!
            URLImage(url: url) { $0.resizable().frame(width: 50, height: 50) }
            VStack(alignment: .leading) {
                Text("\(cell.trackName)")
                Text("\(cell.artistName)")
            }
        }
    }
}

//struct LibraryCell_Previews: PreviewProvider {
//    static var previews: some View {
//        LibraryCell()
//    }
//}
