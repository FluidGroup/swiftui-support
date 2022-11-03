//
//  ContentView.swift
//  SwiftUISupportDemo
//
//  Created by Muukii on 2022/11/03.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationView {
      
      NavigationLink("HostingEdge", destination: BookHostingEdge())
      
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
