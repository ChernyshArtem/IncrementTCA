import ComposableArchitecture
import SwiftUI

@ViewAction(for: SheetFeature.self)
struct SheetFeatureView: View {
  init() {
    childStore = Store(initialState: CounterFeature.State()) {
      CounterFeature()
        ._printChanges()
    }

    store = Store(initialState: SheetFeature.State(child: childStore.state)) {
      SheetFeature()
        ._printChanges()
    }
  }

  let store: StoreOf<SheetFeature>
  let childStore: StoreOf<CounterFeature>

  var body: some View {
    Button("открытие") {
      send(.openButtonTapped)
    }
    .counterFeatureModifier(isPresented: .constant(store.isPresented), store: store.scope(state: \.child, action: \.child))
  }
}

@Reducer
struct SheetFeature {
  @ObservableState
  struct State: Equatable {
    var child: CounterFeature.State
    var isPresented: Bool = false
  }

  enum Action: ViewAction {
    case view(View)
    case child(CounterFeature.Action)

    enum View {
      case openButtonTapped
    }
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.child, action: \.child) {
      CounterFeature()
    }
    Reduce { state, action in
      switch action {
      case let .view(viewAction):
        switch viewAction {
        case .openButtonTapped:
          state.isPresented = !state.isPresented
          return .none
        }
      case let .child(childAction):
        switch childAction {
        case .view(.dismissButtonTapped):
          state.isPresented = !state.isPresented
          return .run { _ in
          }
        default:
          return .none
        }
      }
    }
  }
}
