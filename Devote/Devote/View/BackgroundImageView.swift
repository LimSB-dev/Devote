//
//  BackgroundImageView.swift
//  Devote
//
//  Created by 임성빈 on 2022/03/26.
//

import SwiftUI

struct BackgroundImageView: View {
    var body: some View {
        Image("rocket")
            .antialiased(true)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea(.all)
            
    }
}

struct BackgroundImageView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundImageView()
    }
}
