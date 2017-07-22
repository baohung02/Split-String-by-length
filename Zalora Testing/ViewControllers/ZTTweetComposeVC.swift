//
//  ZTTweetComposeVC.swift
//  Zalora Testing
//
//  Created by Jack on 7/22/17.
//  Copyright © 2017 Htuinngh. All rights reserved.
//

import UIKit
import Social

class ZTTweetComposeVC: UIViewController {
    
    
    @IBOutlet weak var composeTV: UITextView! {
        didSet {
            composeTV.layer.cornerRadius = 10
            composeTV.layer.borderColor = UIColor.black.cgColor
            composeTV.layer.borderWidth = 1
            composeTV.clipsToBounds = true
        }
    }
    @IBOutlet weak var sentTableView: UITableView!
    @IBOutlet weak var tweetButton: UIButton! {
        didSet {
            tweetButton.layer.cornerRadius = 10
            tweetButton.clipsToBounds = true
        }
    }
    
    var sentMessages : [String] = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let alert = UIAlertController(title: "Accounts",
                                          message: "Please login to a Twitter account to share.",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            self.tweetButton.isEnabled = false
        }
        else
        {
            self.tweetButton.isEnabled = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - IBAction
    @IBAction func tweetButtonDidTouch(_ sender: Any) {
        
        if composeTV.text == nil || self.composeTV.text.characters.count == 0 {
            self .showInvalidMessageAlert()
            return
        }
        
        let messages : [String] = self.composeTV.text.splitByLength(Config.limitedLength)
        
        self.tweetMessages(messages: messages)
    }
    
    // MARK: - Methods
    func showInvalidMessageAlert() {
        let alertVC : UIAlertController = UIAlertController(title: "Error",
                                                            message: "Invalid message", preferredStyle: .alert)
        let alertAction: UIAlertAction = UIAlertAction(title: "OK",
                                                       style: .cancel) { (action) in
                                                        
        }
        alertVC.addAction(alertAction)
        
        self.present(alertVC, animated: true, completion: {
            
        })
    }
    
    func tweetMessages(messages: [String]) {
        let tweetSheet: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        tweetSheet.setInitialText("Look at this nice picture!")
        
        tweetSheet.completionHandler = { (result:SLComposeViewControllerResult) -> Void in
            switch result {
            case .cancelled:
                print("Cancelled") // Never gets called
                break
                
            case .done:
                print("Done")
                break
            }
        }
        
        
        self.present(tweetSheet, animated: true, completion: { })
    }
}

extension ZTTweetComposeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sentMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListViewCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}