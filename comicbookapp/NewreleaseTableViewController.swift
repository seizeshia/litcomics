//
//  secondTableTableViewController.swift
//  comicbookapp
//
//  Created by joed lara, caesar shia on 5/30/17.
//  Copyright © 2017 Code School. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class NewreleaseTableViewController: UITableViewController, UISearchBarDelegate{
    
    
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchfunc: UISearchBar!
    
    
    
    var comicsArray = [comicsss]()
    var filteredcomics = [comicsss]()
    var transferArray = [comicsss]()
    var isSearching: Bool = false
    var cellClicked = false
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transferArray = comicsArray
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        
        callAPI()
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredcomics = comicsArray.filter({ (text) -> Bool in
            let tmp: NSString = text.title as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
            
        })
        if(filteredcomics.count == 0){
            isSearching = false;
            transferArray = comicsArray
        } else {
            isSearching = true;
            transferArray = filteredcomics
        }
        self.tableView.reloadData()
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (isSearching) {
            return filteredcomics.count
        }
        
        
        return comicsArray.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myCell2", for: indexPath) as? customCell2{
            
            if (isSearching && cellClicked == false) {
                cell.titlelabel.text = filteredcomics[indexPath.row].title
            } else {
                cell.titlelabel.text = comicsArray[indexPath.row].title
                cell.yearlabel.text = comicsArray[indexPath.row].release_Date
                cell.priceLabel.text = comicsArray[indexPath.row].price
                
                isSearching = false
                
                cellClicked = false
            }
            
            return cell
            
        }
        return UITableViewCell()
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        cellClicked = true
        performSegue(withIdentifier: "theSeg", sender: indexPath.row)
    }
    
    func callAPI(){
        ///call API!
        //Specify the url that we will be sending the GET Request to
        let url = URL(string: "https://api.shortboxed.com/comics/v1/new")
        
        Alamofire.request(url!, method: .get, parameters: nil, headers: nil)
            .responseJSON { response in
                
                //perform action on API data
                
            
                if let jsonResult = response.result.value as? NSDictionary{
                    print(jsonResult)
                    
                    if let resultArr = jsonResult["comics"] as? NSArray{
                        for result in resultArr{
                            let r = result as! NSDictionary
                            print(r["title"] ?? "nil")
                            self.comicsArray.append(comicsss(p: r["publisher"] as! String, d: r["description"] as! String, t: r["title"] as! String, c: r["creators"] as! String, pp: r["price"] as! String, RD: r["release_date"] as! String))
                            print(r["release_date"] ?? "nil")
                            
                        }
                        
                        self.tableView.reloadData()
                        
                    }
                    
                }
                
        }
    }
    
    @IBAction func Favorites(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "thetheSeg", sender: nil)
    }
    
    
    
    
    
//    @IBAction func favoriteButtonPressed(_ sender: UIBarButtonItem) {
//        performSegue(withIdentifier: "secondSeg", sender: "poop")
//    }
//    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender != nil {
            let vc = segue.destination as! newViewController
            if let idx = sender as? Int{
                if filteredcomics.count == 0{
                    vc.thedata = comicsArray[idx]
                }else{
                    vc.thedata = filteredcomics[idx]
                }
                
            }
            
        }else{
            
        }
        
    }
}

















