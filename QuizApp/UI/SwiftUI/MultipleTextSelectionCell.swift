//
//  MultipleTextSelectionCell.swift
//  QuizApp
//
//  Created by Sai Pasumarthy on 24/05/22.
//

import SwiftUI

struct MultipleTextSelectionCell: View {
    @Binding var option: MultipleSelectionOption
    
    var body: some View {
        Button(action: { option.select() }, label: {
            HStack {
                Rectangle()
                    .strokeBorder(option.isSelected ? Color.blue : Color.secondary, lineWidth: 2.5)
                    .overlay(
                        Rectangle()
                            .fill(option.isSelected ? Color.blue : Color.clear)
                            .frame(width: 26, height: 26))
                    .frame(width: 40.0, height: 40.0)
                Text(option.text)
                    .font(.title)
                    .foregroundColor(option.isSelected ? Color.blue : Color.secondary)
                Spacer()
            }.padding()
        })
    }
}

struct MultipleTextSelectionCell_Previews: PreviewProvider {
    static var previews: some View {
        MultipleTextSelectionCell(option: .constant(.init(text: "A Option", isSelected: false)))
            .previewLayout(.sizeThatFits)
        
        MultipleTextSelectionCell(option: .constant(.init(text: "A Option", isSelected: true)))
            .previewLayout(.sizeThatFits)
    }
}

