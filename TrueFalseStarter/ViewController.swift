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

	var correctAnswers: Int?// = 0
	
	var indexOfSelectedQuestion: Int?
	
	var questions: [Question]?
	var questionItem: Question?
    
    var gameSound: SystemSoundID = 0
	
	var autoGame: Bool = false
	
	let triviaModel = TriviaModel()
	
    @IBOutlet weak var questionField: UILabel!
	@IBOutlet weak var infoLabel: UILabel!
	@IBOutlet weak var funcButton: UIButton!
	@IBOutlet weak var buttonStack: UIStackView!
	
	let questionButtonColor = ColorComponents.RGB(red: 18, green: 101, blue: 132, alpha: 1)
	let dimmedQButtonColor = ColorComponents.RGB(red: 11, green: 47, blue: 66, alpha: 1)
	let dimmedQButtonTitleColor = ColorComponents.RGB(red: 55, green: 77, blue: 90, alpha: 1)
	let lightningModeButtonColor = ColorComponents.RGB(red: 255, green: 128, blue: 0, alpha: 1)
	let correctAnswerLabelColor = ColorComponents.RGB(red: 90, green: 187, blue: 181, alpha: 1)
	let wrongAnswerLabelColor = ColorComponents.RGB(red: 254, green: 147, blue: 81, alpha: 1)
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		infoLabel.text = ""
		
		nextRound()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	func displayQuestion(questionIndex: Int) {
		
		removeButtonsFrom(buttonStack)
		
		if let questions = questions {
			
			questionItem = questions[questionIndex]
			
			if let questionItem = questionItem {
				
				questionField.text = questionItem.question
				
				processLabel(infoLabel, text: "", textColor: ColorComponents.RGB(red: 18, green: 101, blue: 132, alpha: 1))
				
				if let options = questionItem.options {
					
					for i in 0..<options.count {
						
						addAnswerOptionButtonTo(stack: buttonStack, text: options[i].optionText, tag: i, color: questionButtonColor)
					}
				}
			}
		}
	}
	
	func displayGameOver(questionsCount: Int) {
		
		print("Game over")
		
		var messageText = ""
		
		if let correctAnswers = correctAnswers {
			
			loadGameOverSound()
			playSound()
			
			messageText = "Way to go!\nYou got \(correctAnswers) out of \(questionsCount) correct!"
			
			
		} else {
			
			loadErrorSound()
			playSound()
			
			messageText = "Well, it's embarrassing, but the number of correct answers couldn't be retreived."
		}
		
		questionField.text = messageText
		
		funcButton.setTitle("Play Again", forState: .Normal)
	}
	
	
    func nextRound() {
		
		loadGameStartSound()
		playSound()
		
		questions = triviaModel.shuffledQuestions()
		
		indexOfSelectedQuestion = 0
		correctAnswers = 0
		
		displayQuestion(indexOfSelectedQuestion!)
		
		funcButton.setTitle("Next Question", forState: .Normal)
    }
    
	
	@IBAction func processFuncButtonAction() {
		
		self.autoGame = false
		
		loadNextQuestionSound()
		playSound()
		
		indexOfSelectedQuestion? += 1
		
		if let questions = questions, questionIndex = indexOfSelectedQuestion {
			
			//Next question
			if questionIndex < questions.count {
				
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
		
		self.autoGame = true
		
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, delay)
        
        // Executes the nextRound method at the dispatch time on the main queue
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            //self.nextRound()
			
			if self.autoGame {
				self.processFuncButtonAction()
			}
        }
    }
	
	func soundUrlFor(file fileName: String, ofType: String) -> NSURL {
		
		let pathToSoundFile = NSBundle.mainBundle().pathForResource(fileName, ofType: ofType)
		return NSURL(fileURLWithPath: pathToSoundFile!)
	}
    
    func loadGameStartSound() {
		
		AudioServicesCreateSystemSoundID(soundUrlFor(file: "GameSound", ofType: "wav"), &gameSound)
    }
	
	func loadCorrectSound() {
		
		AudioServicesCreateSystemSoundID(soundUrlFor(file: "CorrectSound", ofType: "wav"), &gameSound)
	}
	
	func loadWrongSound() {
		
		AudioServicesCreateSystemSoundID(soundUrlFor(file: "WrongSound", ofType: "wav"), &gameSound)
	}
	
	func loadGameOverSound() {
		
		AudioServicesCreateSystemSoundID(soundUrlFor(file: "GameOverSound", ofType: "wav"), &gameSound)
	}
	
	func loadErrorSound() {
		
		AudioServicesCreateSystemSoundID(soundUrlFor(file: "ErrorSound", ofType: "wav"), &gameSound)
	}
	
	func loadNextQuestionSound() {
		
		AudioServicesCreateSystemSoundID(soundUrlFor(file: "NextQ", ofType: "wav"), &gameSound)
	}
	
	func playSound(){
		
		AudioServicesPlaySystemSound(gameSound)
	}
	
	
	func addAnswerOptionButtonTo(stack stackView: UIStackView, text: String, tag: Int, color: ColorComponents) {
		
		let button = UIButton()
		button.backgroundColor = color.color()
		button.setTitle(text, forState: .Normal)
		button.addTarget(self, action: #selector(answersButtonAction), forControlEvents: .TouchUpInside)
		
		button.tag = tag
		
		stackView.addArrangedSubview(button)
	}
	

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
			
				button.backgroundColor = dimmedQButtonColor.color()
				
				if button.tag != pickedTag {
					
					button.setTitleColor(dimmedQButtonTitleColor.color(), forState: .Normal)
					
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
					
					loadCorrectSound()
					playSound()
					
					processLabel(infoLabel, text: "Correct!", textColor: correctAnswerLabelColor)
					
					correctAnswers? += 1
					
				} else {
					
					loadWrongSound()
					playSound()
					
					processLabel(infoLabel, text: "Sorry, that's not it.", textColor: wrongAnswerLabelColor)
				}
				
			} else {
				
				loadErrorSound()
				playSound()
				
				processLabel(infoLabel, text: "Unable to evaluate your answer. o_O", textColor: wrongAnswerLabelColor)
			}
		} else {
			
			loadErrorSound()
			playSound()
			
			processLabel(infoLabel, text: "Unable to determine the question you've answered. o_O", textColor: wrongAnswerLabelColor)
		}
		
		repaintButtonsExcept(buttonStack, pickedTag: sender.tag)
		
		loadNextRoundWithDelay(seconds: 2)
	}

}

