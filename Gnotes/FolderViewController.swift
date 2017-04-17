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
  
  @IBOutlet fileprivate weak var tableView: UITableView!
  
  fileprivate var newFolderBarButtonItem: UIBarButtonItem!
  fileprivate var deleteFolderBarButtonItem: UIBarButtonItem!
  
  fileprivate var folders = [FolderViewModel]()
  fileprivate weak var saveAction: UIAlertAction?


  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    reload()
    navigationItem.rightBarButtonItem = editButtonItem
    
    newFolderBarButtonItem = UIBarButtonItem(title: NSLocalizedString("New Folder", comment: "new folder"), style: .plain, target: self, action: #selector(newFolderButtonTapped(_:)))
    deleteFolderBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Delete", comment: "delete"), style: .plain, target: self, action: #selector(deleteButtonTapped(_:)))
    
    updateToolBarButtonsToMatchWithTableState()

    
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
  
  func updateToolBarButtonsToMatchWithTableState() {
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    if tableView.isEditing {
      deleteFolderBarButtonItem.isEnabled = false
      setToolbarItems([flexibleSpace, deleteFolderBarButtonItem], animated: true)
    } else {
      setToolbarItems([flexibleSpace, newFolderBarButtonItem], animated: true)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    tableView.setEditing(!tableView.isEditing, animated: true)
    updateToolBarButtonsToMatchWithTableState()
  }

  func newFolderButtonTapped(_ sender: Any) {
    
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
  
  func deleteButtonTapped(_ sender: Any) {
    if let toDeleteRows = tableView.indexPathsForSelectedRows {
      for indexPath in toDeleteRows {
        let folderViewModel = folders[indexPath.row - 1]
        CoreDataStack.shared.mainContext.delete(folderViewModel.folder)
      }
      
      let indexesTobeDeleted = toDeleteRows.map{$0.row - 1}.sorted(by: { $0 > $1 })
      for index in indexesTobeDeleted {
        folders.remove(at: index)
      }
      CoreDataStack.shared.saveContext()
      tableView.deleteRows(at: toDeleteRows, with: .automatic)
      isEditing = false
    }
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "\(Constants.TableViewCellIdentifier.folderTableViewCell)2") as! FolderTableViewCell
    if indexPath.row == 0 {
      cell.titleLabel?.text = "All"
      cell.detailLabel?.text = "\(0)"
    } else {
      cell.configure(with: folders[indexPath.row - 1])
    }
    return cell
  }
}

// MARK: - TableViewDelegate

extension FolderViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    return .delete
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return indexPath.row != 0
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tableView.isEditing, tableView.indexPathsForSelectedRows != nil {
      deleteFolderBarButtonItem.isEnabled = true
    }
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    if tableView.isEditing, tableView.indexPathsForSelectedRows == nil {
      deleteFolderBarButtonItem.isEnabled = false
    }
  }
  
}
