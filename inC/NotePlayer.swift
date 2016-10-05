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
//    let engine = AVAudioEngine()
//    let sampler = AVAudioUnitSampler()
//    let componentDescription = AudioComponentDescription(componentType: OSType(kAudioUnitType_MusicDevice), componentSubType: OSType(kAudioUnitType_MusicDevice), componentManufacturer: kAudioUnitManufacturer_Apple, componentFlags: 0, componentFlagsMask: 0)
//    var instrument: AVAudioUnitMIDIInstrument
//    
//    init() {
//        engine.prepare()
//        engine.attach(sampler)
//        engine.connect(sampler, to: engine.outputNode, format: nil)
//        instrument = AVAudioUnitMIDIInstrument(audioComponentDescription: componentDescription)
//        do {
//            try sampler.loadInstrument(at: )
//        }
//        catch {
//            print("couldn't add the instrument")
//        }
//    }
//    
//    func playNote() {
//        do {
//            try engine.start()
//        }
//        catch {
//            print("couldn't start")
//        }
//        
//        sampler.startNote(UInt8(60), withVelocity: 127, onChannel: 1)
////        sleep(5)
////        sampler.stopNote(UInt8(60), onChannel: 1)
//    }
    
    
    // Creating a track
    
//    let musicSequence = NewMusicSequence(nil)
//    let musicTrack = MusicSequenceNewTrack(nil, nil)
//    
//    var time = MusicTimeStamp(1.0)
//    var note = MIDINoteMessage(
//        channel: 0,
//        note: 60,
//        velocity: 64,
//        releaseVelocity: 0,
//        duration: 1.0 )
//    
//    func playNote() {
//        musicTrack = MusicTrackNewMIDINoteEvent(nil, time, note)
//        var musicPlayer = NewMusicPlayer(nil)
//        musicPlayer = MusicPlayerSetSequence(musicPlayer!, sequence)
//        musicPlayer = MusicPlayerStart(musicPlayer!)
//    }

}

class Sampler: NSObject {
    var engine: AVAudioEngine!
    var sampler: AVAudioUnitSampler!
    
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
    
    func setSessionPlayback() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.mixWithOthers)
        } catch {
            print("couldn't set category active \(error)")
        }
    }
    
    func play() {
        sampler.startNote(60, withVelocity: 64, onChannel: 0)
    }
    
    func stop() {
        sampler.stopNote(60, onChannel: 0)
    }
}

// Creating a player
