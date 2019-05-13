//
//  ChannelsViewController.swift
//  Twitter
//
//  Created by Phuc Nguyen on 5/13/19.
//  Copyright © 2019 Phuc Nguyen. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore

class ChannelsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let toolbarLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let database = Firestore.firestore()
    
    private var channelReference: CollectionReference {
        return database.collection("channels")
    }
    
    var currentUser: User!
    
    private var channels: [Channel] = []
    private var channelListener: ListenerRegistration?
    
    private var currentChannelAlertController: UIAlertController?
    
    deinit {
        channelListener?.remove()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        tableView.dataSource = self
        tableView.delegate = self
        
        channelListener = channelReference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isToolbarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isToolbarHidden = true
    }
    
    func setupLayout() {
        title = "Channels"
        toolbarLabel.text = AppSettings.displayName
        toolbarItems = [
            UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: toolbarLabel),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed)),
        ]
    }

}

// MARK: - Storyboard instance
extension ChannelsViewController {
    static func storyboardInstance() -> ChannelsViewController? {
        
        let storyboard = AppStoryboards.main.instance
        
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? ChannelsViewController
        
    }
}

// MARK: - Event Handlers
extension ChannelsViewController {
    private func createChannel() {
        guard let ac = currentChannelAlertController else {
            return
        }
        
        guard let channelName = ac.textFields?.first?.text else {
            return
        }
        
        let channel = Channel(name: channelName)
        channelReference.addDocument(data: channel.representation) { error in
            if let e = error {
                print("Error saving channel: \(e.localizedDescription)")
            }
        }
    }
    
    private func addChannelToTable(_ channel: Channel) {
        guard !channels.contains(channel) else {
            return
        }
        
        channels.append(channel)
        channels.sort()
        
        guard let index = channels.firstIndex(of: channel) else {
            return
        }
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func updateChannelInTable(_ channel: Channel) {
        guard let index = channels.firstIndex(of: channel) else {
            return
        }
        
        channels[index] = channel
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func removeChannelFromTable(_ channel: Channel) {
        guard let index = channels.firstIndex(of: channel) else {
            return
        }
        
        channels.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard let channel = Channel(document: change.document) else {
            return
        }
        
        switch change.type {
        case .added:
            addChannelToTable(channel)
            
        case .modified:
            updateChannelInTable(channel)
            
        case .removed:
            removeChannelFromTable(channel)
        default:
            break;
        }
    }
    
    @objc func signOut() {
        let alertController = UIAlertController(title: nil, message: "Are you sure to sign out?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            do {
                try Auth.auth().signOut()
            } catch {
                print("Error signing out: \(error.localizedDescription)")
            }
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func addButtonPressed() {
        let alertController = UIAlertController(title: "Create a new Channel", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addTextField { field in
            field.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
            field.enablesReturnKeyAutomatically = true
            field.autocapitalizationType = .words
            field.clearButtonMode = .whileEditing
            field.placeholder = "Channel name"
            field.returnKeyType = .done
            field.tintColor = .primary
        }
        
        let createAction = UIAlertAction(title: "Create", style: .default, handler: { _ in
            self.createChannel()
        })
        createAction.isEnabled = false
        alertController.addAction(createAction)
        alertController.preferredAction = createAction
        
        currentChannelAlertController = alertController
        present(alertController, animated: true) {
            alertController.textFields?.first?.becomeFirstResponder()
        }
    }
    
    @objc private func textFieldDidChange(_ field: UITextField) {
        guard let alertController = currentChannelAlertController else {
            return
        }
        
        alertController.preferredAction?.isEnabled = field.hasText
    }
}

extension ChannelsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.reuseIdentifier, for: indexPath)
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = channels[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let chatVC = ChatViewController.storyboardInstance() else { return }
//        let channel = channels[indexPath.row]
//        show(chatVC, sender: self)
    }
    
}
