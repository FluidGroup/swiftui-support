//
//  ContentView.swift
//  Demo
//
//  Created by Muukii on 2023/01/01.
//

import SwiftUI
import SwiftUISupport

struct ContentView: View {
  var body: some View {
    
    NavigationView {

      NavigationLink(destination: {
        BookChange()
      }, label: {
        Text("Change")
      })

      NavigationLink(destination: {
        BookSpringBall()
      }, label: {
        Text("SpringBall")
      })
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
