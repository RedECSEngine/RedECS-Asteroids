import RedECS
import RedECSBasicComponents
import RedECSRenderingComponents
import Geometry

// repositions ships and asteroids, and removes bullets
public struct AsteroidsPositioningReducer: Reducer {
    public func reduce(
        state: inout AsteroidsGameState,
        delta: Double,
        environment: Void
    ) -> GameEffect<AsteroidsGameState, AsteroidsGameAction> {
        
        var gameEffects: [GameEffect<AsteroidsGameState, AsteroidsGameAction>] = []
        
        for entityId in state.entities.entityIds {
            guard let entity = state.entities[entityId],
                    var position = state.position[entityId] else { continue }
            var shouldRemove = false
            if position.point.x > state.size.width {
                if entity.tags.contains("bullet") {
                    shouldRemove = true
                } else {
                    position.point.x = 0
                }
            }
            if position.point.x < 0 {
                if entity.tags.contains("bullet") {
                    shouldRemove = true
                } else {
                    position.point.x = state.size.width
                }
            }
            if position.point.y > state.size.height {
                if entity.tags.contains("bullet") {
                    shouldRemove = true
                } else {
                    position.point.y = 0
                }
            }
            if position.point.y < 0 {
                if entity.tags.contains("bullet") {
                   shouldRemove = true
                } else {
                    position.point.y = state.size.height
                }
            }
                        
            if shouldRemove {
                gameEffects.append(.system(.removeEntity(entityId)))
            } else {
                state.position[entityId] = position
            }
        }
        
        return .many(gameEffects)
    }
    
    public func reduce(
        state: inout AsteroidsGameState,
        action: AsteroidsGameAction,
        environment: Void
    ) -> GameEffect<AsteroidsGameState, AsteroidsGameAction> {
        return .none
    }
    
}
