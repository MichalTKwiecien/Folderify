import SwiftUI

protocol GenericButtonStyle: ButtonStyle {
    var text: String { get }
    var state: ButtonState { get }
    var isSmall: Bool { get }

    init(text: String, state: ButtonState, isSmall: Bool)

    func padding() -> EdgeInsets
    func foregroundColor(isPressed: Bool) -> Color
    func backgroundColor(isPressed: Bool) -> Color
    func borderColor(isPressed: Bool) -> Color
    func borderWidth(isPressed: Bool) -> CGFloat
}

struct GenericButton<S: GenericButtonStyle>: View {
    let text: String
    let isSmall: Bool
    let state: Binding<ButtonState>
    let action: () -> Void

    var body: some View {
        Button(
            action: action,
            label: { Color.clear }
        )
        .buttonStyle(
            S(
                text: text,
                state: state.wrappedValue,
                isSmall: isSmall
            )
        )
        .disabled(state.wrappedValue != .interactive)
    }
}

extension GenericButtonStyle {
    func padding() -> EdgeInsets {
        .init(
            top: isSmall ? 8 : 16,
            leading: 24,
            bottom: isSmall ? 8 : 16,
            trailing: 24
        )
    }

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            switch state {
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor(isPressed: configuration.isPressed)))
                    .frame(width: 24, height: 24)
                    .padding(padding())
            case .disabled,
                 .interactive:
                Text(text)
                    .foregroundColor(foregroundColor(isPressed: configuration.isPressed))
                    .padding(padding())
            }
        }
        .frame(maxWidth: .infinity)
        .background(backgroundColor(isPressed: configuration.isPressed))
        .overlay(
            RoundedRectangle(cornerRadius: 32)
                .stroke(
                    borderColor(isPressed: configuration.isPressed),
                    lineWidth: borderWidth(isPressed: configuration.isPressed)
                )
        )
        .cornerRadius(32)
        .contentShape(RoundedRectangle(cornerRadius: 32))
    }
}
