//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    let questionsPerRound = 4
    //var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int?
	
	var questions: [Question]?
	var questionItem: Question?
    
    var gameSound: SystemSoundID = 0
    
//    let trivia: [[String : String]] = [
//        ["Question": "Only female koalas can whistle", "Answer": "False"],
//        ["Question": "Blue whales are technically whales", "Answer": "True"],
//        ["Question": "Camels are cannibalistic", "Answer": "False"],
//        ["Question": "All ducks are birds", "Answer": "True"]
//    ]
	

	let triviaModel = TriviaModel()
	
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
	@IBOutlet weak var buttonContainer: UIView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadGameStartSound()
        // Start game
        //playGameStartSound()
		
//		questions = triviaModel.shuffledQuestions()
//		indexOfSelectedQuestion = 0
//		
//        displayQuestion()
		
		nextRound()
		
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQuestion() {
		
//        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextIntWithUpperBound(trivia.count)
//        let questionDictionary =  /*triviaModel.shuffledQuestions()*/ trivia[indexOfSelectedQuestion]
//        questionField.text = /*questionDictionary![0].question */questionDictionary["Question"]
		
		if let questions = questions, indexOfSelectedQuestion = indexOfSelectedQuestion {
			
			if indexOfSelectedQuestion < questions.count {
			
				questionItem = questions[indexOfSelectedQuestion]
				
				if let questionItem = questionItem {
					
					questionField.text = questionItem.question
					
					if let options = questionItem.options {
						
						let x = 8
						var y = 8
						
						let buttonHeight = 50//Int((buttonContainer.frame.height - 16 - CGFloat((8 * (options.count - 1)))) / CGFloat(options.count))
						
						let buttonWidth = 250//buttonContainer.frame.width - 16
						
						for i in 0..<options.count {
							
							addButton(options[i].optionText, tag: i, x: x, y: y, w: buttonWidth, h: buttonHeight, view: buttonContainer)
							
							y += (buttonHeight + 8)
						}
					}
				}
			} else {
				
				print("Game over")
				
				playAgainButton.hidden = false
			}
		}
		
        //playAgainButton.hidden = true
    }
    
    func displayScore() {
        // Hide the answer buttons
        trueButton.hidden = true
        falseButton.hidden = true
		
        // Display play again button
        playAgainButton.hidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
    }
    
    @IBAction func checkAnswer(sender: UIButton) {
		
		//removeButtonsFrom(buttonContainer)
		
//        // Increment the questions asked counter
//        questionsAsked += 1
//        
//        let selectedQuestionDict = trivia[indexOfSelectedQuestion]
//        let correctAnswer = selectedQuestionDict["Answer"]
//        
//        if (sender === trueButton &&  correctAnswer == "True") || (sender === falseButton && correctAnswer == "False") {
//            correctQuestions += 1
//            questionField.text = "Correct!"
//        } else {
//            questionField.text = "Sorry, wrong answer!"
//        }
//		
//        loadNextRoundWithDelay(seconds: 2)
    }
    
    func nextRound() {
		
//        if questionsAsked == questionsPerRound {
//            // Game is over
//            displayScore()
//        } else {
            // Continue game
		
		playAgainButton.hidden = true
		questions = triviaModel.shuffledQuestions()
		indexOfSelectedQuestion = 0
		
		displayQuestion()
//        }
    }
    
    @IBAction func playAgain() {
        // Show the answer buttons
//        trueButton.hidden = false
//        falseButton.hidden = false
		
        //questionsAsked = 0
        correctQuestions = 0
        nextRound()
    }
    

    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, delay)
        
        // Executes the nextRound method at the dispatch time on the main queue
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            self.nextRound()
        }
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = NSBundle.mainBundle().pathForResource("GameSound", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
	
	func addButton(text: String, tag: Int, x: Int, y: Int, w: Int, h: Int, view: UIView) {
		
		let button = UIButton(frame: CGRect(x: x, y: y, width: w, height: h))
		button.backgroundColor = .blueColor()
		button.setTitle(text, forState: .Normal)
		button.addTarget(self, action: #selector(answersButtonAction), forControlEvents: .TouchUpInside)
		
		button.tag = tag
		
		view.addSubview(button)
	}
	
	func  removeButtonsFrom(superView: UIView) {
		
		for subView in buttonContainer.subviews {
			
			if subView is UIButton {
				
				subView.removeFromSuperview()
			}
		}
	}
	
	func answersButtonAction(sender: UIButton!) {
		
		guard let questionItem = questionItem else {
			
			print("Unable to determine question for evaluation")
			
			return
		}
		
		if let correct = questionItem.isCorrectOption(sender.tag) {
			
			if correct {
				
				print("Correct")
				
			} else {
				
				print("Incorrect")
			}
		} else {
			
			print("Incorrect")
		}
		
		indexOfSelectedQuestion? += 1
		
		removeButtonsFrom(buttonContainer)
		
		displayQuestion()
	}
}

