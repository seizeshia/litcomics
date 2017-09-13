//
//  regViewController.swift
//  comicbookapp
//
//  Created by caesar shia on 7/15/17.
//  Copyright © 2017 Code School. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class regViewController: UIViewController {
//    var parameters:users?
    var datatopass: Parameters? = ["username" : String.self]
    var token = "ay8c8ooVXrosdfsqqrjdbO2J1F0Jsdfsdfsdf7kl.2924tX";

    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passconf: UITextField!
    @IBOutlet weak var error: UILabel!
    

    @IBAction func backbuttpressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func Existingmempressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        datatopass?["username"] = username.text! as String
//        datatopass?["username"] = username.text! as String

        datatopass?["email"] = email.text! as String

        datatopass?["password"] = password.text! as String

        datatopass?["passconf"] = passconf.text! as String
        
        datatopass?["token"] = token as String
        print("Dta to pass", datatopass?["username"])

        callAPI()

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func callAPI(){
        ///call API!
        print("555555555555555555555555")
        //Specify the url that we will be sending the GET Request to
        let url = URL(string: "http://34.211.246.144/register")

        //        Alamofire.request(url!, method: .get, parameters: nil, headers: nil)
        print("hhhhhhhhhhhhhhh", datatopass)
        
        Alamofire.request(url!, method: .post, parameters: datatopass)
            .responseJSON { response in
 
                print(response)
                //perform action on API data
                if let thisdata = response.result.value as? NSDictionary{
                    print("this is it!", thisdata)
                    
                    if(response.result.error != nil){
                        self.error.text = response.result.description
                        print("there is an error")
                    }
                    else if(thisdata["message"] as? String == "username is less than 5 characters"){
                        self.error.text = "username can't be less than 5 characters"
                    }
                    else if(thisdata["message"] as? String == "email is less that 3 characters"){
                        self.error.text = "email can't be less than 3 characters"
                    }
                    else if(thisdata["message"] as? String == "password is less than 4 characters"){
                        self.error.text = "password must be at least 4 characters"
                    }
                    else if(thisdata["message"] as? String == "passwords do not match"){
                        self.error.text = "passwords do not match"
                    }
                    else if(thisdata["message"] as? String == "Email has been used! please log in"){
                        self.error.text = "Email has been user! please log in!"
                    }
                    else if(thisdata["message"] as? String == "Username has been used! please try another or sign in"){
                        self.error.text = "This username has been used, please sign in or choose another username"
                        
                    }
                    
                    else{
                        
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
                            //                        self.tableview.reloadData()
                            
                            self.saveManagedObjectContext()
                            self.performSegue(withIdentifier: "loginSeg", sender: nil)
                        }
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
