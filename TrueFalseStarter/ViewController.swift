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
    @IBOutlet weak var firstAnswerButton: UIButton!
    @IBOutlet weak var secondAnswerButton: UIButton!
    @IBOutlet weak var thirdAnswerButton: UIButton!
    @IBOutlet weak var fourthAnswerButton: UIButton!
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
        playAgainButton.isHidden = false
        
        let score = game.getScore()
        
        questionField.text = "Way to go!\nYou got \(score.correctQuestions) out of \(score.questionsPerRound) correct!"
        
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        
        var answerIndex = 0
        
        switch sender {
        case firstAnswerButton: answerIndex = 0
        case secondAnswerButton: answerIndex = 1
        case thirdAnswerButton: answerIndex = 2
        case fourthAnswerButton: answerIndex = 3
        default: break
        }
        
        let result = game.checkAnswer(answerIndex: answerIndex)
        
        if result {
            questionField.text = "Correct!"
        } else {
            questionField.text = "Sorry, wrong answer!"
        }

        loadNextRoundWithDelay(seconds: 2)
    }
    
    func displayQuestion() {
        
        let questionToDisplay = game.getNextQuestion()
        
        questionField.text = questionToDisplay.question
        firstAnswerButton.setTitle(questionToDisplay.possibleAnswers[0],for: .normal)
        secondAnswerButton.setTitle(questionToDisplay.possibleAnswers[1],for: .normal)
        thirdAnswerButton.setTitle(questionToDisplay.possibleAnswers[2],for: .normal)
        fourthAnswerButton.setTitle(questionToDisplay.possibleAnswers[3],for: .normal)
        
    }
    
    func nextRound() {
        if game.isOver() {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() {
        // Show the answer buttons
        firstAnswerButton.isHidden = false
        secondAnswerButton.isHidden = false
        thirdAnswerButton.isHidden = false
        fourthAnswerButton.isHidden = false
        
        game.playAgain()
        
        nextRound()
    }
    

    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    

}

