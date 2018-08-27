//
//  GroupTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 26/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSSDP
import RxSwift
@testable import RxSonosLib

class GroupTests: XCTestCase {
    
    override func setUp() {
        resetToFakeRepositories()
        super.setUp()
    }
    
    override func tearDown() {
        resetToRealRepositories()
        super.tearDown()
    }
    
    func testItCanCompareGroupsOnMaster() {
        let group1 = firstGroup()
        let group2 = firstGroup()
        
        XCTAssertEqual(group1, group2)
    }
    
    func testItCanCompareDifferentGroupsOnMaster() {
        let group1 = firstGroup()
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
        let group = firstGroup()
        XCTAssertEqual(group.name, "Living")
    }
    
    func testItCanGetTheActiveTrack() {
        let group = Observable.just(firstGroup())
        let track = try! group
            .getTrack()
            .skip(1)
            .toBlocking()
            .first()! as! MusicProviderTrack
        
        XCTAssertEqual(track.providerId, 9)
        XCTAssertNil(track.flags)
        XCTAssertNil(track.sn)
        XCTAssertEqual(track.queueItem, 7)
        XCTAssertEqual(track.duration, 265)
        XCTAssertEqual(track.uri, "x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track.imageUri.absoluteString, "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track.title, "Before I Die")
        XCTAssertEqual(track.artist, "Papa Roach")
        XCTAssertEqual(track.album, "The Connection")
        XCTAssertNil(track.information)
        XCTAssertEqual(track.description, [TrackDescription.title: "Before I Die", TrackDescription.artist: "Papa Roach", TrackDescription.album: "The Connection"])
    }
    
    func testItCanGetTheImage() {
        let group = Observable.just(firstGroup())
        let imageData = try! group
            .getImage()
            .toBlocking()
            .first()!
        
        let expectedData = UIImagePNGRepresentation(UIImage(named: "papa-roach-the-connection.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil)!)
        XCTAssertEqual(imageData, expectedData)
    }
    
    func testItCanGetTheTransportState() {
        let group = Observable.just(firstGroup())
        let result = try! group.getTransportState().toBlocking().first()!
        XCTAssertEqual(result, TransportState.paused)
    }
    
    func testItCanSetTheTransportState() {
        let mock = RepositoryInjection.shared.renderingControlRepository as! FakeRenderingControlRepositoryImpl
        let group = Observable.just(secondGroup())
        _ = group.set(transportState: .playing)
            .toBlocking()
            .materialize()
        XCTAssertEqual(mock.activeState, TransportState.playing)
        
    }
    
    func testItCanGetTheVolume() {
        let group = Observable.just(secondGroup())
        let volume = try! group.getVolume().toBlocking().first()!
        XCTAssertEqual(volume, 70)
    }
    
    func testItCanSetTheVolume() {
        let mock = RepositoryInjection.shared.renderingControlRepository as! FakeRenderingControlRepositoryImpl
        let group = Observable.just(secondGroup())
        _ = group.set(volume: 22)
            .toBlocking()
            .materialize()
        XCTAssertEqual(mock.lastVolume, 22)
    }
    
    func testItCanSetTheNextTrack() {
        let mock = RepositoryInjection.shared.transportRepository as! FakeTransportRepositoryImpl
        mock.nextTrackCounter = 0
        
        let group = Observable.just(secondGroup())
        _ = group
            .setNextTrack()
            .toBlocking()
            .materialize()
        
        XCTAssertEqual(mock.nextTrackCounter , 1)
    }
    
    func testItCanSetThePreviousTrack() {
        let mock = RepositoryInjection.shared.transportRepository as! FakeTransportRepositoryImpl
        mock.previousTrackCounter = 0
        
        let group = Observable.just(secondGroup())
        _ = group
            .setPreviousTrack()
            .toBlocking()
            .materialize()
        
        XCTAssertEqual(mock.previousTrackCounter, 1)
    }
    
    func testItCanGetTheMute() {
        let group = Observable.just(secondGroup())
        let muted = try! group
            .getMute()
            .toBlocking()
            .first()!
        
        XCTAssertEqual(muted, [true, true])
    }
    
    func testItCanSetTheMute() {
        let mock = RepositoryInjection.shared.renderingControlRepository as! FakeRenderingControlRepositoryImpl
        mock.numberSetMuteCalls = 0
        mock.numberGetMuteCalls = 0
        
        let group = Observable.just(secondGroup())
        _ = group
            .set(mute: true)
            .toBlocking()
            .materialize()
        
        XCTAssertEqual(mock.numberSetMuteCalls, 2)
        XCTAssertEqual(mock.numberGetMuteCalls, 0)
    }
    
    func testItCanGetTheProgress() {
        let group = Observable.just(secondGroup())
        let progress = try! group
            .getProgress()
            .toBlocking()
            .first()!
        
        XCTAssertEqual(progress.time, 30)
        XCTAssertEqual(progress.duration, 60)
    }
    
    func testItCanGetTheQueue() {
        let group = Observable.just(secondGroup())
        
        let queue = try! group
            .getQueue()
            .toBlocking()
            .first()!
        
        XCTAssertEqual(queue.count, 2)
        
        let track1 = queue[0]
        XCTAssertEqual(track1.providerId, 9)
        XCTAssertNil(track1.flags)
        XCTAssertNil(track1.sn)
        XCTAssertEqual(track1.queueItem, 1)
        XCTAssertEqual(track1.duration, 265)
        XCTAssertEqual(track1.uri, "x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track1.imageUri.absoluteString, "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track1.title, "Before I Die")
        XCTAssertEqual(track1.artist, "Papa Roach")
        XCTAssertEqual(track1.album, "The Connection")
        XCTAssertNil(track1.information)
        XCTAssertEqual(track1.description, [TrackDescription.title: "Before I Die", TrackDescription.artist: "Papa Roach", TrackDescription.album: "The Connection"])
        
        let track2 = queue[1]
        XCTAssertEqual(track2.providerId, 9)
        XCTAssertNil(track2.flags)
        XCTAssertNil(track2.sn)
        XCTAssertEqual(track2.queueItem, 2)
        XCTAssertEqual(track2.duration, 197)
        XCTAssertEqual(track2.uri, "x-sonos-spotify:spotify%3atrack%3a2cTvamkNzLsIWrSHHW8yzy?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track2.imageUri.absoluteString, "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a2cTvamkNzLsIWrSHHW8yzy?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track2.title, "Christ Copyright")
        XCTAssertEqual(track2.artist, "Nothing More")
        XCTAssertEqual(track2.album, "Nothing More")
        XCTAssertNil(track2.information)
        XCTAssertEqual(track2.description, [TrackDescription.title: "Christ Copyright", TrackDescription.artist: "Nothing More", TrackDescription.album: "Nothing More"])
    }
    
    func testItCanGetTheNames() {
        XCTAssertEqual(secondGroup().names, ["Living"])
    }
    
}
