//
//  ViewController.swift
//  Gnotes
//
//  Created by Gautham Ilango on 10/04/17.
//  Copyright © 2017 Gautham Ilango. All rights reserved.
//

import UIKit
import BNRCoreDataStack

class FolderViewController: UIViewController {
  
  var folders = [FolderViewModel]()
  weak var saveAction: UIAlertAction?
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    reload()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  func reload() {
    do {
      
      folders = try Folder.allInContext(CoreDataStack.shared.mainContext)
        .sorted { (folderOne, folderTwo) -> Bool in
          return folderOne.createdDate?.timeIntervalSince1970 ?? 0 < folderTwo.createdDate?.timeIntervalSince1970 ?? 0
        }
        .map { FolderViewModel(folder: $0) }
      
    } catch {
      print(error.localizedDescription)
    }
    tableView.reloadData()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func editButtonTapped(_ sender: Any) {
    
  }

  @IBAction func newFolderButtonTapped(_ sender: Any) {
    
    let alertController = UIAlertController(title: NSLocalizedString("New Folder", comment: "New Folder"), message: NSLocalizedString("Enter a name for this folder", comment: "Enter a name for this folder"), preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: NSLocalizedString("Save", comment: "Save"), style: .default) { (action) in
      let newFolderTitle = alertController.textFields?.first?.text
      let newFolder = Folder(context: CoreDataStack.shared.mainContext)
      newFolder.title = newFolderTitle
      CoreDataStack.shared.saveContext()
      self.reload()
    }
    
    let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
    
    alertController.addAction(saveAction)
    alertController.addAction(cancelAction)
    
    saveAction.isEnabled = false
    self.saveAction = saveAction
    
    alertController.addTextField { (textField) in
      textField.placeholder = NSLocalizedString("Name", comment: "Name")
      textField.clearButtonMode = .whileEditing
      textField .addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    present(alertController, animated: true, completion: nil)
  }
  
  func textFieldDidChange(_ textField: UITextField) {
    saveAction?.isEnabled = ((textField.text ?? "").utf16.count > 0)
  }
}

// MARK: - TableViewDataSourceDelegate

extension FolderViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return folders.count + 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.folderTableViewCell) as! FolderTableViewCell
    if indexPath.row == 0 {
      cell.textLabel?.text = "All"
      cell.detailTextLabel?.text = "(\(0))"
    } else {
      cell.configure(with: folders[indexPath.row - 1])
    }
    return cell
  }
}
