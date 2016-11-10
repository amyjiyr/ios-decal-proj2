//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    // initialize the display things
    let nameLabel: UILabel = UILabel()
    let incorrectLabel: UILabel = UILabel()
    let inputTxtField: UITextField = UITextField()
    var wordArray : [Character] = []
    var incorrectArray : [String] = []
    var guessArray : [String] = []
    var guess:String = ""
    var hangmanImage = UIImageView(frame:CGRect(x:10, y:30, width:100, height:100))
    var winBox: UIAlertController = UIAlertController()
    var failBox: UIAlertController = UIAlertController()
    var finalView: UIView = UIView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        let phrase = hangmanPhrases.getRandomPhrase()
        
        // initialize stuff
        wordArray = []
        incorrectArray  = []  // create the array that stores incorrect guesses
        guessArray  = []
        guess = ""
        
        //creating the hangman image
        hangmanImage.image = UIImage(named: "hangman1.gif")
        self.view.addSubview(hangmanImage)
        
        // initializing the data strucutres
        // create the array that stores the phrase's characters
        let strphrase = phrase! as String
        
        // create the array that stores the positions
        for c in strphrase.characters {
            wordArray.append(c)
            if (String(c) != " ") {
                guessArray.append("_")
            } else {
                guessArray.append(" ")
            }
            
        }
        let screen = UIScreen.main.bounds.size;
        
        // creating the UI label that displays the guessArray
        nameLabel.numberOfLines = 10
        nameLabel.frame = CGRect(x:10, y:screen.height/2 - 200, width:screen.width - 10, height:80)
        nameLabel.backgroundColor = UIColor(white: 1, alpha: 0.5)
        nameLabel.textColor = UIColor.orange
        nameLabel.textAlignment = NSTextAlignment.left
        nameLabel.lineBreakMode = NSLineBreakMode.byCharWrapping
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont(name: "Arial", size: 20)
        // making the display array
        let inputtext = guessArray.joined(separator: " ")
        nameLabel.text = inputtext
        self.view.addSubview(nameLabel)
        
        // creating the UI label that displays the incorrectArray
        incorrectLabel.numberOfLines = 0
        incorrectLabel.frame = CGRect(x:10, y:screen.height/2 - 100, width:screen.width - 10, height:21)
        incorrectLabel.backgroundColor = UIColor(white: 1, alpha: 0.5)
        incorrectLabel.textColor = UIColor.orange
        incorrectLabel.textAlignment = NSTextAlignment.left
        incorrectLabel.font = UIFont(name: "Arial", size: 20)
        // making the display array
        let incorrect = incorrectArray.joined(separator: " ")
        incorrectLabel.text = "Incorrect Guesses: " + incorrect
        self.view.addSubview(incorrectLabel)
        
        // creating the textfield for users to enter their guesses
        inputTxtField.frame = CGRect(x:10, y:screen.height/2 - 50, width:screen.width - 10, height:21)
        inputTxtField.backgroundColor = UIColor(white: 1, alpha: 0.5)
        inputTxtField.placeholder = "Please put yout guess here, then press Enter"
        inputTxtField.textColor = UIColor.orange
        inputTxtField.clearsOnBeginEditing = true
        inputTxtField.isUserInteractionEnabled = true
        self.view.addSubview(inputTxtField)
        
        // creating the button that begins guessing
        let startButton = UIButton(type: UIButtonType.custom) as UIButton
        startButton.backgroundColor = UIColor.orange
        startButton.frame = CGRect(x:110, y:screen.height/2, width:100, height:50)
        startButton.setTitle("GUESS", for: UIControlState.normal)
        startButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        startButton.addTarget(self, action: "buttonPressed", for: UIControlEvents.touchDown)
        self.view.addSubview(startButton)
    }
    
    func buttonPressed() {
        var found = 0
        guess = inputTxtField.text!
        if ((String(guess)?.characters.count)! > 1) {
            inputTxtField.placeholder = "Please only enter 1 character!"
        } else {
            var diff = 0
            for (i, c) in wordArray.enumerated() {
                if (String(guess).lowercased() == String(c).lowercased()) {
                    // if guessed correctly, update the display array
                    found = 1
                    if (guessArray.contains(guess.lowercased())) {
                        inputTxtField.placeholder = "You already guessed this character correctly!"
                    } else {
                        inputTxtField.placeholder = "Please put yout guess here, then press Enter"
                    }
                    guessArray[i] = guess.lowercased()
                    let inputguess = guessArray.joined(separator: " ")
                    nameLabel.text = inputguess
                }
                // checking how many letters differ
                if (guessArray[i].lowercased() != String(c).lowercased()) {
                    diff = diff + 1
                }
            }
            // if guessArray is the same as wordArray, we won!
            if (diff == 0) {
                win()
            }
            if (found == 0) {
                if (incorrectArray.contains(guess.lowercased()) == false) {
                    inputTxtField.placeholder = "Not right, guess again!"
                    inputTxtField.clearsOnInsertion = true
                    
                    // updating the incorrect array and label
                    incorrectArray.append(guess.lowercased())
                    let incorrect = incorrectArray.joined(separator: " ")
                    incorrectLabel.text = "Incorrect Guesses: " + incorrect
                    
                    // updating the hangman image
                    var hangimage = "hangman" + String(incorrectArray.count + 1) + ".gif"
                    hangmanImage.image = UIImage(named: hangimage)
                    
                    // checking if dead
                    if (incorrectArray.count > 5) {
                        fail()
                    }
                } else {
                    if (incorrectArray != []) {
                        inputTxtField.placeholder = "You already guessed this character!"
                    }
                }
            }
        }
        inputTxtField.text = ""
    }
    
    func win() {
        winBox = UIAlertController(title: "DONE!", message: "YOU WON!", preferredStyle: .alert)
        let firstAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: final)
        winBox.addAction(firstAction)
        present(winBox, animated: true, completion:nil)
    }
    
    func fail() {
        failBox = UIAlertController(title: "Fail", message: "Out of attempts", preferredStyle: .alert)
        let firstAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: final)
        failBox.addAction(firstAction)
        present(failBox, animated: true, completion:nil)
    }
    
    func final(alert: UIAlertAction) {
        viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
