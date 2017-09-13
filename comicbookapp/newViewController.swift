//
//  detailsViewController.swift
//  comicbookapp
//
//  Created by joed lara, caesar shia on 5/30/17.
//  Copyright © 2017 Code School. All rights reserved.
//

import UIKit
import CoreData

class newViewController: UIViewController {
    
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var thedata: comicsss?
    
    
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    
    

    
    @IBAction func BackButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func favButtonPressed(_ sender: UIButton) {
        
        // Create New Entity
        let newFav = NSEntityDescription.insertNewObject(forEntityName: "Coms", into: context) as! Coms
        newFav.name = thedata?.title
        newFav.date = thedata?.release_Date
        newFav.desc = thedata?.description
        
        // Save to CoreData
        saveManagedObjectContext()

    
 
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = thedata?.title
        publisherLabel.text = thedata?.publisher
        releaseLabel.text = thedata?.release_Date
        priceLabel.text = thedata?.price
        descLabel.text = thedata?.description
        creatorLabel.text = thedata?.creator
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func saveManagedObjectContext(){
        do{
            try context.save()
            dismiss(animated: true, completion: nil)
            print("poop")
        }catch{
            print("error")
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
