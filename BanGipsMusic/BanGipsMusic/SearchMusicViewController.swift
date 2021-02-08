//
//  SearchViewController.swift
//  BanGipsMusic
//
//  Created by BanGips on 5.02.21.
//

import UIKit
import Alamofire

struct TrackModel {
    var trackName: String
    var artistname: String
}

class SearchMusicViewController: UITableViewController {
    
    var timer: Timer?
    
    var tracks = [Tracks]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupSearchBar()
        setupTableView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }
    
    private func setupSearchBar() {
//        navigationController?.navigationBar.barTintColor = .mainWhite()
        navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let track = tracks[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = "\(track.trackName)\n\(track.artistName)"
        content.image = #imageLiteral(resourceName: "music")
        content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
         
        cell.contentConfiguration = content
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchMusicViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
            let url = "https://itunes.apple.com/search"
            let params = ["term": searchText, "limit": "10"]
            
            
            AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default).responseData { (responseData) in
                if let error = responseData.error {
                    print(error)
                    return
                }
                
                guard let data = responseData.data else { return }
                let decoder = JSONDecoder()
                
                do {
                    let objects = try decoder.decode(SearchResponse.self, from: data)
                    self.tracks = objects.results
                    self.tableView.reloadData()
                    
                } catch let parseError {
                    print(parseError.localizedDescription)
                }
            }
        
        })
        
    }
    
}
