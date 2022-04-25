//
//  ChatViewController.swift
//  iFlashChat
//
//  Created by Konstantin on 20.04.2022.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var messageTextField: UITextField!
    
    private let db = Firestore.firestore()
    
    private var messages: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        setupView()
        loadMessages()
    }
    
    private func setupView() {
        title = K.appName
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    
    private func setDelegates() {
        tableView.dataSource = self
    }
    
    private func loadMessages() {
        
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { [weak self] querySnapshot, error in
                
            guard let self = self else { return }
            self.messages = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else { return }
                
                for doc in snapshotDocuments {
                    let data = doc.data()
                    guard let sender = data[K.FStore.senderField] as? String,
                          let messageBody = data[K.FStore.bodyField] as? String else { return }
                    self.messages.append(Message(sender: sender, body: messageBody))
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
            }
            
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        guard let messageBody = messageTextField.text,
              let messageSender = Auth.auth().currentUser?.email else { return }
        
        db.collection(K.FStore.collectionName).addDocument(data: [
            K.FStore.senderField: messageSender,
            K.FStore.bodyField: messageBody,
            K.FStore.dateField: Date().timeIntervalSince1970
        ]) { error in
            if let e = error {
                print("There was an issue saving data to firestore, \(e)")
            } else {
                print("Successfully saved data.")
            }
        }
        
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }

}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        cell.label.text = message.body
        
        return cell
    }
    
    
}


