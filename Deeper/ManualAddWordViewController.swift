//
//  ViewController.swift
//  Deeper
//
//  Created by 罗宇康 on 2017/8/1.
//  Copyright © 2017年 lyk91471872. All rights reserved.
//

import UIKit

class ManualAddWordViewController: UIViewController, UITextFieldDelegate {
    var isEditWord = Bool()
    var rowOfList = Int()
    var rowOfWord = Int()
    var lists = [ListMO]()
    var words = [Word]()
    var thisList = ListMO()
    //var word = Word()
    @IBOutlet var textFieldEnglish: UITextField!
    @IBOutlet var textFieldChinese: UITextField!
    @IBOutlet weak var fadingAlert: UITextField!

    func reloadList() {
        lists = CoreDataHelper.retrieveLists()
        thisList = lists[rowOfList]
        words = thisList.listToWord?.allObjects as! [Word]
    }
    
    func showFadingAlert(_ text: String) {
        fadingAlert.text = text
        fadingAlert.alpha = 1
        fadingAlert.isHidden = false
        UIView.animate(withDuration: 2.5, animations: {
            self.fadingAlert.alpha = 0
        }, completion: {
            (value: Bool) in
            self.fadingAlert.isHidden = true
        })

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadList()
        self.title = thisList.name
        textFieldEnglish.delegate = self
        textFieldChinese.delegate = self
        if isEditWord == true {
            textFieldEnglish.text = words[rowOfWord].english
            textFieldChinese.text = words[rowOfWord].chinese
        } else {
            self.textFieldEnglish.becomeFirstResponder()
        }
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        var flag = 0
        for word in words {
            if word.english == self.textFieldEnglish.text {
                flag = 1
                break
            }
        }
        //print(textField.tag)
        //self.textFieldChinese.becomeFirstResponder()
        if flag == 0 {
            if textField.restorationIdentifier == "english" {
                if self.textFieldEnglish.text != "" {
                    if isEditWord == true {
                        let word = words[rowOfWord]
                        word.english = textFieldEnglish.text
                        CoreDataHelper.saveList()
                        showFadingAlert("Change Saved")
                    } else {
                        self.textFieldChinese.becomeFirstResponder()
                    }
                } else {
                    showFadingAlert("Cannot Add Empty Word")
                }
            } else {
                if self.textFieldChinese.text != "" {
                    if isEditWord == false {
                        if self.textFieldEnglish.text != "" {
                            let word = CoreDataHelper.newWord()
                            word.english = textFieldEnglish.text
                            word.chinese = textFieldChinese.text
                            word.familiarity = 0
                            thisList.addToListToWord(word)
                            CoreDataHelper.saveList()
                            
                            textFieldEnglish.text = ""
                            textFieldChinese.text = ""
                            self.textFieldEnglish.becomeFirstResponder()
                            reloadList()
                            showFadingAlert("Word Added")
                        } else {
                            showFadingAlert("Cannot Add Empty Word")
                        }
                    }
                } else {
                    showFadingAlert("Cannot Add Empty Word")
                }
            }
        } else if isEditWord == true {
            if textField.restorationIdentifier == "chinese" {
                let word = words[rowOfWord]
                word.chinese = textFieldChinese.text
                CoreDataHelper.saveList()
                showFadingAlert("Change Saved")
            }
        } else {
            showFadingAlert("\(textFieldEnglish.text ?? "The word") has already existed")
        }
        // Do not add a line break
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
