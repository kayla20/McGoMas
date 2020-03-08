//
//  ContentView.swift
//  McGoMas
//
//  Created by Mikayla Richardson on 3/3/20.
//  Copyright © 2020 Capstone. All rights reserved.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @State private var text: Text = Text("")
    @State private var view: AnyView?
    @State private var showSplash = true
    @State private var animationAmount: CGFloat = 1
    @State private var gradientStart: UnitPoint = .leading
    @State private var gradientEnd: UnitPoint = .trailing
    @State private var  colorOne: Color = Color.init(Color.RGBColorSpace.sRGB, red: 99.0 / 255, green: 0, blue: 49.0 / 255, opacity: 100);
    @State private var colorTwo: Color = Color.init(Color.RGBColorSpace.sRGB, red: 207.0 / 255, green: 69.0 / 255, blue: 32.0 / 255, opacity: 100)
    
    var body: some View {
        NavigationView {
           VStack() {
               NavigationLink(destination: self.view) {
                   self.text
               }
           }
           .onAppear() {
               self.buildNavLink(user: Auth.auth().currentUser)
           }
       }
        .sheet(isPresented: ($showSplash), content: {
            VStack(alignment: .center) {
               Button(action: {
                    withAnimation (.easeIn(duration: 1.5)) {
                        self.gradientEnd = UnitPoint(x: 0, y: 1)
                        self.gradientStart = UnitPoint(x: 1, y: 0)
                        self.animationAmount = 3
                    }
                
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { // Change `2.0` to the desired number of seconds.
                       self.showSplash = false;
                    }
                    
                   },
                   label: {
                       RoundedRectangle(cornerRadius: 7.0)
                        .fill(LinearGradient(gradient: Gradient(colors: [self.colorTwo, self.colorOne]), startPoint: self.gradientStart, endPoint: self.gradientEnd))
                           .frame(width: 200, height: 256, alignment: .center)
                            .scaleEffect(self.animationAmount)
                           .overlay(
                                Text("Let's Go").foregroundColor(.black)
                                    .font(.system(size: 25.0, weight: .semibold, design: .default))
                       )
                   }
               )
               .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
               .background(Color.gray)
            }
        }).transition(.scale)
    }
    
    func buildNavLink(user: User?){
        if let user = Auth.auth().currentUser {
            self.text = Text("Hello " + (user.email ?? ""))
            self.view = AnyView(LogoutView())
        }
        else {
            self.text = Text("Sign In Now.")
            self.view = AnyView(LoginView())
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
