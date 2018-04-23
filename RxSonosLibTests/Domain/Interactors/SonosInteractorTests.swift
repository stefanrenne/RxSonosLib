//
//  SonosInteractorTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 20/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
@testable import RxSonosLib
import RxSwift
import RxSSDP
import RxBlocking

class SonosInteractorTests: XCTestCase {
    
    override func setUp() {
        self.reset()
        super.setUp()
    }
    
    override func tearDown() {
        RepositoryInjection.shared.contentDirectoryRepository = ContentDirectoryRepositoryImpl()
        RepositoryInjection.shared.groupRepository = GroupRepositoryImpl()
        RepositoryInjection.shared.renderingControlRepository = RenderingControlRepositoryImpl()
        RepositoryInjection.shared.roomRepository = RoomRepositoryImpl()
        RepositoryInjection.shared.ssdpRepository = SSDPRepositoryImpl()
        RepositoryInjection.shared.transportRepository = TransportRepositoryImpl()
        super.tearDown()
    }
    
    func testItCanProvideTheGroupsObservable() {
        
        reset()
        
        let groups = try! SonosInteractor
            .getAllGroups()
            .toBlocking()
            .first()!
        
        XCTAssertEqual(groups.count, 5)
        
        XCTAssertEqual(groups[0].master.uuid, "RINCON_000001")
        XCTAssertEqual(groups[0].slaves.count, 0)
        
        XCTAssertEqual(groups[1].master.uuid, "RINCON_000005")
        XCTAssertEqual(groups[1].slaves.count, 0)
        
        XCTAssertEqual(groups[2].master.uuid, "RINCON_000006")
        XCTAssertEqual(groups[2].slaves.count, 0)
        
        XCTAssertEqual(groups[3].master.uuid, "RINCON_000007")
        XCTAssertEqual(groups[3].slaves.count, 0)
        
        XCTAssertEqual(groups[4].master.uuid, "RINCON_000008")
        XCTAssertEqual(groups[4].slaves.count, 0)
    }
    
    func testItCanProvideTheNowPlayingObservable() {
        
        reset()
        
        let track = try! SonosInteractor
            .getActiveTrack()
            .toBlocking()
            .first()! as! SpotifyTrack
        
        XCTAssertEqual(track.service, .spotify)
        XCTAssertEqual(track.queueItem, 7)
        XCTAssertEqual(track.duration, 265)
        XCTAssertEqual(track.uri, "x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track.imageUri.absoluteString, "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track.title, "Before I Die")
        XCTAssertEqual(track.artist, "Papa Roach")
        XCTAssertEqual(track.album, "The Connection")
        XCTAssertEqual(track.description(), [TrackDescription.title: "Before I Die", TrackDescription.artist: "Papa Roach", TrackDescription.album: "The Connection"])
    }
    
    func testItCanProvideTheTransportStateObservable() {
        
        reset()
        
        let (state, service) = try! SonosInteractor
            .getActiveTransportState()
            .toBlocking()
            .first()!
        
        XCTAssertEqual(state, TransportState.paused)
        XCTAssertEqual(service, MusicService.spotify)
    }
    
    func testItCanProvideTheTrackImageObservable() {
        
        reset()
        
        let imageData = try! SonosInteractor
            .getActiveTrackImage()
            .toBlocking()
            .first()!
        
        let expectedData = UIImagePNGRepresentation(UIImage(named: "papa-roach-the-connection.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil)!)
        XCTAssertEqual(imageData, expectedData)
    }
    
    func testItCanProvideTheGroupProgressObservable() {
        
        reset()
        
        let progress = try! SonosInteractor
            .getActiveGroupProgress()
            .toBlocking()
            .first()!
        
        XCTAssertEqual(progress.time, 30)
        XCTAssertEqual(progress.duration, 60)
    }
    
    func testItCanProvideTheGroupQueueObservable() {
        
        reset()
        
        let queue = try! SonosInteractor
            .getActiveGroupQueue()
            .toBlocking()
            .first()!
        
        XCTAssertEqual(queue.count, 2)
        
        let track1 = queue[0] as! SpotifyTrack
        XCTAssertEqual(track1.service, .spotify)
        XCTAssertEqual(track1.queueItem, 1)
        XCTAssertEqual(track1.duration, 265)
        XCTAssertEqual(track1.uri, "x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track1.imageUri.absoluteString, "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track1.title, "Before I Die")
        XCTAssertEqual(track1.artist, "Papa Roach")
        XCTAssertEqual(track1.album, "The Connection")
        XCTAssertEqual(track1.description(), [TrackDescription.title: "Before I Die", TrackDescription.artist: "Papa Roach", TrackDescription.album: "The Connection"])
        
        let track2 = queue[1] as! SpotifyTrack
        XCTAssertEqual(track2.service, .spotify)
        XCTAssertEqual(track2.queueItem, 2)
        XCTAssertEqual(track2.duration, 197)
        XCTAssertEqual(track2.uri, "x-sonos-spotify:spotify%3atrack%3a2cTvamkNzLsIWrSHHW8yzy?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track2.imageUri.absoluteString, "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a2cTvamkNzLsIWrSHHW8yzy?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track2.title, "Christ Copyright")
        XCTAssertEqual(track2.artist, "Nothing More")
        XCTAssertEqual(track2.album, "Nothing More")
        XCTAssertEqual(track2.description(), [TrackDescription.title: "Christ Copyright", TrackDescription.artist: "Nothing More", TrackDescription.album: "Nothing More"])
    }
    
    func testItCanProvideTheGetVolumeObservable() {
        
        reset()
        
        let volume = try! SonosInteractor
            .getActiveGroupVolume()
            .toBlocking()
            .first()!
        
        XCTAssertEqual(volume, 70)
    }
    
    func testItCanProvideTheSetVolumeObservable() {
        
        reset()
        
        let mock = RepositoryInjection.shared.renderingControlRepository as! FakeRenderingControlRepositoryImpl
        XCTAssertNil(mock.lastVolume)
        
        let newVolume1 = try! SonosInteractor
            .setActiveGroup(volume: 20)
            .map({ _ in return mock.lastVolume })
            .toBlocking()
            .first()!
        
        XCTAssertEqual(newVolume1, 20)
    }
    
    func testItCanSetTheTransportStateObservable() {
        
        reset()
        
        let mock = RepositoryInjection.shared.renderingControlRepository as! FakeRenderingControlRepositoryImpl
        
        let newState1 = try! SonosInteractor
            .setActiveTransport(state: TransportState.paused)
            .map({ _ in return mock.activeState })
            .toBlocking()
            .first()!
        
        XCTAssertEqual(newState1, TransportState.paused)
        
        let newState2 = try! SonosInteractor
            .setActiveTransport(state: TransportState.stopped)
            .map({ _ in return mock.activeState })
            .toBlocking()
            .first()!
        
        XCTAssertEqual(newState2, TransportState.stopped)
    }
    
    func testItCantSetTheActiveGroupIfItDoesntExists() {
        
        reset()
        
        let allGroups = try! SonosInteractor.shared.allGroups.value()
        
        SonosInteractor.setActive(group: allGroups.first!)
        let activeGroup1 = try! SonosInteractor.shared.activeGroup.value()
        XCTAssertEqual(activeGroup1, allGroups.first)
        
        SonosInteractor.setActive(group: firstGroup())
        let activeGroup2 = try! SonosInteractor.shared.activeGroup.value()
        XCTAssertEqual(activeGroup2, allGroups.first)
    }
    
    func testItCanSetTheActiveGroup() {
        
        reset()
        
        let allGroups = try! SonosInteractor.shared.allGroups.value()
        
        SonosInteractor.setActive(group: allGroups.first!)
        let activeGroup1 = try! SonosInteractor.shared.activeGroup.value()
        XCTAssertEqual(activeGroup1, allGroups.first)
        
        SonosInteractor.setActive(group: allGroups.last!)
        let activeGroup2 = try! SonosInteractor.shared.activeGroup.value()
        XCTAssertEqual(activeGroup2, allGroups.last)
    }
    
    func testItCanSetTheActiveNextTrack() {
        
        reset()
        
        let mock = RepositoryInjection.shared.transportRepository as! FakeTransportRepositoryImpl
        mock.nextTrackCounter = 0
        mock.previousTrackCounter = 0
        
        let newNextTrackCounter = try! SonosInteractor
            .setActiveNextTrack()
            .map({ return mock.nextTrackCounter })
            .toBlocking()
            .first()!
        
        XCTAssertEqual(newNextTrackCounter, 1)
        XCTAssertEqual(mock.previousTrackCounter, 0)
    }
    
    func testItCanSetTheActivePreviousTrack() {
        
        reset()
        
        let mock = RepositoryInjection.shared.transportRepository as! FakeTransportRepositoryImpl
        mock.nextTrackCounter = 0
        mock.previousTrackCounter = 0
        
        let newPreviousTrackCounter = try! SonosInteractor
            .setActivePreviousTrack()
            .map({ return mock.previousTrackCounter })
            .toBlocking()
            .first()!
        
        XCTAssertEqual(newPreviousTrackCounter, 1)
        XCTAssertEqual(mock.nextTrackCounter, 0)
    }
    
}

fileprivate extension SonosInteractorTests {
    
    func reset() {
        RepositoryInjection.shared.contentDirectoryRepository = FakeContentDirectoryRepositoryImpl()
        let groupRepository = FakeGroupRepositoryImpl()
        RepositoryInjection.shared.groupRepository = groupRepository
        RepositoryInjection.shared.renderingControlRepository = FakeRenderingControlRepositoryImpl()
        RepositoryInjection.shared.roomRepository = FakeRoomRepositoryImpl()
        RepositoryInjection.shared.ssdpRepository = FakeSSDPRepositoryImpl()
        RepositoryInjection.shared.transportRepository = FakeTransportRepositoryImpl()
        SonosInteractor.shared.allGroups.onNext(groupRepository.allGroups)
        SonosInteractor.shared.activeGroup.onNext(groupRepository.allGroups.first)
    }
}
