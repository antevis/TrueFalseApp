//
//  TriviaModel.swift
//  TrueFalseStarter
//
//  Created by Ivan Kazakov on 16/06/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import GameKit

//Have to declare both question and options as classes in order to be able to use it as a parameter in
//func arrayByShufflingObjectsInArray(_ array: [AnyObject]) -> [AnyObject], as structs aren't covertible to AnyObject
class Question {
	
	let question: String
	var options: [Option]?
	
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
	
	let questions: [Question] = [
		
		Question(question: "This was the only US President to serve more than two consecutive terms.", options: [
			Option(text: "George Washington", correct: nil),
			Option(text: "Franklin D. Roosevelt", correct: true),
			Option(text: "Woodrow Wilson", correct: nil),
			Option(text: "Andrew Jackson", correct: nil)]),
		
		Question(question: "Which of the following countries has the most residents?", options: [
			Option(text: "Nigeria", correct: true),
			Option(text: "Russia", correct: nil),
			Option(text: "Iran", correct: nil),
			Option(text: "Vietnam", correct: nil)]),
		
		Question(question: "In what year was the United Nations founded?", options: [
			Option(text: "1918", correct: nil),
			Option(text: "1919", correct: nil),
			Option(text: "1945", correct: true),
			Option(text: "1954", correct: nil)]),
		
		Question(question: "The Titanic departed from the United Kingdom, where was it supposed to arrive?", options: [
			Option(text: "Paris", correct: nil),
			Option(text: "Washington D.C.", correct: nil),
			Option(text: "New York", correct: true),
			Option(text: "Boston", correct: nil)]),
		
		Question(question: "Which nation produces the most oil?", options: [
			Option(text: "Iran", correct: nil),
			Option(text: "Iraq", correct: nil),
			Option(text: "Brazil", correct: nil),
			Option(text: "Canada", correct: true)]),
		
		Question(question: "Which country has most recently won consecutive World Cups in Soccer?", options: [
			Option(text: "Italy", correct: nil),
			Option(text: "Brazil", correct: true),
			Option(text: "Argentina", correct: nil),
			Option(text: "Spain", correct: nil)]),
		
		Question(question: "Which of the following rivers is longest?", options: [
			Option(text: "Yangtze", correct: nil),
			Option(text: "Mississippi", correct: true),
			Option(text: "Congo", correct: nil),
			Option(text: "Mekong", correct: nil)]),
		
		Question(question: "Which city is the oldest?", options: [
			Option(text: "Mexico City", correct: true),
			Option(text: "Cape Town", correct: nil),
			Option(text: "San Juan", correct: nil),
			Option(text: "Sydney", correct: nil)]),
		
		Question(question: "Which country was the first to allow women to vote in national elections?", options: [
			Option(text: "Poland", correct: true),
			Option(text: "United States", correct: nil),
			Option(text: "Sweden", correct: nil),
			Option(text: "Senegal", correct: nil)]),
		
		Question(question: "Which of these countries won the most medals in the 2012 Summer Games?", options: [
			Option(text: "France", correct: nil),
			Option(text: "Germany", correct: nil),
			Option(text: "Japan", correct: nil),
			Option(text: "Great Britian", correct: true)])
	]
	
	
	func shuffledQuestions() -> [Question]? {
		
		guard let randomOrderedQuestions = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(questions) as? [Question] else {
			
			return nil
		}
		
		for question in randomOrderedQuestions {
			
			question.options = question.shuffledOptions()
		}
		
		return randomOrderedQuestions
	}
}
