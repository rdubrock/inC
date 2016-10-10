//
//  NotePlayer.swift
//  inC
//
//  Created by Russell DuBrock on 10/2/16.
//  Copyright © 2016 Russell DuBrock. All rights reserved.
//

import Foundation
import AudioToolbox
import AVFoundation

class NotePlayer {
}

class Sampler: NSObject {
    var engine: AVAudioEngine!
    var sampler: AVAudioUnitSampler!
    var sequencer: AVAudioSequencer!
    
    override init() {
        super.init()
        
        engine = AVAudioEngine()
        sampler = AVAudioUnitSampler()
        engine.attach(sampler)
        engine.connect(sampler, to: engine.mainMixerNode, format: nil)
        
        loadSF2PresetIntoSampler(preset: 0)
        
        addObservers()
        
        startEngine()
        
        setSessionPlayback()
        
        setupSequencer()
        
    }
    
    func loadSF2PresetIntoSampler(preset: UInt8) {
        guard let bankURL = Bundle.main.url(forResource: "GeneralUser GS MuseScore v1.442", withExtension: "sf2") else {
            print("could not load sound font")
            return
        }
        
        do {
            try self.sampler.loadSoundBankInstrument(at: bankURL, program: preset, bankMSB: UInt8(kAUSampler_DefaultMelodicBankMSB), bankLSB: UInt8(kAUSampler_DefaultBankLSB))
        } catch {
            print("error loading sound ban instrument")
        }
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: Selector(("engineConfigurationChange")), name: .AVAudioEngineConfigurationChange, object: engine)
        NotificationCenter.default.addObserver(self, selector: Selector(("sessionInterrupted")), name: .AVAudioSessionInterruption, object: engine)
        NotificationCenter.default.addObserver(self, selector: Selector(("sessionRouteChange")), name: .AVAudioSessionRouteChange, object: engine)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: .AVAudioEngineConfigurationChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: .AVAudioSessionInterruption, object: nil)
        NotificationCenter.default.removeObserver(self, name: .AVAudioSessionRouteChange, object: nil)
    }
    
    func startEngine() {
        if engine.isRunning {
            print("audio engine already started")
            return
        }
        
        do {
            try engine.start()
            print("audio engine started")
        } catch {
            print("couldn't start engine \(error)")
        }
    }
    
    func setupSequencer() {
        self.sequencer = AVAudioSequencer(audioEngine: self.engine)
        
        let options = AVMusicSequenceLoadOptions.smfChannelsToTracks
        
        if let fileURL = Bundle.main.url(forResource: "InCTest", withExtension: ".mid") {
            do {
                try sequencer.load(from: fileURL, options: options)
                print("laoded file")
            } catch {
                print("couldn't setup sequencer \(error)")
                return
            }
        }
        
    }
    
    func setSessionPlayback() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.mixWithOthers)
        } catch {
            print("couldn't set category active \(error)")
        }
    }
    
    func play() {
        if sequencer.isPlaying {
            stop()
        }
        
        sequencer.currentPositionInBeats = TimeInterval(0)
        
        do {
            try sequencer.start()
        } catch {
            print("cannot start \(error)")
        }
        //sampler.startNote(60, withVelocity: 64, onChannel: 0)
    }
    
    func stop() {
        sequencer.stop()
//        sampler.stopNote(60, onChannel: 0)
    }
}

// Creating a player
