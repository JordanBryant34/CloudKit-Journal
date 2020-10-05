//
//  EntriesTableViewController.swift
//  JournalCloudKit
//
//  Created by Jordan Bryant on 10/5/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
    let entryController = EntryController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        entryController.fetchEntries { (result) in
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCellId")!
        let entry = entryController.entries[indexPath.item]
        
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = entry.body
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let detailVC = segue.destination as? EntryDetailViewController else { return }
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
            let entry = entryController.entries[selectedIndexPath.row]
            
            detailVC.entry = entry
        }
    }
    
}
