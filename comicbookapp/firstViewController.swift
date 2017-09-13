//
//  ViewController.swift
//  comicbookapp
//
//  Created by joed lara, caesar shia on 5/30/17.
//  Copyright © 2017 Code School. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class firstViewController: UIViewController {
    var datatopass: Parameters? = [:]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var error: UILabel!
    
    var token = "ay8c8ooVXrosdfsqqrjdbO2J1F0Jsdfsdfsdf7kl.2924tX";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func loginbuttonpressed(_ sender: Any) {
        datatopass?["username"] = username.text! as String
        datatopass?["password"] = password.text! as String
        datatopass?["token"] = token as String
        callAPI()
    }
    
    func callAPI(){
        ///call API!
        //Specify the url that we will be sending the GET Request to
        let url = URL(string: "http://34.211.246.144/login")
        print("Dta to pass", datatopass!)

        //        let headers = ["api_key": "926e88cf0bc1f8e076fc88ff4ee4b5d3ee695fa4",
        //                               "format": "json"]
        
        
        //    Alamofire.request("34.212.239.32/register", method: .post, parameters: parameters, headers: nil)
        Alamofire.request(url!, method: .post, parameters: datatopass)
            
            
            .responseJSON { response in
                print(response)
                
                if let thedata = response.result.value as? NSDictionary{
                    print("this is it!", thedata)
                    
                    
            
    
                //perform action on API data
        
                if(thedata["message"] as? String == "No user found"){
                    self.error.text = "No user Found"
                    }
                else if(thedata["message"] as? String == "password and username do not match"){
                    self.error.text = "password and username do not match"
                }
                else if(thedata["message"] as? String == "User found"){
                    print("we are here!!!!!!!!!!!!!!!")
                    //should be as NSDictionary?  but causes and error
                    if let jsonResult = response.result.value as? NSDictionary{
                        print("jsonResult", jsonResult)
                        let newuser = NSEntityDescription.insertNewObject(forEntityName: "User", into: self.context) as! User
                        if let usern = jsonResult["username"] {
                            print("got usern", usern)
                            newuser.username = usern as? String
                        }
                        if let usere = jsonResult["email"]{
                            newuser.email = usere as? String
                        }
                        if let userl = jsonResult["location"]{
                            newuser.location = userl as? String
                        }
                        
                        self.saveManagedObjectContext()
                        print("*************************a")
                        self.performSegue(withIdentifier: "signinSeg", sender: nil)
                    }
//
//                    
                }
                
                }
        }
    }
    
    func saveManagedObjectContext(){
        do{
            try context.save()
            //            dismiss(animated: true, completion: nil)
            print("poop")
        }catch{
            print("error")
        }
    }



}

