//
//  secondTableTableViewController.swift
//  comicbookapp
//
//  Created by caesar shia on 5/30/17.
//  Copyright © 2017 Code School. All rights reserved.
//

import UIKit
import CoreData
import Alamofire


class secondTableTableViewController: UITableViewController {
    
   
    var searchterm:String?
//    var searchdelegate: searchdelegate?
    
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchfunc: UISearchBar!
    
    
    
    var comicsArray = [comic]()
    var filteredcomics = [comic]()
    var sendingArray = [comic]()
    var isSearching: Bool = false
    
    var cellClicked = false
    // need to make a page prior to this that enters the what to search variable.  spaces need to be replaced with "+"
    
    //also change the view details page to take in new api results for /search type api.
    var whattosearch: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
//        searchBar.delegate = self
        
//
        callAPI()
        tableView.reloadData()
        sendingArray = comicsArray
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true;
        callAPI()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false;
        callAPI()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false;
    }
    
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredcomics = comicsArray.filter({ (text) -> Bool in
            let tmp: NSString = text.name as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
            
        })
        if(filteredcomics.count == 0){
            isSearching = false;
            sendingArray = comicsArray
        } else {
            isSearching = true;
            sendingArray = filteredcomics
        }
        self.tableView.reloadData()
        
    }
    

    @IBAction func backbuttonpressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? CustomCell{
        
            if (isSearching && cellClicked == false) {
                cell.namelabel.text = filteredcomics[indexPath.row].name
                
            } else {
    
                cell.namelabel.text = comicsArray[indexPath.row].name
                cell.cover_datelabel.text = comicsArray[indexPath.row].cover_date
                cell.issue_numberLabel.text = "Issue: \(comicsArray[indexPath.row].issue_number)"
//                let imgurl = NSURL(string: comicsArray[indexPath.row].image)

                let comicpictureurl = URL(string: comicsArray[indexPath.row].image)
                let session = URLSession(configuration: .default)
                let downloadpictask = session.dataTask(with: comicpictureurl!) { (data, response, error) in
                    if let e = error{
//                        print("error downloading image: \(e)")
                    }else{
                        if let res = response as? HTTPURLResponse{
//                            print("download comic picture with respponse code \(res.statusCode)")
                            if let imagedData = data{
                                let images = UIImage(data: imagedData)
                                
                                DispatchQueue.main.async {
                                    
                                    cell.imageLabel.image = images
                                }
                                
                                
                                
                                
                            } else{
//                                print("couldn't get image: Image is nil")
                            }
                        }else {
//                            print("couldn't get response code for some reason")
                        }
                        }
                    }
            
                downloadpictask.resume()
                
                
//                cell.imageLabel.image = picture as? UIImage
//                cell.imageLabel.image(with: imgurl! as URL)
                
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
        performSegue(withIdentifier: "firstSeg", sender: indexPath.row)
    }
    
    

    func callAPI(){
        ///call API!
        print("+++++++++++++++++++++++++++",whattosearch!)
        //Specify the url that we will be sending the GET Request to
        let url = URL(string: "https://comicvine.gamespot.com/api/issues/?api_key=926e88cf0bc1f8e076fc88ff4ee4b5d3ee695fa4&format=json&filter=name:"+whattosearch!)

        
        //let headers = ["api_key": "926e88cf0bc1f8e076fc88ff4ee4b5d3ee695fa4",
//                       "format": "json"]
        
        
        
        Alamofire.request(url!, method: .get, parameters: nil, headers: nil)
            .responseJSON { response in
//                print(response)
                //perform action on API data
                
                
                if let jsonResult = response.result.value as? NSDictionary{
//                    print(jsonResult)
                    var imageurl = ""
                    var thename = ""
                    var thedesc = ""
                    var thecovdate = ""
                    var thestoredate = ""
                    var theissuenumber = ""
                    var thedeck = ""
                    
                    if let resultArr = jsonResult["results"] as? NSArray{
                        for result in resultArr{
                            let r = result as! NSDictionary
                            if let image = r["image"] as? NSDictionary{
                                if let imageS = image["icon_url"] as? String{
//                                    print("here!")
//                                    print(imageS)
                                    imageurl = imageS
                                }
                            }
                            if let namess = r["name"] as? String{
                                thename = namess
                            }
                            if let desc = r["description"] as? String{
                                thedesc = desc
                            }
                            if let covdate = r["cover_date"] as? String{
                                thecovdate = covdate
                            }
                            if let storedate = r["store_date"] as? String{
                                thestoredate = storedate
                            }
                            if let issuenumber = r["issue_number"] as? String{
                                theissuenumber = issuenumber
                            }
                            if let deck = r["deck"] as? String{
                                thedeck = deck
                            }
                            
                            
                            
//                            print(r["name"] ?? "nil")
                            
                            self.comicsArray.append(comic(d: thedesc, n: thename, RD: thecovdate, SD: thestoredate, issue: theissuenumber, dd: thedeck, IMG: imageurl))
//                            print(r["release_date"] ?? "nil")
                        }
                        
                        self.tableView.reloadData()
                    }
                }
        }
    }
    
    
    @IBAction func Favoriteslist(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "theSeg", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender != nil {
            let vc = segue.destination as! detailsViewController
            if let idx = sender as? Int{
                if filteredcomics.count == 0{
                    vc.thedata = comicsArray[idx]
                    print(comicsArray[idx],"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
                }else{
                    vc.thedata = filteredcomics[idx]
                }
            
        }
            
        }else{
        
        }
        
        }
        


}
    
    












