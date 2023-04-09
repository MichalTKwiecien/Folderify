import SwiftUI

public struct SecondaryButton: View {
    let text: String
    let isSmall: Bool
    let state: Binding<ButtonState>
    let action: () -> Void

    public init(
        text: String,
        isSmall: Bool = false,
        state: Binding<ButtonState> = .constant(.interactive),
        action: @escaping () -> Void
    ) {
        self.text = text
        self.isSmall = isSmall
        self.state = state
        self.action = action
    }

    public var body: some View {
        GenericButton<PrimaryButtonStyle>(
            text: text,
            isSmall: isSmall,
            state: state,
            action: action
        )
    }

    func disabled(_ isDisabled: Bool) {
        state.wrappedValue = isDisabled ? .disabled : .interactive
    }
}

private struct PrimaryButtonStyle: GenericButtonStyle {
    let text: String
    let state: ButtonState
    let isSmall: Bool

    func foregroundColor(isPressed: Bool) -> Color {
        switch state {
        case .interactive:
            return isPressed ? .light : .branding
        case .loading:
            return .branding
        case .disabled:
            return .grey
        }
    }

    func backgroundColor(isPressed: Bool) -> Color {
        isPressed ? .branding : .clear
    }

    func borderColor(isPressed: Bool) -> Color {
        foregroundColor(isPressed: isPressed)
    }

    func borderWidth(isPressed: Bool) -> CGFloat {
        1
    }
}
