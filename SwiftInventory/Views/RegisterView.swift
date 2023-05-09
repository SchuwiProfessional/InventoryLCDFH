//
//  RegisterView.swift
//  SwiftInventory
//
//  Created by Alvaro  on 9/05/23.
//

import SwiftUI

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    @Binding var currentShowingView: String
    
    private func isValidPassword(_ password: String) -> Bool {
            // minimum 6 characters long
            // 1 uppercase character
            // 1 special char
            
            let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
            
            return passwordRegex.evaluate(with: password)
        }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Image("logo1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 120)
                        .padding(.vertical,32)
                }
                .padding()
                .padding(.top)
                
                HStack {
                    Text("Registrar administrador")
                        .foregroundColor(.white)
                        .font(.title2)
                        .bold()
                }
                
                Spacer()
                
                HStack {
                    Image(systemName: "mail")
                    TextField("Email", text: $email )
                    
                    Spacer()
                    
                    if(email.count != 0) {
                        Image(systemName: email.isValidEmail() ? "checkmark" : "xmark")
                            .foregroundColor(email.isValidEmail() ? .green : .red)
                    }
                    
                }
                .foregroundColor(.white)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                )
                
                .padding()
                
                HStack {
                    Image(systemName: "lock")
                    SecureField("password", text: $password )
                    
                    Spacer()
                    
                    if(password.count != 0) {
                        Image(systemName: isValidPassword(password) ? "checkmark" : "xmark")
                            .foregroundColor(isValidPassword(password) ? .green : .red)
                    }
                    
                }
                .foregroundColor(.white)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                )
                
                .padding()
                
                Button(action: {
                    withAnimation {
                        self.currentShowingView = "Ingresar"
                    }
                    
                }) {
                    Text("¿Ya estas registrado?")
                        .foregroundColor(.white.opacity(0.7))
                }
                Spacer()
                Spacer()
                
                
                Button {
                    
                } label: {
                    Text("Crear Administrador")
                        .foregroundColor(.black)
                        .font(.title3)
                        .bold()
                    
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                        .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                        )
                        .padding(.horizontal)
                }
                .padding()
                
            }
        }
    }
}

