protocol InstreamAd {
    var targetSecond: Float { get }
}

/// Sample
struct MidRollAd: InstreamAd {
    let targetSecond: Float
}
