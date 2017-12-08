enum FormatTemplate: String {
    case minutes = "%02d:%02d"
}

protocol StringFormatable {
    func format(template: FormatTemplate) -> String
}

extension Int: StringFormatable {
    func format(template: FormatTemplate) -> String {
        switch template {
        case .minutes:
            let seconds = self % 60
            let minutes = (self / 60) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

extension Double: StringFormatable {
    func format(template: FormatTemplate) -> String {
        return Int(self).format(template: template)
    }
}

extension Float: StringFormatable {
    func format(template: FormatTemplate) -> String {
        return Int(self).format(template: template)
    }
}
