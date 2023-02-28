//
//  SplashView.swift
//  cheese_lock
//
//  Created by Shinjan Patra on 28/02/23.
//


import SwiftUI

struct SplashView: View {
    
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            if self.isActive {
                ContentView(selectedRowIndex: .constant(0))
            } else {
                Rectangle()
                    .background(Color.black)
                Image("splashlock")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
        
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
