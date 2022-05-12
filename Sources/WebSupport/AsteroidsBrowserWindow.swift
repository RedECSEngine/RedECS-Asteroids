import Asteroids
import JavaScriptKit
import RedECS
import RedECSBasicComponents
import RedECSRenderingComponents
import RedECSWebSupport
import Geometry

let asteroidsWebReducer: AnyReducer<AsteroidsGameState, AsteroidsGameAction, AsteroidsWebEnvironment> = (
    asteroidsCoreReducer.pullback(
        toLocalState: \.self,
        toLocalAction: { $0 },
        toGlobalAction: { $0 },
        toLocalEnvironment: { _ in () }
    )
    + WebShapeRenderingReducer()
        .pullback(toLocalState: \.shapeContext, toLocalEnvironment: { $0 as WebRenderingEnvironment })
).eraseToAnyReducer()

struct AsteroidsWebEnvironment: WebRenderingEnvironment {
    var renderer: WebRenderer
    
    init(renderer: WebRenderer) {
        self.renderer = renderer
    }
}

public class AsteroidsGame: WebBrowserWindow {
    var store: GameStore<AnyReducer<AsteroidsGameState, AsteroidsGameAction, AsteroidsWebEnvironment>>!
    var lastTime: Double?
    
    public convenience init() {
        let state = AsteroidsGameState()
        self.init(size: state.size)
        store = GameStore(
            state: state,
            environment: AsteroidsWebEnvironment(renderer: self.renderer),
            reducer: asteroidsWebReducer,
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
    }
    
    required init(size: Size) {
        super.init(size: size)
    }
    
    public override func onWebRendererReady() {
        super.onWebRendererReady()
        print("new game")
        store.sendAction(.newGame)
    }
    
    public override func update(_ currentTime: Double) {
        super.update(currentTime)
        if let lastTime = lastTime {
            let delta = (currentTime - lastTime) / 10
            store.sendDelta(delta)
        }
        lastTime = currentTime
    }
    
    public override func onKeyDown(_ key: KeyboardInput) {
        store.sendAction(.keyboardInput(.keyDown(key)))
    }
    
    public override func onKeyUp(_ key: KeyboardInput) {
        store.sendAction(.keyboardInput(.keyUp(key)))
    }
}
