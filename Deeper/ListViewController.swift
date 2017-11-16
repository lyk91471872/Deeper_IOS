//
//  ListViewController.swift
//  Deeper
//
//  Created by 罗宇康 on 2017/7/31.
//  Copyright © 2017年 lyk91471872. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    var lists = [ListMO]()
    var rowOfList = Int()
    var words = [Word]()
    var thisList = ListMO()
    
    func reloadList() {
        lists = CoreDataHelper.retrieveLists()
        thisList = lists[rowOfList]
        words = thisList.listToWord?.allObjects as! [Word]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadList()
        self.title = "\(thisList.name ?? "Word List") (\(thisList.listToWord?.count ?? 0) words)"
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add New Words", message: "Please choose a way to add words.", preferredStyle: UIAlertControllerStyle.alert)
        
        let manualAction = UIAlertAction(title: "Manual", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            self.performSegue(withIdentifier: "toManual", sender: self)
            /*//let addListName = alertController.textFields![0] as UITextField
            
            let list = CoreDataHelper.newList()
            //list.name = addListName.text
            
            CoreDataHelper.saveList()
            
            self.lists = CoreDataHelper.retrieveLists()
            
            self.tableView.reloadData()*/
        })
        
        let scanAction = UIAlertAction(title: "Scan", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
            self.performSegue(withIdentifier: "toScan", sender: self)
        })
        
        alertController.addAction(scanAction)
        alertController.addAction(manualAction)
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if let identifier = segue.identifier {
            
            if identifier == "toManual" {
                let manualAddWordViewController = segue.destination as! ManualAddWordViewController
                manualAddWordViewController.rowOfList = rowOfList
                manualAddWordViewController.isEditWord = false
            } else if identifier == "editWord"{
                let senderButton = sender as! UIButton
                let manualAddWordViewController = segue.destination as! ManualAddWordViewController
                manualAddWordViewController.rowOfList = rowOfList
                manualAddWordViewController.rowOfWord = senderButton.tag
                manualAddWordViewController.isEditWord = true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath) as! wordCell
        cell.editButton.tag = indexPath.row
        cell.wordEnglish.text = words[indexPath.row].english
        cell.wordChinese.text = words[indexPath.row].chinese
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let thisWord = words[indexPath.row]
            CoreDataHelper.deleteWord(word: thisWord)
            reloadList()
            self.tableView.reloadData()
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
