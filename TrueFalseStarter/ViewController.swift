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

//Entirely borrowed this elegant enum by Pasan
enum ColorComponents {
	case RGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
	case HSB(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)
	
	func color() -> UIColor {
		switch  self {
		case .RGB(let redVale, let greenValue, let blueValue, let alphaValue):
			return UIColor(red: redVale/255.0, green: greenValue/255.0, blue: blueValue/255.0, alpha: alphaValue)
		case .HSB(let hueValue, let saturationValue, let brightnessValue, let alphaValue):
			return UIColor(hue: hueValue/360.0, saturation: saturationValue/100.0, brightness: brightnessValue/100.0, alpha: alphaValue)
			
		}
	}
}

class ViewController: UIViewController {
    
    let questionsPerRound = 4
    //var questionsAsked = 0
	var correctAnswers: Int?// = 0
	
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
//    @IBOutlet weak var trueButton: UIButton!
//    @IBOutlet weak var falseButton: UIButton!

	@IBOutlet weak var infoLabel: UILabel!
	@IBOutlet weak var funcButton: UIButton!
	@IBOutlet weak var buttonStack: UIStackView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//infoLabel.text = ""
        //loadGameStartSound()
        // Start game
        //playGameStartSound()
		
//		questions = triviaModel.shuffledQuestions()
//		indexOfSelectedQuestion = 0
//		
//        displayQuestion()
		
		setupButtonStack()
		
		nextRound()
		
		
    }
	
	func setupButtonStack() {
		
//		buttonStack.axis = .Vertical
//		buttonStack.distribution = .EqualSpacing
//		buttonStack.alignment = .Leading
//		//buttonsContainer.spacing = 8
//		buttonStack.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//		buttonStack.layoutMarginsRelativeArrangement = true
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	func displayQuestion(questionIndex: Int) {
		
		//removeButtonsFrom(buttonContainer)
		removeButtonsFrom(buttonStack)
		
		if let questions = questions {
			
			if questionIndex < questions.count {
			
				questionItem = questions[questionIndex]
				
				if let questionItem = questionItem {
					
					questionField.text = questionItem.question
					
					processLabel(infoLabel, text: "", textColor: ColorComponents.RGB(red: 18, green: 101, blue: 132, alpha: 1))
					
					if let options = questionItem.options {
						
						for i in 0..<options.count {
							
							addButtonStack(buttonStack, text: options[i].optionText, tag: i, color: ColorComponents.RGB(red: 18, green: 101, blue: 132, alpha: 1))
						}
					}
				}
			}
		}
	}
	
	func displayGameOver(questionsCount: Int) {
		
		print("Game over")
		
		var messageText = ""
		
		if let correctAnswers = correctAnswers {
			
			messageText = "Way to go!\nYou got \(correctAnswers) out of \(questionsCount) correct!"
			
			
		} else {
			
			messageText = "Well, it's embarrassing, but the number of correct answers couldn't be retreived."
		}
		
		questionField.text = messageText
		
		funcButton.setTitle("Play Again", forState: .Normal)
	}
	
    func displayScore() {
        // Hide the answer buttons
//        trueButton.hidden = true
//        falseButton.hidden = true
		
        // Display play again button
        //playAgainButton.hidden = false
        
        questionField.text = "Way to go!\nYou got \(correctAnswers) out of \(questionsPerRound) correct!"
        
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
		
		//playAgainButton.hidden = true
		questions = triviaModel.shuffledQuestions()
		indexOfSelectedQuestion = 0
		correctAnswers = 0
		
		if let questionIndex = indexOfSelectedQuestion {
		
			displayQuestion(questionIndex)
			
		}
		
		//infoLabel.text = ""
		
		funcButton.setTitle("Next Question", forState: .Normal)//.titleLabel?.text = "Next Question"
//        }
    }
    
//    @IBAction func playAgain() {
//        // Show the answer buttons
////        trueButton.hidden = false
////        falseButton.hidden = false
//		
//        //questionsAsked = 0
//		
//        nextRound()
//    }
	
	@IBAction func processFuncButtonAction() {
		
		indexOfSelectedQuestion? += 1
		
//		if let questions = questions {
//			
//			if indexOfSelectedQuestion >= questions.count {
//				
//				displayGameOver(questions.count)
//			}
//		}
		
		if let questions = questions, questionIndex = indexOfSelectedQuestion {
			
			//Next question
			if questionIndex < questions.count {
				
				//infoLabel.text = ""
				
				//removeButtonsFrom(buttonContainer)
				
				displayQuestion(questionIndex)
				
			} else if questionIndex == questions.count {
				
				displayGameOver(questions.count)
				
			} else {
			
				//Play again
				nextRound()
			}
		}
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
	
	func addButtonStack(view: UIStackView, text: String, tag: Int, color: ColorComponents) {
		
		let button = UIButton()
		button.backgroundColor = color.color()
		button.setTitle(text, forState: .Normal)
		button.addTarget(self, action: #selector(answersButtonAction), forControlEvents: .TouchUpInside)
		
		button.tag = tag
		
		view.addArrangedSubview(button)
	}
	
//	func addButton(text: String, tag: Int, buttonStack: UIStackView, color: ColorComponents) {
//		
//		let button = UIButton(frame: CGRect(x: 0, y: 0, width: 250, height: 30))
//		
//		button.backgroundColor = color.color()
//		button.setTitle(text, forState: .Normal)
//		button.addTarget(self, action: #selector(answersButtonAction), forControlEvents: .TouchUpInside)
//		
//		button.tag = tag
//		
//		button.translatesAutoresizingMaskIntoConstraints = false
//		
//		
//		buttonStack.addSubview(button)
//	}
	
	func  removeButtonsFrom(superView: UIView) {
		
		for subView in superView.subviews {
			
			if subView is UIButton {
				
				subView.removeFromSuperview()
			}
		}
	}
	
	func repaintButtonsExcept(superView: UIView, pickedTag: Int) {
		
		for subView in superView.subviews {
			
			if let button = subView as? UIButton {
			
				button.backgroundColor = ColorComponents.RGB(red: 11, green: 47, blue: 66, alpha: 1).color()
				
				if button.tag != pickedTag {
					
					button.setTitleColor(ColorComponents.RGB(red: 55, green: 77, blue: 90, alpha: 1).color(), forState: .Normal)
					
				} else {

					button.setTitleColor(.whiteColor(), forState: .Normal)
				}
				
				button.enabled = false
			}
		}
	}
	
	func processLabel(label: UILabel, text: String, textColor: ColorComponents) {
		
		label.text = text
		label.textColor = textColor.color()
	}
	
	func answersButtonAction(sender: UIButton!) {
		
		if let questionItem = questionItem  {
			
			if let correct = questionItem.isCorrectOption(sender.tag) {
				
				if correct {
					
					processLabel(infoLabel, text: "Correct!", textColor: ColorComponents.RGB(red: 90, green: 187, blue: 181, alpha: 1))
					
					correctAnswers? += 1
					
				} else {
					
					processLabel(infoLabel, text: "Sorry, that's not it.", textColor: ColorComponents.RGB(red: 254, green: 147, blue: 81, alpha: 1))
				}
				
			} else {
				
				processLabel(infoLabel, text: "Unable to evaluate your answer. o_O", textColor: ColorComponents.RGB(red: 254, green: 147, blue: 81, alpha: 1))
			}
		} else {
			
			processLabel(infoLabel, text: "Unable to determine the question you've answered. o_O", textColor: ColorComponents.RGB(red: 254, green: 147, blue: 81, alpha: 1))
		}
		
		repaintButtonsExcept(buttonStack, pickedTag: sender.tag)
	}
}

