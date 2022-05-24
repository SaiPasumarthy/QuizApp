//
//  MultipleAnswerQuestion.swift
//  QuizApp
//
//  Created by Sai Pasumarthy on 24/05/22.
//

import SwiftUI

struct MultipleAnswerQuestion: View {
    let title: String
    let question: String
    @State var store: MultipleSelectionStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            QuestionHeader(title: title, question: question)
            ForEach(store.options.indices) { index in
                MultipleTextSelectionCell(option: $store.options[index])
            }
            
            Spacer()
            
            Button(action: store.submit, label: {
                HStack {
                    Spacer()
                    Text("Submit")
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                }
                .background(Color.blue)
                .cornerRadius(25)
            })
            .buttonStyle(PlainButtonStyle())
            .padding()
            .disabled(!store.canSubmit)
        }
    }
}

struct MultipleAnswerQuestion_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MultipleAnswerQuestionTestView()
            MultipleAnswerQuestionTestView()
                .preferredColorScheme(.dark)
                .environment(\.sizeCategory, .extraExtraExtraLarge)
        }
    }
    
    struct MultipleAnswerQuestionTestView: View {
        @State var selection: [String] = ["none"]
        var body: some View {
            
            VStack {
                MultipleAnswerQuestion(title: "1 of 2", question: "What is your favourite sport", store: .init(options: ["Golf","Cricket","Football","Hockey"], handler: { selection = $0 }))
                
                Text("Last submission : \(selection.joined(separator: ", "))")
            }
        }
    }
}
