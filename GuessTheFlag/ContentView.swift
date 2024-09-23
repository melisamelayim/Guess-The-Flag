//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Max on 22.09.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["France", "Spain", "US", "Italy", "Germany", "Estonia", "Ireland", "Monaco", "Nigeria", "Poland", "UK", "Ukraine"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var totalScore = 0
    @State private var maxTotalScore : Int = UserDefaults.standard.integer(forKey: "maxScore")
    @State private var questionCounter = 0
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var finalScore = false
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: .blue.opacity(0.7), location: 0.3),
                .init(color: .red.opacity(0.7), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                Text("Guess The Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                    .padding()
                
                VStack(spacing: 15) {
                    //Texts
                    VStack{
                        Text("Tap on the flag of")
                            .foregroundStyle(.white)
                            .font(.subheadline.weight(.heavy))
                        
                        Text("\(countries[correctAnswer])!")
                            .foregroundStyle(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    //Flags are created right here
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            maxScoreHolder()
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                            
                        }
                    }
                    
                    .frame(maxWidth: 250)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(.rect(cornerRadius: 100))
                }
                
                Spacer()
                Spacer()
                
                Text("Score: \(totalScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                HStack{
                    Text("Max Score: \(maxTotalScore)")
                        .foregroundStyle(.secondary)
                    
                    Button (action: {
                        totalScore = 0
                        questionCounter = 0
                    }) {
                        Text("Restart")
                            .foregroundStyle(.white)
                    }
                }
                
                Spacer()
            }
            .padding()
            
            .alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askQuestion)
            } message: {
                Text("Your score is: \(totalScore) /\(questionCounter)")
            }
            
            .alert(scoreTitle, isPresented: $finalScore) {
                Button("Restart", action: askQuestion)
            } message: {
                Text("Your score is: \(totalScore) /\(questionCounter)")
            }
            
            
            
        }
    }
    
    func flagTapped(_ number: Int) {
        questionCounter += 1
        if number == correctAnswer {
            scoreTitle = "Correct"
            totalScore += 1
        } else {
            scoreTitle = "Wrong"
        }
        
        showingScore = true
        
        if questionCounter == 8 {
            showingScore = false
            scoreTitle = "Game Over"
            finalScore = true
            
        }
    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        if finalScore == true {
            totalScore = 0
            questionCounter = 0
        }
            
    }
    
    func maxScoreHolder(){
        if totalScore > maxTotalScore {
            maxTotalScore = totalScore
            UserDefaults.standard.set(maxTotalScore, forKey: "maxScore")
        }
    }
    
}

#Preview {
    ContentView()
}
