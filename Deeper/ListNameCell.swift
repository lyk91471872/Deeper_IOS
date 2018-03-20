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
    var message = ""
   
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var listName: UILabel!
    @IBOutlet weak var numberOfWords: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBAction func editButtonTapped(_ sender: UIButton) {
    }
    @IBOutlet weak var renameList: UIButton!
    @IBAction func renameList(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Rename list", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let renameAction = UIAlertAction(title: "rename", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            let newListName = alertController.textFields![0] as UITextField
            let listName = newListName.text
            if listName != "" {
                self.message = ""
                var finalListName = listName
                var listNameIsConflicted = true
                var indexOfSameName = 0
                self.lists = CoreDataHelper.retrieveLists()
                while listNameIsConflicted {
                    if self.lists[self.row].name == listName {
                        break
                    }
                    listNameIsConflicted = false
                    indexOfSameName += 1
                    for list in self.lists {
                        if list.name == finalListName {
                            finalListName = listName! + " (" + String(indexOfSameName) + ")"
                            listNameIsConflicted = true
                            break
                        }
                    }
                }
                self.lists[self.row].name = finalListName
                CoreDataHelper.saveList()
                self.table?.reloadData()
            } else {
                self.message = "List name cannot be empty!"
                self.renameList(self.renameList)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            self.message = ""
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Please Enter List Name"
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(renameAction)
        
        firstViewController()?.present(alertController, animated: true, completion: nil)
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
    
    func firstViewController() -> UIViewController? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self){
                    return responder as? UIViewController
                }
            }
        }
        return nil
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
