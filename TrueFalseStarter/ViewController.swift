//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
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

	var correctAnswers: Int = 0
	
	var questionIndex: Int = 0
	
	var questions: [Question]?
	var questionItem: Question?
    
    var gameSound: SystemSoundID = 0
	
	var lightningMode: Bool = true
	
	let triviaModel = TriviaModel()
	
	var gameModes = ["Normal", "Lightning mode\r\r(15 sec. per answer)"]
	var triviaTypes = ["Text-based", "Arithmetic", "Mixed"]
	
	var currentQuestionStatus: (qIndex: Int, answered: Bool) = (0, false)

    @IBOutlet weak var questionField: UILabel!
	@IBOutlet weak var infoLabel: UILabel!
	@IBOutlet weak var funcButton: UIButton!
	@IBOutlet weak var buttonStack: UIStackView!
	
	let questionButtonColor = ColorComponents.RGB(red: 18, green: 101, blue: 132, alpha: 1)
	let dimmedQButtonColor = ColorComponents.RGB(red: 11, green: 47, blue: 66, alpha: 1)
	let dimmedQButtonTitleColor = ColorComponents.RGB(red: 55, green: 77, blue: 90, alpha: 1)
	let lightningModeButtonColor = ColorComponents.RGB(red: 255, green: 128, blue: 0, alpha: 1)
	let lightnintModeBGColor = ColorComponents.RGB(red: 128, green: 0, blue: 0, alpha: 1)
	let correctColor = ColorComponents.RGB(red: 90, green: 187, blue: 181, alpha: 1)
	let wrongAnswerLabelColor = ColorComponents.RGB(red: 254, green: 147, blue: 81, alpha: 1)
	let dimmedFuncButtonColor = ColorComponents.RGB(red: 10, green: 81, blue: 72, alpha: 1)
	let dimmedFuncButtonTitleColor = ColorComponents.RGB(red: 170, green: 170, blue: 170, alpha: 1)
	let white = ColorComponents.RGB(red: 255, green: 255, blue: 255, alpha: 1)
	let normalBGColor = ColorComponents.RGB(red: 10, green: 32, blue: 47, alpha: 1)
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		infoLabel.text = ""
		
		requestGameMode()
    }
	
	func requestGameMode() {
		
		questionField.text = "Please Select Game Mode:"
		
		removeButtonsFrom(buttonStack)
		
		for i in 0..<gameModes.count {
			
			addGameModeOptionButtonTo(stack: buttonStack, text: gameModes[i], tag: i, color: questionButtonColor)
		}
		
		funcButton.hidden = true
	}
	
	func requestTriviaType() {
		
		questionField.text = "Please Select Trivia Type:"
		
		removeButtonsFrom(buttonStack)
		
		for i in 0..<triviaTypes.count {
			
			addTriviaTypeOptionButton(stack: buttonStack, text: triviaTypes[i], tag: i, color: questionButtonColor)
		}
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	func displayQuestion(questionIndex: Int) {
		
		removeButtonsFrom(buttonStack)
		
		setParamsFor(button: funcButton, color: dimmedFuncButtonColor, titleColor: dimmedFuncButtonTitleColor, enabled: false)
		
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
				
				currentQuestionStatus = (questionIndex, false)
				
				if lightningMode {
					
					loadNextRoundWithDelay(seconds: 5)
				}
			}
		}
	}
	
	func setParamsFor(button button: UIButton, color: ColorComponents, titleColor: ColorComponents, enabled: Bool) {
		
		button.backgroundColor = color.color()
		button.setTitleColor(titleColor.color(), forState: .Normal)
		button.enabled = enabled
	}
	
	func displayGameOver(questionsCount: Int) {
		
		print("Game over")
		
		var messageText = ""
		
		loadGameOverSound()
		playSound()
		
		messageText = "Way to go!\nYou got \(correctAnswers) out of \(questionsCount) correct!"
		
		questionField.text = messageText
		
		funcButton.setTitle("Play Again", forState: .Normal)
		
		setParamsFor(button: funcButton, color: correctColor, titleColor: white, enabled: true)
	}
	
	
	func nextRound(triviaType: TriviaModel.TriviaType) {
		
		loadGameStartSound()
		playSound()
		
		questions = triviaModel.shuffledQuestions(triviaType)
		
		questionIndex = 0
		correctAnswers = 0
		
		displayQuestion(questionIndex)
		
		funcButton.setTitle("Next Question", forState: .Normal)
    }
    
	
	@IBAction func processFuncButtonAction() {
		
		
		loadNextQuestionSound()
		playSound()
		
		questionIndex += 1
		
		if let questions = questions {
			
			//Next question
			if questionIndex < questions.count {
				
				displayQuestion(questionIndex)
				
			} else if questionIndex == questions.count {
				
				displayGameOver(questions.count)
				
			} else {
			
				//Play again
				requestGameMode()
			}
		}
	}

    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds seconds: Int) {
		
		let qIndexBeforeDelay = currentQuestionStatus.qIndex
			
		// Converts a delay in seconds to nanoseconds as signed 64 bit integer
		let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
		// Calculates a time value to execute the method given current time and delay
		let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, delay)
		
		// Executes the nextRound method at the dispatch time on the main queue
		dispatch_after(dispatchTime, dispatch_get_main_queue()) {
			//self.nextRound()
			
			//Lightning mode, still on the same question and it hasn't been answered
			if self.lightningMode && (qIndexBeforeDelay == self.currentQuestionStatus.qIndex && !self.currentQuestionStatus.answered) {
	
				self.processFuncButtonAction()
			}
		}
    }
	
	func soundUrlFor(file fileName: String, ofType: String) -> NSURL {
		
		let pathToSoundFile = NSBundle.mainBundle().pathForResource(fileName, ofType: ofType)
		return NSURL(fileURLWithPath: pathToSoundFile!)
	}
    
    func loadGameStartSound() { AudioServicesCreateSystemSoundID(soundUrlFor(file: "GameSound", ofType: "wav"), &gameSound) }
	func loadCorrectSound() { AudioServicesCreateSystemSoundID(soundUrlFor(file: "CorrectSound", ofType: "wav"), &gameSound) }
	func loadWrongSound() { AudioServicesCreateSystemSoundID(soundUrlFor(file: "WrongSound", ofType: "wav"), &gameSound)}
	func loadGameOverSound() { AudioServicesCreateSystemSoundID(soundUrlFor(file: "GameOverSound", ofType: "wav"), &gameSound)}
	func loadErrorSound() { AudioServicesCreateSystemSoundID(soundUrlFor(file: "ErrorSound", ofType: "wav"), &gameSound)}
	func loadNextQuestionSound() { AudioServicesCreateSystemSoundID(soundUrlFor(file: "NextQ", ofType: "wav"), &gameSound)}
	
	func playSound(){
		
		AudioServicesPlaySystemSound(gameSound)
	}
	
	
	//This terribly violates DRY, but still can't figure out how to pass action as a parameter.
	func addAnswerOptionButtonTo(stack stackView: UIStackView, text: String, tag: Int, color: ColorComponents) {
		
		let button = UIButton()
		button.backgroundColor = color.color()
		button.setTitle(text, forState: .Normal)
		button.titleLabel?.textAlignment = .Center
		button.titleLabel?.lineBreakMode = .ByWordWrapping
		button.addTarget(self, action: #selector(answersButtonAction), forControlEvents: .TouchUpInside)
		
		button.tag = tag
		
		stackView.addArrangedSubview(button)
	}
	
	func addGameModeOptionButtonTo(stack stackView: UIStackView, text: String, tag: Int, color: ColorComponents) {
		
		let button = UIButton()
		button.backgroundColor = color.color()
		button.setTitle(text, forState: .Normal)
		button.titleLabel?.textAlignment = .Center
		button.titleLabel?.lineBreakMode = .ByWordWrapping
		button.addTarget(self, action: #selector(gameModeButtonAction), forControlEvents: .TouchUpInside)
		
		button.tag = tag
		
		stackView.addArrangedSubview(button)
	}
	
	func addTriviaTypeOptionButton(stack stackView: UIStackView, text: String, tag: Int, color: ColorComponents) {
		
		let button = UIButton()
		button.backgroundColor = color.color()
		button.setTitle(text, forState: .Normal)
		button.titleLabel?.textAlignment = .Center
		button.titleLabel?.lineBreakMode = .ByWordWrapping
		button.addTarget(self, action: #selector(triviaTypeButtonAction), forControlEvents: .TouchUpInside)
		
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
	
	
	
	func triviaTypeButtonAction(sender: UIButton!) {
		
		if let triviaType = TriviaModel.TriviaType(rawValue: sender.tag) {
			
			nextRound(triviaType)
			
		} else {
		
			nextRound(TriviaModel.TriviaType.mixed)
		}
		
		funcButton.hidden = false
	}
	
	func gameModeButtonAction(sender: UIButton!) {
		
		lightningMode = (sender.tag == 1)
		
		
		if lightningMode {
			
			view.backgroundColor = lightnintModeBGColor.color()
			
		} else {
			
			view.backgroundColor = normalBGColor.color()
		}
		
		requestTriviaType()
	}
	
	func answersButtonAction(sender: UIButton!) {
		
		currentQuestionStatus.answered = true
		
		if let questionItem = questionItem  {
			
			if let correct = questionItem.isCorrectOption(sender.tag) {
				
				if correct {
					
					loadCorrectSound()
					playSound()
					
					processLabel(infoLabel, text: "Correct!", textColor: correctColor)
					
					correctAnswers += 1
					
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
		
		setParamsFor(button: funcButton, color: correctColor, titleColor: white, enabled: true)
	}
}

