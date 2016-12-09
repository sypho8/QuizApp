//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Initialize Game class object
    let game = Game()
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var isCorrectLable: UILabel!
    @IBOutlet weak var firstAnswerButton: UIButton!
    @IBOutlet weak var secondAnswerButton: UIButton!
    @IBOutlet weak var thirdAnswerButton: UIButton!
    @IBOutlet weak var fourthAnswerButton: UIButton!
    @IBOutlet weak var nextMoveButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    
    @IBOutlet weak var fourthButtonHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Load game sounds
        game.loadGameSounds()
        
        // Start game
        game.playGameStartSound()

        // Display question
        displayQuestion()
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Display the score of the game
    func displayScore() {
        
        // Hide the answer buttons
        firstAnswerButton.isHidden = true
        secondAnswerButton.isHidden = true
        thirdAnswerButton.isHidden = true
        fourthAnswerButton.isHidden = true
        
        // Display play again button
        playAgainButton.isHidden = false
        
        // Hide the next move button and the isCorrect lable
        nextMoveButton.isHidden = true
        isCorrectLable.isHidden = true
        
        // Change the title of the next button to "Next Question"
        nextMoveButton.setTitle("Next Question", for: .normal)
        
        // Show the score to the user
        let score = game.getScore()
        questionField.text = "Way to go!\nYou got \(score.correctQuestions) out of \(score.questionsPerRound) correct!"
        
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        
        // Check if question was already answered
        if !game.isQuestionAnswered() {
            
            // Set answerIndex value according to the sender (the answer button)
            var answerIndex = 0
            switch sender {
            case firstAnswerButton: answerIndex = 0
            case secondAnswerButton: answerIndex = 1
            case thirdAnswerButton: answerIndex = 2
            case fourthAnswerButton: answerIndex = 3
            default: break
            }
            
            // Get the correct answer index (answer.correctIndex) and submitted answer (answerIndex) correctness (answer.isCorrect)
            let answer = game.checkAnswerOfCurrentQuestion(withAnswerIndex: answerIndex)
            
            // Display to the user if the answer is correct or not (different color and text, in both cases unhide the lable) and play the corresponding sound
            if answer.isCorrect {
                isCorrectLable.textColor = UIColor(red: 1/255.0, green: 146/255.0, blue: 135/255.0, alpha: 1)
                isCorrectLable.text = "Correct!"
                game.playCorrectSound()
            } else {
                isCorrectLable.textColor = UIColor(red: 255/255.0, green: 127/255.0, blue: 0, alpha: 1)
                isCorrectLable.text = "Sorry, that's not it."
                game.playIncorrectSound()
            }
            isCorrectLable.isHidden = false
            
            // Highlight correct answer
            displayCorrectAnswerWith(index: answer.correctIndex)
            
            // Show the next move button
            nextMoveButton.isHidden = false
            
        }

    }
    
    // Highlight the correct answer
    func displayCorrectAnswerWith(index: Int) {
        
        // Change buttons opacity
        firstAnswerButton.alpha = 0.5
        secondAnswerButton.alpha = 0.5
        thirdAnswerButton.alpha = 0.5
        fourthAnswerButton.alpha = 0.5
        
        // Switch on the index supplied and highlight the corresponding button
        switch index {
        case 0:
            firstAnswerButton.alpha = 1
            firstAnswerButton.backgroundColor?.withAlphaComponent(0.5)
        case 1:
            secondAnswerButton.alpha = 1
            secondAnswerButton.backgroundColor?.withAlphaComponent(0.5)
        case 2:
            thirdAnswerButton.alpha = 1
            thirdAnswerButton.backgroundColor?.withAlphaComponent(0.5)
        case 3:
            fourthAnswerButton.alpha = 1
            fourthAnswerButton.backgroundColor?.withAlphaComponent(0.5)
        default: break
        }
        
    }
    
    // Start lightning round if it's enabled
    func startLightningIfEnabled() {
        
        // Check if lightning mode is enabled
        if game.isLightning() {
            
            // Get current question index
            let currentQuestionIndex = game.getCurrentQuestionIndex()
            // Converts a delay in seconds to nanoseconds as signed 64 bit integer
            let delay = Int64(NSEC_PER_SEC * UInt64(game.getLightningTime()))
            // Calculates a time value to execute the method given current time and delay
            let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
            
            // Executes the onTimeout method at the dispatch time on the main queue
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                // Check if the game is not over
                if !self.game.isOver() {
                    // Check if the question asked when initiated is still the current question and if the question wasn't already answered, initiate onTimeout function
                    if currentQuestionIndex == self.game.getCurrentQuestionIndex() && !self.game.isQuestionAnswered(){
                        self.onTimeout()
                    }
                }
            }
            
        }
        
    }
    
    // Handle lightning round timeout
    func onTimeout() {
        
        // Get the correct answer index
        let answerIndex = game.getAnswerOfCurrentQuestion()
        
        // Notify the user that the time was up and play the corresponding sound
        isCorrectLable.textColor = UIColor(red: 255/255.0, green: 0, blue: 0, alpha: 1)
        isCorrectLable.text = "Bummer.. keep up the time!"
        game.playOutOfTimeSound()
        isCorrectLable.isHidden = false
        
        // Highlight correct answer
        displayCorrectAnswerWith(index: answerIndex)
        
        // Show next move button
        nextMoveButton.isHidden = false
        
    }
    
    // Get next question and display to user
    func displayQuestion() {
        
        // Hide isCorrect lable
        isCorrectLable.isHidden = true
        
        // Get next question
        let questionToDisplay = game.getNextQuestion()
        
        // Display the question to the user
        questionField.text = questionToDisplay.question
        
        // Reset alpha to 1 and display the possible answers
        firstAnswerButton.alpha = 1
        firstAnswerButton.setTitle(questionToDisplay.possibleAnswers[0],for: .normal)
        secondAnswerButton.alpha = 1
        secondAnswerButton.setTitle(questionToDisplay.possibleAnswers[1],for: .normal)
        thirdAnswerButton.alpha = 1
        thirdAnswerButton.setTitle(questionToDisplay.possibleAnswers[2],for: .normal)
        fourthAnswerButton.alpha = 1
        
        // If question has 4th option display possible answer and resize height to normal
        // Else resize height to 0 and set title to ""
        if questionToDisplay.hasFourthOption() {
            fourthButtonHeightConstraint.constant = 50.0
            fourthAnswerButton.setTitle(questionToDisplay.possibleAnswers[3],for: .normal)
        } else {
            fourthAnswerButton.setTitle("", for: .normal)
            fourthButtonHeightConstraint.constant = 0.0
        }
        
        // Start lightning round if enabled
        startLightningIfEnabled()

    }
    
    @IBAction func nextMove() {
        
        // If game is over display score
        // Else if this is the last round of the game change the next move button text to "View Score" and display next question
        // Else display question
        if game.isOver() {
            displayScore()
        } else if game.isLastRound() {
            nextMoveButton.setTitle("View Score", for: .normal)
            nextMoveButton.isHidden = true
            
            displayQuestion()
        } else {
            nextMoveButton.isHidden = true
            
            displayQuestion()
        }
        
    }
    
    @IBAction func playAgain() {
        
        // Show the answer buttons
        firstAnswerButton.isHidden = false
        secondAnswerButton.isHidden = false
        thirdAnswerButton.isHidden = false
        fourthAnswerButton.isHidden = false
        
        // Hide play again button
        playAgainButton.isHidden = true
        
        // Reset game values
        game.playAgain()
        
        // Display question
        displayQuestion()
    
    }

}

