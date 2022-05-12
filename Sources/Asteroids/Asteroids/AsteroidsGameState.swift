import RedECS
import RedECSBasicComponents
import RedECSRenderingComponents
import Geometry

public struct AsteroidsGameState: GameState {
    public var entities: EntityRepository = .init()
    
    public var asteroid: [EntityId: AsteroidComponent] = [:]
    public var ship: [EntityId: ShipComponent] = [:]
    public var shape: [EntityId: ShapeComponent] = [:]
    public var position: [EntityId: PositionComponent] = [:]
    public var transform: [EntityId: TransformComponent] = [:]
    public var movement: [EntityId: MovementComponent] = [:]
    public var momentum: [EntityId: MomentumComponent] = [:]
    
    public var keyboardInput: [EntityId: KeyboardInputComponent<AsteroidsGameAction>] = [:]
    
    var lastDelta: Double = 0
    public var size: Size = .init(width: 480, height: 480)
     
    /**
        
    - collision (proximity interaction)
    - asteroid positioning safely away from ship
    - asteroid explode on collision
     */
    
    public init() {}
}

public extension AsteroidsGameState {
    var shapeContext: ShapeRenderingContext {
        get {
            ShapeRenderingContext(
                entities: entities,
                position: position,
                transform: transform,
                shape: shape
            )
        }
        set {
            self.position = newValue.position
            self.transform = newValue.transform
            self.shape = newValue.shape
        }
    }
}

public extension AsteroidsGameState {
    var movementContext: MovementReducerContext {
        get {
            MovementReducerContext(
                entities: entities,
                position: position,
                movement: movement
            )
        }
        set {
            self.position = newValue.position
            self.movement = newValue.movement
        }
    }
}

public extension AsteroidsGameState {
    var momentumContext: MomentumReducerContext {
        get {
            MomentumReducerContext(
                entities: entities,
                momentum: momentum,
                movement: movement
            )
        }
        set {
            self.momentum = newValue.momentum
            self.movement = newValue.movement
        }
    }
}

public extension AsteroidsGameState {
    var keyboardInputContext: KeyboardInputReducerContext<AsteroidsGameAction> {
        get {
            KeyboardInputReducerContext(entities: entities, keyboardInput: keyboardInput)
        }
        set {
            self.keyboardInput = newValue.keyboardInput
        }
    }
}
