//
//  wordCell.swift
//  Deeper
//
//  Created by 罗宇康 on 2017/8/1.
//  Copyright © 2017年 lyk91471872. All rights reserved.
//

import UIKit

class wordCell: UITableViewCell {

    @IBOutlet weak var wordEnglish: UILabel!
    @IBOutlet weak var wordChinese: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Overflow settings of text in wordlist overview
        self.wordEnglish.lineBreakMode = .byTruncatingTail
        self.wordChinese.lineBreakMode = .byTruncatingTail
        
        // Color settings of text in wordlist
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
