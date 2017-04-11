//
//  FolderTableViewCell.swift
//  Gnotes
//
//  Created by Gautham Ilango on 11/04/17.
//  Copyright © 2017 Gautham Ilango. All rights reserved.
//

import UIKit

class FolderTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  func configure(with viewModel: ViewModelProtocol) {
    if let folderViewModel = viewModel as? FolderViewModel {
      textLabel?.text = folderViewModel.title
      detailTextLabel?.text = "(\(folderViewModel.notesCount))"
    }
  }

}
