//
//  signinViewController.swift
//  comicbookapp
//
//  Created by caesar shia on 9/8/17.
//  Copyright © 2017 Code School. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class searchViewController: UIViewController {
    @IBOutlet weak var searching: UITextField!
    @IBOutlet weak var searchlabel: UITextField!
    var searchterm:String?
    
    @IBAction func searchbutton(_ sender: UIButton) {
        performSegue(withIdentifier: "donesearchingseg", sender: nil)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let searchterm = searching.text;
        let newsearchterm = searchterm?.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
       let vc = segue.destination as! UINavigationController
        let targetController = vc.topViewController as! secondTableTableViewController
        targetController.whattosearch = newsearchterm
    }
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
