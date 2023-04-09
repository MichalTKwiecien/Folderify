import SwiftUI

public struct TextInput: View {
    let title: String
    let isSecure: Bool
    let value: Binding<String>

    public init(
        title: String,
        isSecure: Bool = false,
        value: Binding<String>
    ) {
        self.title = title
        self.isSecure = isSecure
        self.value = value
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .foregroundColor(.dark)

            if isSecure {
                SecureField("", text: value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.dark)
            } else {
                TextField("", text: value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.dark)
            }
        }
    }
}

#if DEBUG
    struct TextInput_Previews: PreviewProvider {
        static var previews: some View {
            VStack {
                TextInput(title: "Title", value: .constant(""))
                TextInput(title: "Title", value: .constant("text"))
                TextInput(title: "Title", isSecure: true, value: .constant(""))
                TextInput(title: "Title", isSecure: true, value: .constant("text"))
            }.padding(.horizontal, 16)
        }
    }
#endif
