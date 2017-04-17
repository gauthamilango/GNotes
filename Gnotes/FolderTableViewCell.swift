//
//  FolderTableViewCell.swift
//  Gnotes
//
//  Created by Gautham Ilango on 11/04/17.
//  Copyright © 2017 Gautham Ilango. All rights reserved.
//

import UIKit

class FolderTableViewCell: UITableViewCell {
  
  @IBOutlet weak var detailLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  func configure(with viewModel: ViewModelProtocol) {
    if let folderViewModel = viewModel as? FolderViewModel {
      titleLabel?.text = folderViewModel.title
      detailLabel?.text = "\(folderViewModel.notesCount)"
    }
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
  }

}
