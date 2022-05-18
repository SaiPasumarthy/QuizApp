//
//  SingleAnswerQuestion.swift
//  QuizApp
//
//  Created by Sai Pasumarthy on 17/05/22.
//

import SwiftUI

struct SingleAnswerQuestion: View {
    let title: String
    let question: String
    let options:[String]
    let selection: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            QuestionHeader(title: title, question: question)
            ForEach(options, id: \.self) { option in
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    HStack {
                        Circle()
                            .stroke(Color.secondary, lineWidth: 2.5)
                            .frame(width: 40.0, height: 40.0)
                        Text(option)
                            .font(.title)
                            .foregroundColor(Color.secondary)
                        Spacer()
                    }.padding()
                        
                        
                })
            }
            Spacer()
        }
    }
}

struct SingleAnswerQuestion_Previews: PreviewProvider {
    static var previews: some View {
        SingleAnswerQuestion(title: "1 of 2", question: "What is your favourite sport", options: ["Golf","Cricket","Football","Hockey"], selection: { _ in})
        
        SingleAnswerQuestion(title: "1 of 2", question: "What is your favourite sport", options: ["Golf","Cricket","Football","Hockey"], selection: { _ in})
            .preferredColorScheme(.dark)
            .environment(\.sizeCategory, .extraExtraExtraLarge)
            
    }
}
