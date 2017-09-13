//
//  detailsViewController.swift
//  comicbookapp
//
//  Created by joed lara, caesar shia on 5/30/17.
//  Copyright © 2017 Code School. All rights reserved.
//

import UIKit
import CoreData

class detailsViewController: UIViewController {
    var thedata: comic?
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var issueLabel: UILabel!
    @IBOutlet weak var cover_dateLabel: UILabel!
    @IBOutlet weak var storeDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    @IBAction func FavButton(_ sender: UIButton) {
        // Create New Entity
        let newFav = NSEntityDescription.insertNewObject(forEntityName: "Coms", into: context) as! Coms
        newFav.name = thedata?.name
        newFav.date = thedata?.cover_date
        newFav.desc = thedata?.description
        
        // Save to CoreData
        saveManagedObjectContext()

    }
    
    @IBAction func backbuttonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = thedata?.name
        issueLabel.text = thedata?.issue_number
        cover_dateLabel.text = thedata?.cover_date
        storeDateLabel.text = thedata?.store_date
        if let textss = thedata?.description{
        descriptionLabel.text = textss
            print(textss)
        }
//        imageLabel.image = thedata?.image
        let comicpictureurl = URL(string: (thedata!.image))
        let session = URLSession(configuration: .default)
        let downloadpictask = session.dataTask(with: comicpictureurl!) { (data, response, error) in
            if let e = error{
                print("error downloading image: \(e)")
            }else{
                if let res = response as? HTTPURLResponse{
                    print("download comic picture with respponse code \(res.statusCode)")
                    if let imagedData = data{
                        let imagesss = UIImage(data: imagedData)
                        
                        DispatchQueue.main.async {
                            self.imageLabel.image = imagesss
                        }
                        
                        
                        
                        
                        
                    } else{
                        print("couldn't get image: Image is nil")
                    }
                }else {
                    print("couldn't get response code for some reason")
                }
            }
        }

        downloadpictask.resume()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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


}
