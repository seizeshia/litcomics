//
//  favesTVControllerTableViewController.swift
//  comicbookapp
//
//  Created by joed lara, caesar shia on 6/2/17.
//  Copyright © 2017 Code School. All rights reserved.
//

import UIKit
import CoreData

class favesTVControllerTableViewController: UITableViewController {
    var comicsArray = [Coms?]()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    @IBAction func BackButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllItems()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comicsArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath) as! favCustomCell
        cell.nameLabel.text = comicsArray[indexPath.row]?.name
        cell.dateLabel.text = comicsArray[indexPath.row]?.date
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        managedObjectContext.delete(comicsArray[indexPath.row]!)
        if managedObjectContext.hasChanges{
            do{
                try managedObjectContext.save()
                print("Success")
                fetchAllItems()
            }catch{
                print("\(error)")
            }
        }
    }
    
    func fetchAllItems(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Coms")
        
        do {
            let result = try managedObjectContext.fetch(request)
            comicsArray = result as! [Coms]
            tableView.reloadData()
        } catch {
            print("\(error)")
        }
        
    }



}
