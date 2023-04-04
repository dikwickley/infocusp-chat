//
//  AvatarView.swift
//  InfocuspChat
//
//  Created by Aniket Singh Rawat on 04/04/23.
//

import SwiftUI

struct AvatarView: View {
    var seed: String
    var size: CGSize = CGSize(width: 100, height: 100)
    var isRound: Bool = false
    
    var cornerRadius: CGFloat {
        if isRound {
            return 100
        } else {
            return 10
        }
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://api.dicebear.com/6.x/micah/png?seed=\(seed)")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                } else if phase.error != nil {
                    Image(systemName: "person.fill")
                        .resizable()
                } else {
                    ProgressView()
                }
            }
        }
        .padding(10)
        .background(Color(0xD3D3D3, alpha: 0.3))
        .frame(width: size.width, height: size.height)
        .cornerRadius(cornerRadius)
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(seed: "aniket", size: CGSize(width: 100, height: 100))
    }
}
