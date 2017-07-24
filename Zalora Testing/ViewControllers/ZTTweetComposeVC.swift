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
        
        self.view.endEditing(true)
        
        // Sent immediately if text shorter than limit value
        if composeTV.text.characters.count <= Config.limitedLength {
            self.tweetMessages(messages: [composeTV.text])
        }
        else {
            
            let messages : [String] = self.composeTV.text.splitByLength(Config.limitedLength)
            if messages.count > 0 {
                
                let temporaryString = self.composeTV.text
                
                self.composeTV.text = messages.joined(separator: "\n")
                
                let alertVC : UIAlertController = UIAlertController(title: "Notice",
                                                                    message: "Your tweet too long, Do you want to send \(messages.count) tweets instead?", preferredStyle: .alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel",
                                                               style: .cancel) {[unowned self] (action) in
                                                                self.composeTV.text = temporaryString
                }
                
                let okAction: UIAlertAction = UIAlertAction(title: "OK",
                                                            style: .default,
                                                            handler: { [unowned self]  (action) in
                                                                
                                                                self.tweetMessages(messages: messages)
                })
                alertVC.addAction(cancelAction)
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true, completion: {
                    
                })
            
            }
            else
            {
                self .showInvalidMessageAlert()
            }
        }
        
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
        
        if messages.count == 0 {
            self.composeTV.text = nil
            return
        }
        
        var tempMessages: [String] = messages
        let message = tempMessages[0]
        
        let tweetSheet: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        tweetSheet.setInitialText(message)
        tweetSheet.completionHandler = {[unowned self] (result:SLComposeViewControllerResult) -> Void  in
            switch result {
            case .cancelled:
                print("Cancelled")
                break
                
            case .done:
                print("Done")
                
                tempMessages.remove(at: 0)
                self.sentMessages.insert(message, at: 0)
                self.sentTableView.reloadData()
                
                // TODO: Need improve
                self.perform(#selector(self.tweetMessages(messages:)), with: tempMessages, afterDelay: 0.5)
                
                break
                
            }
        }
        
        self.present(tweetSheet, animated: true, completion: nil)
    }
}

extension ZTTweetComposeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let rect = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40)
        let headerView = UIView(frame: rect)
        headerView.backgroundColor = UIColor.lightGray
        
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 5, width: tableView.frame.width - 2*20, height: 30))
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.text = "Sent messages"
        titleLabel.textColor = UIColor.white
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sentMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMessageTableViewCell", for: indexPath)
        cell.textLabel?.text = self.sentMessages[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
