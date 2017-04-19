//
//  FolderTableViewCell.swift
//  Gnotes
//
//  Created by Gautham Ilango on 11/04/17.
//  Copyright © 2017 Gautham Ilango. All rights reserved.
//

import UIKit

protocol FolderTableViewCellDelegate: class {
  func folderHasBeenTapped(_ :FolderViewModel?)
}

class FolderTableViewCell: UITableViewCell {
  
  @IBOutlet weak var detailLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet private weak var stackView: UIStackView!
  
  weak var delegate: FolderTableViewCellDelegate?
  private var folderViewModel: FolderViewModel?
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  func configure(with viewModel: ViewModelProtocol) {
    if let folderViewModel = viewModel as? FolderViewModel {
      titleLabel?.text = folderViewModel.title
      detailLabel?.text = "\(folderViewModel.notesCount)"
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(folderTilteLabelIsTapped))
      stackView.gestureRecognizers = [tapGestureRecognizer]
      self.folderViewModel = folderViewModel
    }
  }
  
  func folderTilteLabelIsTapped() {
    delegate?.folderHasBeenTapped(self.folderViewModel)
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
  }
  
  override func prepareForReuse() {
    detailLabel.text = ""
    titleLabel.text = ""
    folderViewModel = nil
  }

}
