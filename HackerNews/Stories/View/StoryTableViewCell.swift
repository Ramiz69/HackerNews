//
//  StoryTableViewCell.swift
//  HackerNews
//
//  Created by Рамиз Кичибеков on 26.02.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import UIKit

final class StoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var authorLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var iconImageView: UIImageView!
    
    private var operation: OperationGetStoryImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showActivityIndicator()
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        authorLabel.text = nil
        dateLabel.text = nil
        iconImageView.image = nil
        operation?.cancel()
        showActivityIndicator()
    }
    
    open func configureCell(with model: Story) {
        removeActivityIndicator()
        
        titleLabel.text = model.title
        authorLabel.text = model.author
        dateLabel.text = String.correctFormatDate(Date(timeIntervalSince1970: model.date))
        operation = OperationGetStoryImage(URL(string: model.url)!)
        operation?.completionBlock = {
            self.executeOnMainThread {
                self.iconImageView.image = self.operation?.image ?? #imageLiteral(resourceName: "placeholder")
            }
        }
    }
}
