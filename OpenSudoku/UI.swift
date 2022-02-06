import SwiftUI

class UI: ObservableObject {
    @Published var gameAccentColor: Color = .green
    @Published var autoCompleteTextColor: Color = .black
    @Published var autoCompleteFont: Font = .system(size: 27, weight: .heavy, design: .default)
    @Published var numberPickerBackgroundColor: Color = .black
    @Published var usageOnColor: Color = .accentColor
    @Published var usageOffColor: Color = .black
    @Published var usageLineColor: Color = .black
    @Published var evenGridColor: Color = .black
    @Published var oddGridColor: Color = .black

    static let playAgain = "Play Again"
    static let ok = "OK"

    static let boardBorderWidth: CGFloat = 2

    static let settingsImage = Image(systemName: "list.bullet") //   gearshape.fill
    static let numberPickerColorImage = Image(systemName: "circle.fill")
    static let numberPickerColorImageFont: Font = .system(size: 25)
    static let numberPickerNumberFont: Font = .system(size: 29)

    func calc(useColor: Bool, isDarkMode: Bool = UITraitCollection.current.userInterfaceStyle == .dark) {
        if useColor {
            gameAccentColor = .gray
        } else {
            gameAccentColor = .accentColor
        }
        if isDarkMode {
            numberPickerBackgroundColor = Color(.systemGray5)
            usageOnColor = .black
            usageOffColor = Color(.systemGray)
            usageLineColor = .white.opacity(0.9)
            evenGridColor = Color(.systemGray)
            oddGridColor = Color(.systemGray2)
        } else {
            numberPickerBackgroundColor = Color(.systemGray4)
            usageOnColor = .accentColor
            usageOffColor = Color(.systemGray5)
            usageLineColor = .black
            evenGridColor = Color(.systemGray6)
            oddGridColor = Color(.systemGray5)
        }
        let colorDark = useColor && isDarkMode
        let colorLight = useColor && !isDarkMode
        let numberDark = !useColor && isDarkMode
        let numberLight = !useColor && !isDarkMode
        if colorDark {
            autoCompleteTextColor = .white
        } else if colorLight {
            autoCompleteTextColor = .black
        } else if numberDark {
            autoCompleteTextColor = .white
        } else if numberLight {
            autoCompleteTextColor = .accentColor
        }
    }

    func autoCompleteText(isShowing: Bool) -> String {
        isShowing ? "Fill last number" : ""
    }
}
