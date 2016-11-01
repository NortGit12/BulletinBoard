//
//  MessageListTableViewController.swift
//  BulletinBoard
//
//  Created by Jeff Norton on 11/1/16.
//  Copyright © 2016 JeffCryst. All rights reserved.
//

import UIKit

class MessageListTableViewController: UITableViewController, MessagesDelegate {
    
    //==================================================
    // MARK: - Properties
    //==================================================
    
    @IBOutlet weak var messageTextField: UITextField!
    
    let dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    //==================================================
    // MARK: - General
    //==================================================

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MessageController.shared.delegate = self

        tableView.reloadData()
    }

    //==================================================
    // MARK: - Table view data source
    //==================================================

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MessageController.shared.messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)

        let message = MessageController.shared.messages[indexPath.row]
        
        cell.textLabel?.text = message.text
        cell.detailTextLabel?.text = dateFormatter.string(from: message.timestamp)

        return cell
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    
    //==================================================
    // MARK: - MessagesDelegate
    //==================================================
    
    func messagesUpdated() {
        
        tableView.reloadData()
    }
    
    //==================================================
    // MARK: - Methods
    //==================================================
    
    
    
    //==================================================
    // MARK: - Actions
    //==================================================
    
    @IBAction func postButtonTapped(_ sender: UIButton) {
        
        // Make a new message
        
        guard let messageText = messageTextField.text
            , messageText.characters.count > 0 else { return }
        
        let message = Message(text: messageText, timestamp: Date())
        
        // Post that message to CloudKit
        
        MessageController.shared.post(message: message) { (_) in
            
            self.messageTextField.resignFirstResponder()
            self.messageTextField.text = ""
            self.tableView.reloadData()
        }
    }
}















