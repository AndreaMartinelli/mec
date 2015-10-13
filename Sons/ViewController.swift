

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    private var trilhaPlayer: AVAudioPlayer!
    private var players = [AVAudioPlayer]()
    
    // MARK: - Outlets
    
    @IBOutlet weak var trilhaButton: UIButton!
    
    @IBOutlet weak var gaivotaButton: UIButton!
    @IBOutlet weak var tecladoButton: UIButton!
    @IBOutlet weak var teleportButton: UIButton!
    @IBOutlet weak var zuuumButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func trilhaPlayPause(sender: UIButton) {
        if !trilhaPlayer.playing {
            trilhaPlayer.play()
        } else {
            trilhaPlayer.pause()
        }
    }
    
    @IBAction func soundPlayPause(sender: UIButton) {
        if !players[sender.tag].playing {
            players[sender.tag].play()
        } else {
            players[sender.tag].pause()
        }
    }
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // - Tocar sons com qualquer duração
        // - Loops
        // - Multiplos sons simultaneos
        
        carregarTrilha()
        carregarSons()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let progresso = UIView(frame: trilhaButton.bounds)
        progresso.frame.size.width = 0
        progresso.backgroundColor = UIColor.redColor()
        progresso.tag = 5
        trilhaButton.insertSubview(progresso,
            belowSubview: trilhaButton.subviews[0] 
        )
    }
    
    // MARK: - Progresso
    
    func tick() {
        let porcentagem = trilhaPlayer.currentTime / trilhaPlayer.duration
        var novoTamanho = trilhaButton.bounds
        novoTamanho.size.width *= CGFloat(porcentagem)
        trilhaButton.viewWithTag(5)!.frame = novoTamanho
    }
    
    // MARK: - Carregar Sons
    
    private func carregarTrilha() {
        if let trilhaURL = NSBundle.mainBundle().URLForResource("trilha", withExtension: "mp3")
        {
            let error: NSErrorPointer = nil
            do {
                trilhaPlayer = try AVAudioPlayer(
                    contentsOfURL: trilhaURL)
            } catch let error1 as NSError {
                error.memory = error1
                trilhaPlayer = nil
            }
            trilhaPlayer.volume = 0.8
            trilhaPlayer.numberOfLoops = -1
            
            if error != nil {
                print(error)
            }
            
            // comeca a tocar
            trilhaPlayer.play()
            
            // disparando timer para atualizar progresso
            NSTimer.scheduledTimerWithTimeInterval(1,
                target: self,
                selector: "tick",
                userInfo: nil,
                repeats: true
            )
        }
    }
    
    private func carregarSons() {
        let sons: [(nome: String, extensao: String)] = [
            ("gaivota" , "mp3"),
            ("teclado" , "mp3"),
            ("teleport", "mp3"),
            ("zuuum"   , "mp3")
        ]
        
        for som in sons {
            if let somURL = NSBundle.mainBundle()
                .URLForResource(som.nome,
                    withExtension: som.extensao)
            {
                let error: NSErrorPointer = nil
                let player: AVAudioPlayer!
                do {
                    player = try AVAudioPlayer(contentsOfURL: somURL)
                } catch let error1 as NSError {
                    error.memory = error1
                    player = nil
                }
                
                if error != nil {
                    print(error)
                }
                
                // preparar para tocar
                player.prepareToPlay()
                
                // guarda o player para usar nos botoes
                players.append(player)
            }
        }
    }
}
