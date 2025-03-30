import SwiftUI

internal struct WordListViewActions: View {    
    internal let onAdd: () -> Void
    
    private let style: WordListStyle
    
    /// Initializes the WordListViewActions.
    /// - Parameters:
    ///   - style: `WordListStyle` object that defines the visual style.
    ///   - onAdd: Closure executed when the button is tapped.
    init(
        style: WordListStyle,
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
