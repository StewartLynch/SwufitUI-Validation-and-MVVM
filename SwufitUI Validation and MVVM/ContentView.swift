//
//  ContentView.swift
//  SwiftUI Validation and MVVM
//
//  Created by Stewart Lynch on 2020-05-08.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var signupVM = SignupViewModel()
    
    @State private var showYearSelector = false
    
    var body: some View {
            ZStack {
                // The Signup View is always visible but not always enabled
                VStack {
                    VStack {
                        EntryField(sfSymbolName: "envelope", placeHolder: "Email Address", prompt: signupVM.emailPrompt, field: $signupVM.email)
                        EntryField(sfSymbolName: "lock", placeHolder: "Password", prompt: signupVM.passwordPrompt, field: $signupVM.password, isSecure: true)
                        EntryField(sfSymbolName: "lock", placeHolder: "Confirm", prompt: signupVM.confirmPwPrompt, field: $signupVM.confirmPw, isSecure: true)
                        VStack(spacing: 5) {
                            Button(action: {
                                // Present Selection
                                self.showYearSelector.toggle()
                            }) {
                                Text(String(signupVM.birthYear))
                                    .padding(8)
                                    .foregroundColor(.primary)
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                            }
                            Text(signupVM.agePrompt).font(.caption)
                        }
                        .padding(.vertical,8)
                        Button(action: {
                            // Create the user
                            self.signupVM.signUp()
                        }) {
                            Text("Sign Up")
                                .foregroundColor(.white)
                                .padding(.vertical, 5)
                                .padding(.horizontal)
                                .background(Capsule().fill(Color.blue))
                        }
                        .opacity(signupVM.isSignUpComplete ? 1 : 0.6)
                        .disabled(!signupVM.isSignUpComplete)
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
//                    Spacer()
                }.disabled(showYearSelector)
                .padding()
                
                // Picker overlay only displayed when year field tapped
                YearPickerView(birthYear: $signupVM.birthYear, showYearSelector: $showYearSelector)
                    .opacity(showYearSelector ? 1 : 0)
                    .animation(.easeIn)
        } // End of ZStack
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct EntryField: View {
    var sfSymbolName: String
    var placeHolder: String
    var prompt: String
    @Binding var field: String
    var isSecure:Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: sfSymbolName)
                    .foregroundColor(.gray)
                    .font(.headline)
                if isSecure {
                    SecureField(placeHolder, text: $field).autocapitalization(.none)
                } else {
                    
                    TextField(placeHolder, text: $field).autocapitalization(.none)
                }
            }
            .padding(8)
            .background(Color(UIColor.secondarySystemBackground))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            Text(prompt)
            .fixedSize(horizontal: false, vertical: true)
            .font(.caption)
        }
    }
}

struct YearPickerView: View {
    @Binding var birthYear: Int
    @Binding var showYearSelector:Bool
    let currentYear = Calendar.current.dateComponents([.year], from: Date()).year!
    var body: some View {
        ZStack {
            Color(.black).opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            VStack {
                VStack {
                    ScrollView(showsIndicators: false){
                        VStack(spacing: 10) {
                            ForEach(((currentYear-100)...currentYear).reversed(), id: \.self) { year in
                                Button(action: {
                                    self.birthYear = year
                                    self.showYearSelector.toggle()
                                }) {
                                    Text(String(year))
                                        .foregroundColor(.primary)
                                    
                                }
                            }
                        }
                    }
                    
                    .frame(height: 200)
                }.padding()
                    .frame(width: 100)
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                Spacer()
            }.padding(.top)
                .animation(.easeIn)
        }
    }
}
