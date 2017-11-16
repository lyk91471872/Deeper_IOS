//
//  ListNameCell.swift
//  Deeper
//
//  Created by 罗宇康 on 2017/7/31.
//  Copyright © 2017年 lyk91471872. All rights reserved.
//

import UIKit

class ListNameCell: UITableViewCell {
    var lists = [ListMO]()
    var words = [Word]()
    var row = Int()
    var table: UITableView?
   
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var listName: UILabel!
    @IBOutlet weak var numberOfWords: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBAction func editButtonTapped(_ sender: UIButton) {
        
    }
    @IBOutlet weak var resetProgress: UIButton!
    
    @IBAction func resetProgressTriggered(_ sender: UIButton) {
        lists = CoreDataHelper.retrieveLists()
        words = lists[row].listToWord?.allObjects as! [Word]
        for word in words {
            word.familiarity = 0
        }
        CoreDataHelper.saveList()
        self.table?.reloadData()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
