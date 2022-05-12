import RedECS
import RedECSBasicComponents

public enum AsteroidsGameAction: Equatable & Codable {
    case newGame
    case keyboardInput(KeyboardInputAction)
    case rotateLeft
    case rotateRight
    case propelForward
    case fireBullet
}
