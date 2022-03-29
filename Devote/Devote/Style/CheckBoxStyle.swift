//
//  CheckBoxStyle.swift
//  Devote
//
//  Created by 임성빈 on 2022/03/29.
//

import SwiftUI

struct CheckBoxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .foregroundColor(configuration.isOn ? .pink : .primary)
                .font(.system(size: 30, weight: .semibold, design: .rounded))
                .onTapGesture {
                    withAnimation {
                        configuration.isOn.toggle()
                    }
                }
                
            
            configuration.label
        } // HStack
    }
}

struct CheckBoxStyle_Previews: PreviewProvider {
    static var previews: some View {
        Toggle("Placeholder label", isOn: .constant(true))
            .toggleStyle(CheckBoxStyle())
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
