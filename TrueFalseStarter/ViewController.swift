//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let game = Game()
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var isCorrectLable: UILabel!
    @IBOutlet weak var firstAnswerButton: UIButton!
    @IBOutlet weak var secondAnswerButton: UIButton!
    @IBOutlet weak var thirdAnswerButton: UIButton!
    @IBOutlet weak var fourthAnswerButton: UIButton!
    @IBOutlet weak var nextMoveButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        game.loadGameStartSound()
        // Start game
        game.playGameStartSound()

        displayQuestion()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayScore() {
        
        // Hide the answer buttons
        firstAnswerButton.isHidden = true
        secondAnswerButton.isHidden = true
        thirdAnswerButton.isHidden = true
        fourthAnswerButton.isHidden = true
        
        // Display play again button
        nextMoveButton.isHidden = true
        nextMoveButton.setTitle("Next Question", for: .normal)
        playAgainButton.isHidden = false
        isCorrectLable.isHidden = true
        
        let score = game.getScore()
        
        questionField.text = "Way to go!\nYou got \(score.correctQuestions) out of \(score.questionsPerRound) correct!"
        
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        
        if  !game.isAnswered() {
        
            var answerIndex = 0
            
            switch sender {
            case firstAnswerButton: answerIndex = 0
            case secondAnswerButton: answerIndex = 1
            case thirdAnswerButton: answerIndex = 2
            case fourthAnswerButton: answerIndex = 3
            default: break
            }
        
            let answer = game.checkAnswerOfCurrentQuestion(withAnswerIndex: answerIndex)
            
            if answer.isCorrect {
                isCorrectLable.textColor = UIColor(red: 1/255.0, green: 146/255.0, blue: 135/255.0, alpha: 1)
                isCorrectLable.text = "Correct!"
            } else {
                isCorrectLable.textColor = UIColor(red: 255/255.0, green: 127/255.0, blue: 0, alpha: 1)
                isCorrectLable.text = "Sorry, that's not it."
            }
            
            isCorrectLable.isHidden = false
            
            displayCorrectAnswerWith(index: answer.index)
            
            nextMoveButton.isHidden = false
            
        }

    }
    
    func displayCorrectAnswerWith(index: Int) {
        
        firstAnswerButton.alpha = 0.5
        secondAnswerButton.alpha = 0.5
        thirdAnswerButton.alpha = 0.5
        fourthAnswerButton.alpha = 0.5
        
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
    
    func startLightningIfEnabled() {
        
        if game.isLightning() {
            let currentQuestionIndex = game.getCurrentQuestionIndex()
            // Converts a delay in seconds to nanoseconds as signed 64 bit integer
            let delay = Int64(NSEC_PER_SEC * UInt64(game.getLightningTime()))
            // Calculates a time value to execute the method given current time and delay
            let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
            
            // Executes the nextRound method at the dispatch time on the main queue
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                if !self.game.isOver() {
                    if currentQuestionIndex == self.game.getCurrentQuestionIndex() && !self.game.isAnswered(){
                        self.onTimeout()
                    }
                }
            }
        }
        
    }
    
    func onTimeout() {
        
        let answerIndex = game.checkAnswerOfCurrentQuestion()
        
        isCorrectLable.textColor = UIColor(red: 255/255.0, green: 0, blue: 0, alpha: 1)
        isCorrectLable.text = "Bummer.. keep up the time!"
        isCorrectLable.isHidden = false
        
        displayCorrectAnswerWith(index: answerIndex)
        
        nextMoveButton.isHidden = false
        
    }
    
    func displayQuestion() {
        
        isCorrectLable.isHidden = true
        firstAnswerButton.alpha = 1
        secondAnswerButton.alpha = 1
        thirdAnswerButton.alpha = 1
        fourthAnswerButton.alpha = 1
        
        let questionToDisplay = game.getNextQuestion()
        
        questionField.text = questionToDisplay.question
        firstAnswerButton.setTitle(questionToDisplay.possibleAnswers[0],for: .normal)
        secondAnswerButton.setTitle(questionToDisplay.possibleAnswers[1],for: .normal)
        thirdAnswerButton.setTitle(questionToDisplay.possibleAnswers[2],for: .normal)
        fourthAnswerButton.setTitle(questionToDisplay.possibleAnswers[3],for: .normal)
        
        startLightningIfEnabled()

    }
    
    @IBAction func nextMove() {
        
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
        
        playAgainButton.isHidden = true
        
        game.playAgain()
        
        displayQuestion()
    
    }
    
    
    // MARK: Helper Methods
    

}

