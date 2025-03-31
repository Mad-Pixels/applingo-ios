import SwiftUI

internal struct GameQuizViewActions: View {
    internal let onAdd: () -> Void
    
    private let style: GameQuizStyle
    
    /// Initializes the WordListViewActions.
    /// - Parameters:
    ///   - style: `GameQuizStyle` object that defines the visual style.
    ///   - onAdd: Closure executed when the button is tapped.
    init(
        style: GameQuizStyle,
        onAdd: @escaping () -> Void
    ) {
        self.style = style
        self.onAdd = onAdd
    }
    
    var body: some View {
        ButtonFloatingSingle(
            icon: "plus.circle",
            action: onAdd
        )
    }
}
