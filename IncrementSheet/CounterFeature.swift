import ComposableArchitecture
import SwiftUI

@Reducer
struct CounterFeature {
  @ObservableState
  struct State: Equatable {
    var count: Int = 0
  }

  enum Action: ViewAction {
    case view(View)

    enum View {
      case incrementButtonTapped
      case decrementButtonTapped
      case dismissButtonTapped
    }
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .view(viewAction):
        switch viewAction {
        case .incrementButtonTapped:
          state.count += 1
          return .none
        case .decrementButtonTapped:
          state.count -= 1
          return .none
        case .dismissButtonTapped:
          return .none
        }
      }
    }
  }
}

@ViewAction(for: CounterFeature.self)
struct CounterFeatureView: View {
  var store: StoreOf<CounterFeature>

  var body: some View {
    VStack {
      Spacer()
      Text(String(describing: store.count))
        .padding(8)
        .padding(.horizontal, 8)
        .background(.green)
        .clipShape(.rect(cornerRadius: 16))
        .padding(8)
      Spacer()
      HStack {
        Spacer()
        Button {
          send(.decrementButtonTapped, animation: .spring(duration: 0.5, blendDuration: 0.75))
        } label: {
          Text("-")
            .padding(8)
            .padding(.horizontal, 8)
            .background(.yellow)
            .clipShape(.rect(cornerRadius: 16))
            .padding(8)
        }
        Spacer()
        Button {
          send(.incrementButtonTapped, animation: .spring(duration: 0.5, blendDuration: 0.75))
        } label: {
          Text("+")
            .padding(8)
            .padding(.horizontal, 8)
            .background(.pink)
            .clipShape(.rect(cornerRadius: 16))
            .padding(8)
        }
        Spacer()
      }
      Spacer()
    }
    .overlay(alignment: .topTrailing) {
      Button {
        send(.dismissButtonTapped)
      } label: {
        Image(systemName: "xmark")
      }
      .padding(16)
    }
  }
}

struct CounterFeatureModifier: ViewModifier {
  @Binding var isPresented: Bool
  var store: StoreOf<CounterFeature>

  func body(content: Content) -> some View {
    content
      .sheet(isPresented: $isPresented) {
        CounterFeatureView(store: store)
      }
  }
}

extension View {
  func counterFeatureModifier(isPresented: Binding<Bool>, store: StoreOf<CounterFeature>) -> some View {
    modifier(CounterFeatureModifier(isPresented: isPresented, store: store))
  }
}
