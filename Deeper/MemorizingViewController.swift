//
//  MemorizingViewController.swift
//  Deeper
//
//  Created by 罗宇康 on 2017/8/3.
//  Copyright © 2017年 lyk91471872. All rights reserved.
//

import UIKit
import Foundation

class MemorizingViewController: UIViewController {
    var flag = 0
    var index = 0
    var timer = Timer()
    var rowOfList = Int()
    var lists = [ListMO]()
    var words = [Word]()
    var thisList = ListMO()
    var currentWordIndex = 0
    var currentWord = Word()
    
    @IBOutlet weak var numberOfWords: UILabel!
    @IBOutlet weak var labelEnglish: UILabel!
    @IBOutlet weak var labelChinese: UILabel!
    @IBOutlet weak var showExplanationButton: UIButton!
    @IBOutlet weak var doNotKnowButton: UIButton!
    @IBOutlet weak var unfamiliarButton: UIButton!
    @IBOutlet weak var knowButton: UIButton!
    @IBOutlet weak var veryFamiliarButton: UIButton!
    @IBOutlet var swipedLeftRecognizer: SwipedLeft!
    @IBOutlet var swipedDownRecognizer: SwipedDown!
    @IBOutlet var swipedRightRecognizer: SwipedRight!
    @IBOutlet var swipedUpRecognizer: SwipedUp!
    @IBOutlet var screenTappedRecognizer: ScreenTapped!

    @IBAction func showExplanationButtonTapped(_ sender: UIButton) {
        labelChinese.isHidden = false
        showExplanationButton.isHidden = true
        doNotKnowButton.isHidden = false
        unfamiliarButton.isHidden = false
        knowButton.isHidden = false
        veryFamiliarButton.isHidden = false
        enableGestures()
    }
    @IBAction func screenTapped(_ sender: Any) {
        labelChinese.isHidden = false
        showExplanationButton.isHidden = true
        doNotKnowButton.isHidden = false
        unfamiliarButton.isHidden = false
        knowButton.isHidden = false
        veryFamiliarButton.isHidden = false
        enableGestures()
    }
    @IBAction func doNotKnowButtonTapped(_ sender: UIButton) {
        currentWord.delay += 1
        familiaritySet(1)
    }
    @IBAction func swipedLeft(_ sender: Any) {
        currentWord.delay += 1
        familiaritySet(1)
    }
    @IBAction func unfamiliarButtonTapped(_ sender: UIButton) {
        currentWord.delay += 5
        familiaritySet(2)
    }
    @IBAction func swipedDown(_ sender: Any) {
        currentWord.delay += 5
        familiaritySet(2)
    }
    @IBAction func knowButtonTapped(_ sender: UIButton) {
        currentWord.delay += 10
        familiaritySet(3)
    }
    @IBAction func swipedRight(_ sender: Any) {
        currentWord.delay += 10
        familiaritySet(3)
    }
    @IBAction func veryFamiliarButtonTapped(_ sender: UIButton) {
        familiaritySet(4)
    }
    @IBAction func swipedUp(_ sender: Any) {
        familiaritySet(4)
    }
    
    func enableGestures() {
        swipedLeftRecognizer.isEnabled = true
        swipedDownRecognizer.isEnabled = true
        swipedRightRecognizer.isEnabled = true
        swipedUpRecognizer.isEnabled = true
        screenTappedRecognizer.isEnabled = false
    }
    
    func disableGestures() {
        swipedLeftRecognizer.isEnabled = false
        swipedDownRecognizer.isEnabled = false
        swipedRightRecognizer.isEnabled = false
        swipedUpRecognizer.isEnabled = false
        screenTappedRecognizer.isEnabled = true
    }
    
    func familiaritySet(_ familiarity: Int16) {
        currentWord.familiarity = familiarity
        CoreDataHelper.saveList()
        showExplanationButton.isHidden = false
        labelChinese.isHidden = true
        nextWordToShow()
        doNotKnowButton.isHidden = true
        unfamiliarButton.isHidden = true
        knowButton.isHidden = true
        veryFamiliarButton.isHidden = true
        numberOfWords.text = "Progress: \(getProgress())/\(String(words.count))"
        disableGestures()
    }
    
    func reloadList() {
        lists = CoreDataHelper.retrieveLists()
        thisList = lists[rowOfList]
        words = thisList.listToWord?.allObjects as! [Word]
    }
    
    func nextWordToShow() {
        var i = 0
        while true {
            currentWord = words[currentWordIndex]
            if currentWord.delay == 0 && currentWord.familiarity != 3 && currentWord.familiarity != 4 {
                index = 0
                labelEnglish.text = currentWord.english
                labelChinese.text = currentWord.chinese
                switch currentWord.familiarity {
                case 1:
                    labelEnglish.textColor = UIColor.red
                case 2:
                    labelEnglish.textColor = ColorHelper.covertColor("#047CFF")
                case 5:
                    labelEnglish.textColor = UIColor.green
                default:
                    labelEnglish.textColor = UIColor.black
                }
                break
            } else if index <= words.count {
                if currentWordIndex < words.count-1 {
                    currentWordIndex += 1
                    index += 1
                } else {
                    currentWordIndex = 0
                    index += 1
                }
            } else {
                index = 0
                for word in words {
                    if word.familiarity == 3 || word.familiarity == 4 {
                        i += 1
                    }
                }
                if i == words.count {
                    allMemorized()
                    break
                }
                i = 0
                while true {
                    for word in words {
                        if word.delay != 0 {
                            word.delay -= 1
                        } else if word.familiarity != 3 && word.familiarity != 4 {
                            flag = 1
                            break
                        }
                    }
                    if flag == 1 {
                        break
                    }
                }
                flag = 0
            }
        }
    }
    
    func allMemorized() {
        showExplanationButton.isHidden = true
        labelEnglish.text = "Congratulations!"
        labelEnglish.textColor = UIColor.black
        labelChinese.isHidden = false
        labelChinese.text = "All words memorized!"
    }
    
    func oneMinutePasts() {
        for word in self.words {
            if word.delay != 0 {
                word.delay -= 1
            }
        }
    }
    
    func getProgress() -> (Int) {
        var i = 0
        for word in words {
            if word.familiarity == 3 || word.familiarity == 4 {
                i += 1
            }
        }
        return i
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MemorizingViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        reloadList()
        self.title = thisList.name
        for word in words {
            switch word.familiarity {
            case 0:
                word.delay = 0
                break
            case 1:
                word.delay = 1
                break
            case 2:
                word.delay = 5
                break
            case 3:
                word.delay = 10
                word.familiarity = 5
                break
            case 4:
                break
            case 5:
                word.delay = 10
                break
            default:
                word.familiarity = 0
            }
        }
        numberOfWords.text = "Progress: \(getProgress())/\(String(words.count))"
        
        nextWordToShow()
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(MemorizingViewController.oneMinutePasts), userInfo: nil, repeats: true);
        // Do any additional setup after loading the view.

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        timer.invalidate()
        // Go back to the previous ViewController
        _ = navigationController?.popViewController(animated: true)
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
