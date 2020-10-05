//
//  EntryDetailViewController.swift
//  JournalCloudKit
//
//  Created by Jordan Bryant on 10/5/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    let entryController = EntryController.shared
    
    var entry: Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        saveButton.layer.masksToBounds = true
        saveButton.layer.cornerRadius = 30
        
        self.title = "New Entry"
        
        if let entry = entry {
            self.title = "View Entry"
            
            titleTextField.text = entry.title
            bodyTextView.text = entry.body
            
            titleTextField.isUserInteractionEnabled = false
            bodyTextView.isEditable = false
            saveButton.isHidden = true
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        guard let body = bodyTextView.text, !body.isEmpty else { return }
        
        entryController.createEntry(with: title, body: body) { (result) in
            switch result {
            case .success(_):
                print("Entry successfully created")
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print("Error when save button tapped in EntryDetailViewController: \(error.localizedDescription)")
            }
        }
    }
}
