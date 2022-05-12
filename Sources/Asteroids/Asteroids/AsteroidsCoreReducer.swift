import RedECS
import RedECSBasicComponents

public let asteroidsCoreReducer: AnyReducer<
    AsteroidsGameState,
    AsteroidsGameAction,
    Void
> = (
    zip(
        AsteroidsPositioningReducer(),
        AsteroidsInputReducer(),
        AsteroidsCollisionReducer()
    )
    + MovementReducer()
        .pullback(toLocalState: \.movementContext)
    + MomentumReducer()
        .pullback(toLocalState: \.momentumContext)
    + KeyboardInputReducer()
        .pullback(
            toLocalState: \.keyboardInputContext,
            toLocalAction: { globalAction in
                switch globalAction {
                case .keyboardInput(let keyAction):
                    return keyAction
                default:
                    return nil
                }
            },
            toGlobalAction: { .keyboardInput($0) }
        )
    + KeyboardKeyMapReducer()
        .pullback(
            toLocalState: \.keyboardInputContext
        )
).eraseToAnyReducer()
