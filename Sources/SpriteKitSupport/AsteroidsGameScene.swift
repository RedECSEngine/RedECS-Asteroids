import Asteroids
import SpriteKit
import RedECS
import RedECSBasicComponents
import RedECSRenderingComponents
import RedECSSpriteKitSupport
import Geometry

public final class ExampleGameEnvironment: SpriteKitRenderingEnvironment {
    public var renderer: SpriteKitRenderer
    
    public init(renderer: SpriteKitRenderer) {
        self.renderer = renderer
    }
}


let asteroidsSpriteKitReducer: AnyReducer<AsteroidsGameState, AsteroidsGameAction, ExampleGameEnvironment> = (
    asteroidsCoreReducer.pullback(
        toLocalState: \.self,
        toLocalAction: { $0 },
        toGlobalAction: { $0 },
        toLocalEnvironment: { _ in () }
    )
    +
    SpriteKitShapeRenderingReducer()
        .pullback(toLocalState: \.shapeContext, toLocalEnvironment: { $0 as SpriteKitRenderingEnvironment })
).eraseToAnyReducer()

public class AsteroidsGameScene: SKScene {
    
    var store: GameStore<AnyReducer<AsteroidsGameState, AsteroidsGameAction, ExampleGameEnvironment>>!
    
    public override init() {
        let state = AsteroidsGameState()
        super.init(size: .init(width: state.size.width, height: state.size.height))
        store = GameStore(
            state: state,
            environment: ExampleGameEnvironment(renderer: .init(scene: self)),
            reducer: asteroidsSpriteKitReducer,
            registeredComponentTypes: [
                .init(keyPath: \.position),
                .init(keyPath: \.movement),
                .init(keyPath: \.transform),
                .init(keyPath: \.momentum),
                .init(keyPath: \.shape),
                .init(keyPath: \.ship),
                .init(keyPath: \.asteroid),
                .init(keyPath: \.keyboardInput)
            ]
        )
        
        store.sendAction(.newGame)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { nil }
    
    var lastTime: TimeInterval?
    
    public override func update(_ currentTime: TimeInterval) {
        
        if let lastTime = lastTime {
            store.sendDelta((currentTime - lastTime) * 100)
        }
        lastTime = currentTime
    }
    
}

#if os(OSX)
// Mouse-based event handling
extension AsteroidsGameScene {
    public override func keyDown(with event: NSEvent) {
        if let key = KeyboardInput(rawValue: event.keyCode) {
            store.sendAction(.keyboardInput(.keyDown(key)))
        } else {
            print("unmapped key down", event.keyCode)
        }
    }
    
    public override func keyUp(with event: NSEvent) {
        if let key = KeyboardInput(rawValue: event.keyCode) {
            store.sendAction(.keyboardInput(.keyUp(key)))
        } else {
            print("unmapped key up", event.keyCode)
        }
    }
}
#endif
