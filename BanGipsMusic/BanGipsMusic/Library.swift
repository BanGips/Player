//
//  Library.swift
//  BanGipsMusic
//
//  Created by Sergei Kast on 13.02.21.
//

import SwiftUI

struct Library: View {
    @State var tracks = UserDefaults.standard.savedTracks()
    @State private var showAlert  = false
    @State private var track: SearchViewModel.Cell!
    
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        Button(action: {
                            self.track = tracks.first
                            self.tabBarDelegate?.maximizeTrackDetailView(viewModel: track)
                        }, label: {
                            Image(systemName: "play.fill")
                        })
                        .frame(width: geometry.size.width / 2 - 10, height: 50)
                        .accentColor(Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)))
                        .background(Color(#colorLiteral(red: 0.869320976, green: 0.869320976, blue: 0.869320976, alpha: 1)))
                        .cornerRadius(10)
                        Button(action: {
                            self.tracks = UserDefaults.standard.savedTracks()
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
                List {
                    ForEach(tracks) { track in
                        LibraryCell(cell: track).gesture(LongPressGesture().onEnded { (_) in
                            self.track = track
                            self.showAlert = true
                        }.simultaneously(with: TapGesture().onEnded{ (_) in
                            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                            let tabBarVC = keyWindow?.rootViewController as? MainTabBarController
                            tabBarVC?.trackDetailView.delegate = self
                            self.track = track
                            tabBarDelegate?.maximizeTrackDetailView(viewModel: track)
                        }))
                    }.onDelete(perform: delete)
                }
            }.actionSheet(isPresented: $showAlert, content: {
                ActionSheet(title: Text("Delete this tack"), buttons: [.destructive(Text("Delete"), action: {
                    self.delete(track: track)
                }), .cancel()])
            })
            .navigationTitle("Library")
        }
    }
    
    func delete(offsets: IndexSet) {
        tracks.remove(atOffsets: offsets)
        if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            UserDefaults.standard.set(saveData, forKey: UserDefaults.favoriteTrackKey)
        }
    }
    
    func delete(track: SearchViewModel.Cell) {
        let index = tracks.firstIndex(of: track)
        guard let safeIndex = index else { return }
        tracks.remove(at: safeIndex)
        if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            UserDefaults.standard.set(saveData, forKey: UserDefaults.favoriteTrackKey)
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}

extension Library: TrackMovingDelegate {
    func moveForPreviouesTack() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track)
        guard let safeIndex = index else { return nil }
        var nextTrack: SearchViewModel.Cell
        if safeIndex - 1 == -1 {
            nextTrack = tracks.last!
        } else {
            nextTrack = tracks[safeIndex - 1]
        }
        
        self.track = nextTrack
        return nextTrack
    }
    
    func moveForNextTack() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track)
        guard let safeIndex = index else { return nil }
        var nextTrack: SearchViewModel.Cell
        if safeIndex + 1 == tracks.count {
            nextTrack = tracks.first!
        } else {
            nextTrack = tracks[safeIndex + 1]
        }
        
        self.track = nextTrack
        return nextTrack
    }
    
    
}
