import AudioToolbox
import Foundation

final class SoundManager {
    static let shared = SoundManager()

    func playCorrect() {
        AudioServicesPlaySystemSound(1104) // SMSReceived
    }

    func playWrong() {
        AudioServicesPlaySystemSound(1053) // Tock
    }

    func playPulse() {
        AudioServicesPlaySystemSound(1103) // ReceivedMessage
    }
}