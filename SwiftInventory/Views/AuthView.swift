//
//  AuthView.swift
//  SwiftInventory
//
//  Created by Alvaro  on 9/05/23.
//

import SwiftUI

struct AuthView: View {
    @State private var currentViewShowing: String = "Ingresar"
    var body: some View {
        
        if(currentViewShowing == "Ingresar") {
            LoginView(currentShowingView: $currentViewShowing)
                .preferredColorScheme(.light)
        } else {
            RegisterView(currentShowingView: $currentViewShowing)
                .preferredColorScheme(.dark)
                .transition(.move(edge: .bottom))
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
