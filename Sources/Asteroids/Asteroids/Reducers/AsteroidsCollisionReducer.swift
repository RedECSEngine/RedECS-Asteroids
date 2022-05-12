import RedECS
import RedECSBasicComponents
import RedECSRenderingComponents
import Geometry

public struct AsteroidsCollisionReducer: Reducer {
    public func reduce(
        state: inout AsteroidsGameState,
        delta: Double,
        environment: Void
    ) -> GameEffect<AsteroidsGameState, AsteroidsGameAction> {
        var gameEffects: [GameEffect<AsteroidsGameState, AsteroidsGameAction>] = []
        var removeIds: Set<EntityId> = []
        for entityId in state.entities.entityIds {
            guard let entity = state.entities[entityId],
                    let position = state.position[entityId] else { continue }
        
            guard entity.tags.contains("bullet") else { continue }
            
            for (asteroidId, asteroid) in state.asteroid {
                guard let asteroidPosition = state.position[asteroidId] else { continue }
                if asteroid.intersects(
                    Circle(center: position.point, radius: 2),
                    whenPositionedAt: asteroidPosition.point
                ) {
                    removeIds.insert(asteroidId)
                    if asteroid.size > 1 {
                        gameEffects.append(.many([
                            generateAsteroidCreationActions(size: asteroid.size - 1, point: asteroidPosition.point),
                            generateAsteroidCreationActions(size: asteroid.size - 1, point: asteroidPosition.point),
                            generateAsteroidCreationActions(size: asteroid.size - 1, point: asteroidPosition.point)
                        ]))
                    }
                    removeIds.insert(entityId)
                    break
                }
            }
        }
        let allEffects = gameEffects + removeIds.map({ .system(.removeEntity($0)) })
        return .many(allEffects)
    }
    
    public func reduce(
        state: inout AsteroidsGameState,
        action: AsteroidsGameAction,
        environment: Void
    ) -> GameEffect<AsteroidsGameState, AsteroidsGameAction> {
        return .none
    }
    
}
