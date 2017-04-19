//
//  ViewController.swift
//  Gnotes
//
//  Created by Gautham Ilango on 10/04/17.
//  Copyright © 2017 Gautham Ilango. All rights reserved.
//

import UIKit
import BNRCoreDataStack

class FolderListViewController: UIViewController {
  
  @IBOutlet fileprivate weak var tableView: UITableView!
  
  fileprivate var newFolderBarButtonItem: UIBarButtonItem!
  fileprivate var deleteFolderBarButtonItem: UIBarButtonItem!
  
  fileprivate var folders = [FolderViewModel]()
  fileprivate var selectedFolderViewModel: FolderViewModel?
  fileprivate weak var saveAction: UIAlertAction?

  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Reload the data
    reload()
    
    // Setup the bar buttons
    navigationItem.rightBarButtonItem = editButtonItem
    newFolderBarButtonItem = UIBarButtonItem(title: NSLocalizedString("New Folder", comment: "new folder"), style: .plain, target: self, action: #selector(newFolderButtonTapped(_:)))
    deleteFolderBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Delete", comment: "delete"), style: .plain, target: self, action: #selector(deleteButtonTapped(_:)))
    
    // Configure the bar buttons
    updateToolBarButtonsToMatchWithTableState()

  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Constants.SegueIdentifier.showNoteListViewController, let destinationNoteListViewController = segue.destination as? NoteListViewController {
      destinationNoteListViewController.folderViewModel = selectedFolderViewModel
      selectedFolderViewModel = nil
    }
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
    // Delete button if the tableview is being edited or New Folder button if the tableView is not being edited
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    if tableView.isEditing {
      deleteFolderBarButtonItem.isEnabled = false
      setToolbarItems([flexibleSpace, deleteFolderBarButtonItem], animated: true)
    } else {
      setToolbarItems([flexibleSpace, newFolderBarButtonItem], animated: true)
    }
    
  }
  
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    // Set the tableView to editing mode based on the view's editing mode and configure the bar buttons
    super.setEditing(editing, animated: animated)
    tableView.setEditing(!tableView.isEditing, animated: true)
    updateToolBarButtonsToMatchWithTableState()
    
  }

  
  func newFolderButtonTapped(_ sender: Any) {
    
    // Display alert controller with textField for creating new folder
    let alertController = UIAlertController(title: NSLocalizedString("New Folder", comment: "New Folder"), message: NSLocalizedString("Enter a name for this folder", comment: "Enter a name for this folder"), preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: NSLocalizedString("Save", comment: "Save"), style: .default) { (action) in
      // Create new folder with the given name and save it
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
    // Delete the selected rows
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
    // Check the alertController's textfield is not empty and enable the save button
    saveAction?.isEnabled = ((textField.text ?? "").utf16.count > 0)
  }
  
  
}



// MARK: - TableViewDataSourceDelegate

extension FolderListViewController: UITableViewDataSource {
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return folders.count + 1
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.folderTableViewCell) as! FolderTableViewCell
    if indexPath.row == 0 {
      cell.titleLabel?.text = "All"
      cell.detailLabel?.text = "\(0)"
    } else {
      cell.configure(with: folders[indexPath.row - 1])
      cell.delegate = self
    }
    return cell
    
  }
  
  
}




// MARK: - TableViewDelegate

extension FolderListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    return .delete
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return indexPath.row != 0
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tableView.isEditing, tableView.indexPathsForSelectedRows != nil {
      deleteFolderBarButtonItem.isEnabled = true
    } else {
      selectedFolderViewModel = indexPath.row == 0 ? nil : folders[indexPath.row - 1]
      performSegue(withIdentifier: Constants.SegueIdentifier.showNoteListViewController, sender: self)
    }
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    if tableView.isEditing, tableView.indexPathsForSelectedRows == nil {
      deleteFolderBarButtonItem.isEnabled = false
    }
  }
  
}



// MARK: - FolderTableViewCellDelegate

extension FolderListViewController: FolderTableViewCellDelegate {
  
  
  func folderHasBeenTapped(_ folderViewModel: FolderViewModel?) {
    
    if tableView.isEditing, let folderViewModel = folderViewModel {
      // Display alert controller with textField for renaming the folder

      let alertController = UIAlertController(title: NSLocalizedString("Rename Folder", comment: "Rename Folder"), message: NSLocalizedString("Enter a new name for this folder", comment: "Enter a new name for this folder"), preferredStyle: .alert)
      
      let saveAction = UIAlertAction(title: NSLocalizedString("Save", comment: "Save"), style: .default) { (action) in
        let newFolderTitle = alertController.textFields?.first?.text
        folderViewModel.title = newFolderTitle ?? ""
        CoreDataStack.shared.saveContext()
        self.reload()
      }
      
      let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
      
      alertController.addAction(saveAction)
      alertController.addAction(cancelAction)
      
      self.saveAction = saveAction
      
      alertController.addTextField { (textField) in
        textField.text = folderViewModel.title
        textField.placeholder = NSLocalizedString("Name", comment: "Name")
        textField.clearButtonMode = .whileEditing
        textField .addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        textField.delegate = self
      }
      
      present(alertController, animated: true, completion: nil)
      
    } else {
      // Consider it selected and show the notes list view controller
      selectedFolderViewModel = folderViewModel
      performSegue(withIdentifier: Constants.SegueIdentifier.showNoteListViewController, sender: self)
    }
  }
  
  
}



// MARK: - TextFieldDelegate

extension FolderListViewController: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    // For highlighting the text when the folder is being renamed
    textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
  }
  
}
