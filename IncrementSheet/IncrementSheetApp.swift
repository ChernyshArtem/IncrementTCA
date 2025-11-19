//
//  IncrementSheetApp.swift
//  IncrementSheet
//
//  Created by Артём Черныш on 11/14/25.
//

import ComposableArchitecture
import SwiftUI

@main
struct IncrementSheetApp: App {
  var body: some Scene {
    WindowGroup {
      SheetFeatureView()
    }
  }
}
