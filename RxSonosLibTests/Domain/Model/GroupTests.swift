//
//  GroupTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 26/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSSDP
@testable import RxSonosLib

class GroupTests: XCTestCase {
    
    override func setUp() {
        RepositoryInjection.shared.contentDirectoryRepository = FakeContentDirectoryRepositoryImpl()
        RepositoryInjection.shared.groupRepository = FakeGroupRepositoryImpl()
        RepositoryInjection.shared.renderingControlRepository = FakeRenderingControlRepositoryImpl()
        RepositoryInjection.shared.roomRepository = FakeRoomRepositoryImpl()
        RepositoryInjection.shared.ssdpRepository = FakeSSDPRepositoryImpl()
        RepositoryInjection.shared.transportRepository = FakeTransportRepositoryImpl()
        _ = SonosInteractor.shared
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
    
    func testItCanCompareGroupsOnMaster() {
        let group1 = Group(master: firstRoom(), slaves: [])
        let group2 = Group(master: firstRoom(), slaves: [])
        
        XCTAssertEqual(group1, group2)
    }
    
    func testItCanCompareDifferentGroupsOnMaster() {
        let group1 = Group(master: firstRoom(), slaves: [])
        let group2 = Group(master: secondRoom(), slaves: [])
        
        XCTAssertNotEqual(group1, group2)
    }
    
    func testItCanCompareGroupsWithDifferentOrderSlaves() {
        let group1 = Group(master: firstRoom(), slaves: [secondRoom(), thirdRoom()])
        let group2 = Group(master: firstRoom(), slaves: [thirdRoom(), secondRoom()])
        
        XCTAssertEqual(group1, group2)
    }
    
    func testItCanCompareDifferentGroupsOnSlaves() {
        let group1 = Group(master: firstRoom(), slaves: [secondRoom()])
        let group2 = Group(master: firstRoom(), slaves: [thirdRoom()])
        
        XCTAssertNotEqual(group1, group2)
    }
    
    func testItCanCompareDifferentGroupsOnMultipleSlaves() {
        let group1 = Group(master: firstRoom(), slaves: [thirdRoom(), secondRoom()])
        let group2 = Group(master: firstRoom(), slaves: [thirdRoom()])
        
        XCTAssertNotEqual(group1, group2)
    }
    
    func testItCanGetTheGroupName() {
        let group = Group(master: firstRoom(), slaves: [thirdRoom(), secondRoom()])
        XCTAssertEqual(group.name, "Living +2")
    }
    
    func testItCanGetTheGroupNameWhenThereAreNoSlaved() {
        let group = Group(master: firstRoom(), slaves: [])
        XCTAssertEqual(group.name, "Living")
    }
    
    func testItCanGetTheActiveTrack() {
        let group = Group(master: firstRoom(), slaves: [])
        let track = try! group
            .getTrack()
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
    
    func testItCanGetTheTransportState() {
        let group = Group(master: firstRoom(), slaves: [])
        let result = try! group.getTransportState().toBlocking().first()!
        XCTAssertEqual(result.0, TransportState.paused)
        XCTAssertEqual(result.1, MusicService.spotify)
    }
    
    func testItCanSetTheTransportState() {
        let mock = RepositoryInjection.shared.renderingControlRepository as! FakeRenderingControlRepositoryImpl
        let group = Group(master: firstRoom(), slaves: [])
        let newState = try! group.set(transportState: .playing)
            .map({ _ in return mock.activeState })
            .toBlocking()
            .first()!
        XCTAssertEqual(newState, TransportState.playing)
        
    }
    
    func testItCanGetTheVolume() {
        let group = Group(master: firstRoom(), slaves: [])
        let volume = try! group.getVolume().toBlocking().first()!
        XCTAssertEqual(volume, 70)
    }
    
    func testItCanSetTheVolume() {
        let mock = RepositoryInjection.shared.renderingControlRepository as! FakeRenderingControlRepositoryImpl
        let group = Group(master: firstRoom(), slaves: [])
        let newVolume = try! group.set(volume: 22)
            .map({ _ in return mock.lastVolume })
            .toBlocking()
            .first()!
        XCTAssertEqual(newVolume, 22)
    }
    
    func testItCanSetTheNextTrack() {
        let mock = RepositoryInjection.shared.transportRepository as! FakeTransportRepositoryImpl
        mock.nextTrackCounter = 0
        
        let group = Group(master: firstRoom(), slaves: [])
        let counter = try! group
            .setNextTrack()
            .map({ return mock.nextTrackCounter })
            .toBlocking()
            .first()!
        XCTAssertEqual(counter, 1)
    }
    
    func testItCanSetThePreviousTrack() {
        let mock = RepositoryInjection.shared.transportRepository as! FakeTransportRepositoryImpl
        mock.previousTrackCounter = 0
        
        let group = Group(master: firstRoom(), slaves: [])
        let counter = try! group
            .setPreviousTrack()
            .map({ return mock.previousTrackCounter })
            .toBlocking()
            .first()!
        XCTAssertEqual(counter, 1)
    }
    
    func testItCanGetTheMute() {
        let mock = RepositoryInjection.shared.renderingControlRepository as! FakeRenderingControlRepositoryImpl
        mock.numberSetMuteCalls = 0
        mock.numberGetMuteCalls = 0
        
        let group = Group(master: firstRoom(), slaves: [secondRoom()])
        let muted = try! group
            .getMute()
            .toBlocking()
            .first()!
        
        XCTAssertTrue(muted)
        XCTAssertEqual(mock.numberSetMuteCalls, 0)
        XCTAssertEqual(mock.numberGetMuteCalls, 1)
    }
    
    func testItSanGetTheMute() {
        let mock = RepositoryInjection.shared.renderingControlRepository as! FakeRenderingControlRepositoryImpl
        mock.numberSetMuteCalls = 0
        mock.numberGetMuteCalls = 0
        
        let group = Group(master: firstRoom(), slaves: [secondRoom()])
        let counter = try! group
            .set(mute: true)
            .map({ _ in
                return mock.numberSetMuteCalls
            })
            .toBlocking()
            .first()!
        XCTAssertEqual(counter, 2)
        XCTAssertEqual(mock.numberGetMuteCalls, 0)
    }
    
}
