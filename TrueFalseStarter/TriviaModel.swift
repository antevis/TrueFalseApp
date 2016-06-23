//
//  TriviaModel.swift
//  TrueFalseStarter
//
//  Created by Ivan Kazakov on 16/06/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import GameKit

//Both question and options implemented as classes in order to be able to use it as a parameter in
//func arrayByShufflingObjectsInArray(_ array: [AnyObject]) -> [AnyObject], as structs aren't covertible to AnyObject
class Question {
	
	let question: String
	var options: [Option]?
	
	//There may be more than one correct option
	var correctOptionIndices: [Int]? {
		
		var indices: [Int]?
		
		guard let options = self.options else {
			
			return nil
		}
		
		for i in 0..<options.count {
			
			guard let correct = options[i].correct else {
				
				continue
			}
			
			if correct {
				
				if indices == nil {
					
					indices = []
				}
				
				indices?.append(i)
			}
		}
		
		return indices
	}
	
	init(question: String, options: [Option]?){
		
		self.question = question
		self.options = options
	}
	
	func shuffledOptions() -> [Option]? {
		
		guard let options = options, let randomOrderedOptions = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(options) as? [Option]  else {
			
			return nil
		}
		
		return randomOrderedOptions
	}
	
	func isCorrectOption(optionIndex: Int) -> Bool? {
		
		guard let options = self.options else {
			
			return nil
		}
		
		if let optionItem = try? getOptionOf(options, optionIndex: optionIndex) {
			
			guard let correct = optionItem.correct else {
				
				return false
			}
			
			return correct

		} else {

			return nil
		}
	}
	
	func getOptionOf(options: [Option], optionIndex: Int) throws -> Option {
		
		return options[optionIndex]
	}

}

class Option {
	
	let optionText: String
	let correct: Bool?
	
	init(text: String, correct: Bool?) {
		
		self.optionText = text
		self.correct = correct
	}
}

struct TriviaModel {
	
	internal enum TriviaType: Int {
		
		case textBased
		case arithmetic
		case mixed
	}
	
	let questions: [Question] = [
		
		Question(question: "This was the only US President to serve more than two consecutive terms.", options: [
			Option(text: "George Washington", correct: nil),
			Option(text: "Franklin D. Roosevelt", correct: true),
//			Option(text: "Woodrow Wilson", correct: nil),
			Option(text: "Andrew Jackson", correct: nil)]),
		
//		Question(question: "Which of the following countries has the most residents?", options: [
//			Option(text: "Nigeria", correct: true),
//			Option(text: "Russia", correct: nil),
//			Option(text: "Iran", correct: nil),
//			Option(text: "Vietnam", correct: nil)]),
//		
//		Question(question: "In what year was the United Nations founded?", options: [
//			Option(text: "1918", correct: nil),
//			Option(text: "1919", correct: nil),
//			Option(text: "1945", correct: true),
//			Option(text: "1954", correct: nil)]),
		
		Question(question: "The Titanic departed from the United Kingdom, where was it supposed to arrive?", options: [
			Option(text: "Paris", correct: nil),
//			Option(text: "Washington D.C.", correct: nil),
			Option(text: "New York", correct: true),
			Option(text: "Boston", correct: nil)]),
		
		Question(question: "Which nation produces the most oil?", options: [
			Option(text: "Iran", correct: nil),
			Option(text: "Iraq", correct: nil),
			Option(text: "Brazil", correct: nil),
			Option(text: "Canada", correct: true)]),
		
		Question(question: "Which country has most recently won consecutive World Cups in Soccer?", options: [
//			Option(text: "Italy", correct: nil),
			Option(text: "Brazil", correct: true),
			Option(text: "Argentina", correct: nil),
			Option(text: "Spain", correct: nil)]),
		
//		Question(question: "Which of the following rivers is longest?", options: [
//			Option(text: "Yangtze", correct: nil),
//			Option(text: "Mississippi", correct: true),
//			Option(text: "Congo", correct: nil),
//			Option(text: "Mekong", correct: nil)]),
//		
//		Question(question: "Which city is the oldest?", options: [
//			Option(text: "Mexico City", correct: true),
//			Option(text: "Cape Town", correct: nil),
//			Option(text: "San Juan", correct: nil),
//			Option(text: "Sydney", correct: nil)]),
//		
//		Question(question: "Which country was the first to allow women to vote in national elections?", options: [
//			Option(text: "Poland", correct: true),
//			Option(text: "United States", correct: nil),
//			Option(text: "Sweden", correct: nil),
//			Option(text: "Senegal", correct: nil)]),
		
		Question(question: "Which of these countries won the most medals in the 2012 Summer Games?", options: [
			Option(text: "France", correct: nil),
			Option(text: "Germany", correct: nil),
			Option(text: "Japan", correct: nil),
			Option(text: "Great Britian", correct: true)])
	]
	
	func generateMathQuestion() -> Question? {
		
		//avoided "/" for simplicity
		let operations = ["+", "-", "*"]
		
		var operIndices = getRandomUniqueOperationsIndexesTuple(lessThan: operations.count)
		
		//to ensure unique expression members
		guard let expressionMembers = uniqueArrayOf(elementCount: 3, lessThan: 10) else {
			
			return nil
		}
		
		let a = expressionMembers[0]
		let b = expressionMembers[1]
		let c = expressionMembers[2]
		
		var options: [Option] = []
		
		let correctOptionValue = self.getOptionResult(a, b: b, c: c, opOne: operIndices.one, opTwo: operIndices.two, operations: operations)
		
		let questionText = "(\(a) \(operations[operIndices.one]) \(b)) \(operations[operIndices.two]) \(c) ="
		
		let correctOption = Option(text: "\(correctOptionValue)", correct: true)
		options.append(correctOption)
		
		//used to ensure unique wrong options
		var optionValues: [Int] = [correctOptionValue]
		
		for _ in 0..<3 {
			
			var optionValue: Int
			
			//to prevent infinite loop, which in fact should not happen, but still to be sure
			var guardian = 0
			
			repeat {
				
				operIndices = getRandomUniqueOperationsIndexesTuple(lessThan: operations.count)
				
				optionValue = self.getOptionResult(a, b: b, c: c, opOne: operIndices.one, opTwo: operIndices.two, operations: operations)
				
				guardian += 1
				
			} while optionValues.contains(optionValue) || guardian < 10
			
			optionValues.append(optionValue)
			
			let option = Option(text: "\(optionValue)", correct: nil)
			options.append(option)
		}
		
		
		
		let question = Question(question: questionText, options: options)
		
		return question
	}
	
	func uniqueArrayOf(elementCount n: Int, lessThan threshold: Int) -> [Int]?{
		
		var result: [Int]?
		
		//impossible to return more unique integer elements than threshold
		guard n <= threshold else {
			
			return nil
		}
		
		result = []
		
		for _ in 0..<n {
			
			var element: Int
			
			repeat {
				
				element = random(lessThan: threshold)
				
			} while result!.contains(element)
			
			result!.append(element)
		}
		
		return result
	}
	
	func getRandomUniqueOperationsIndexesTuple(lessThan upperBound: Int) -> (one: Int, two: Int) {
		
		let opOne = random(lessThan: upperBound)
		
		var opTwo: Int
		
		repeat {
			
			opTwo = random(lessThan: upperBound)
			
		} while opTwo == opOne
		
		return (opOne, opTwo)
	}
	
	func applyOperationTo(a: Int, b: Int, opIndex: Int, operations: [String]) -> Int {
		
		var result: Int = a
		
		switch operations[opIndex] {
			
			case "+":
				result += b
			case "-":
				result -= b
			case "*":
				result *= b
			default:
				return result
			
		}
		
		return result
	}
	
	func getOptionResult(a: Int, b: Int, c: Int, opOne: Int, opTwo: Int, operations: [String]) -> Int {
		
		var result = self.applyOperationTo(a, b: b, opIndex: opOne, operations: operations)
		
		result = self.applyOperationTo(result, b: c, opIndex: opTwo, operations: operations)
		
		return result
	}
	
	func random(lessThan upperBound: Int) -> Int {
		
		return GKRandomSource.sharedRandom().nextIntWithUpperBound(upperBound)
	}
	
	func generateArithmeticQuestionsArrayOf(elements: Int) -> [Question]{
		
		var questions: [Question] = []
		
		for _ in 0..<elements {
			
			if let q = generateMathQuestion() {
			
				questions.append(q)
			}
		}
		
		return questions
	}
	
	
	func shuffledQuestions(trivaType: TriviaType) -> [Question]? {
		
		var triviaQuestions: [Question] = []
		
		switch trivaType {
			case .textBased:
				triviaQuestions += questions
			
			case .mixed:
			
				let mathQuestions = generateArithmeticQuestionsArrayOf(questions.count)
				triviaQuestions += (questions + mathQuestions)
			
			case .arithmetic:
				
				let mathQuestions = generateArithmeticQuestionsArrayOf(questions.count)
				triviaQuestions += mathQuestions
		}
		
		guard let randomOrderedQuestions = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(triviaQuestions) as? [Question] else {
			
			return nil
		}
		
		for question in randomOrderedQuestions {
			
			question.options = question.shuffledOptions()
		}
		
		return randomOrderedQuestions
	}
}
