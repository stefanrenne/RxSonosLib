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
    
    func testItCanCompareDifferentGroupsOnMaster() throws {
        let group1 = firstGroup()
        let group2 = try Group(master: secondRoom(), slaves: [])
        
        XCTAssertNotEqual(group1, group2)
    }
    
    func testItCanCompareGroupsWithDifferentOrderSlaves() throws {
        let group1 = try Group(master: firstRoom(), slaves: [secondRoom(), thirdRoom()])
        let group2 = try Group(master: firstRoom(), slaves: [thirdRoom(), secondRoom()])
        
        XCTAssertEqual(group1, group2)
    }
    
    func testItCanCompareDifferentGroupsOnSlaves() throws {
        let group1 = try Group(master: firstRoom(), slaves: [secondRoom()])
        let group2 = try Group(master: firstRoom(), slaves: [thirdRoom()])
        
        XCTAssertNotEqual(group1, group2)
    }
    
    func testItCanCompareDifferentGroupsOnMultipleSlaves() throws {
        let group1 = try Group(master: firstRoom(), slaves: [thirdRoom(), secondRoom()])
        let group2 = try Group(master: firstRoom(), slaves: [thirdRoom()])
        
        XCTAssertNotEqual(group1, group2)
    }
    
    func testItCanGetTheGroupName() throws {
        let group = try Group(master: firstRoom(), slaves: [thirdRoom(), secondRoom()])
        XCTAssertEqual(group.name, "Living +2")
    }
    
    func testItCanGetTheGroupNameWhenThereAreNoSlaved() {
        let group = firstGroup()
        XCTAssertEqual(group.name, "Living")
    }
    
    func testItCanGetTheActiveTrack() throws {
        let group = Observable.just(firstGroup())
        let track = try group
            .getTrack()
            .filter({ $0 != nil })
            .toBlocking()
            .first() as? MusicProviderTrack
        
        XCTAssertEqual(track?.providerId, 9)
        XCTAssertNil(track?.flags)
        XCTAssertNil(track?.sn)
        XCTAssertEqual(track?.queueItem, 7)
        XCTAssertEqual(track?.duration, 265)
        XCTAssertEqual(track?.uri, "x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track?.imageUri.absoluteString, "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track?.title, "Before I Die")
        XCTAssertEqual(track?.artist, "Papa Roach")
        XCTAssertEqual(track?.album, "The Connection")
        XCTAssertNil(track?.information)
        XCTAssertEqual(track?.description, [TrackDescription.title: "Before I Die", TrackDescription.artist: "Papa Roach", TrackDescription.album: "The Connection"])
    }
    
    func testItCanGetTheImage() throws {
        let group = Observable.just(firstGroup())
        let imageData = try group
            .getImage()
            .toBlocking()
            .first()!
        
        let expectedData = UIImage(named: "papa-roach-the-connection.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil)!.pngData()
        XCTAssertEqual(imageData, expectedData)
    }
    
    func testItCanGetTheTransportState() throws {
        let group = Observable.just(firstGroup())
        let result = try group.getTransportState().toBlocking().first()!
        XCTAssertEqual(result, TransportState.paused)
    }
    
    func testItCanSetTheTransportState() throws {
        let mock = RepositoryInjection.shared.transportRepository as? FakeTransportRepositoryImpl
        XCTAssertNotNil(mock)
        let group = try Observable.just(secondGroup())
        _ = group.set(transportState: .playing)
            .toBlocking()
            .materialize()
        XCTAssertEqual(mock?.activeState, TransportState.playing)
        
    }
    
    func testItCanGetTheVolume() throws {
        let group = try Observable.just(secondGroup())
        let volume = try group.getVolume().toBlocking().first()!
        XCTAssertEqual(volume, 70)
    }
    
    func testItCanSetTheVolume() throws {
        let mock = RepositoryInjection.shared.renderingControlRepository as? FakeRenderingControlRepositoryImpl
        XCTAssertNotNil(mock)
        let group = try Observable.just(secondGroup())
        _ = group.set(volume: 22)
            .toBlocking()
            .materialize()
        XCTAssertEqual(mock?.lastVolume, 22)
    }
    
    func testItCanSetTheNextTrack() throws {
        let mock = RepositoryInjection.shared.transportRepository as? FakeTransportRepositoryImpl
        XCTAssertNotNil(mock)
        mock?.nextTrackCounter.reset()
        
        let group = try Observable.just(secondGroup())
        _ = group
            .setNextTrack()
            .toBlocking()
            .materialize()
        
        XCTAssertEqual(mock?.nextTrackCounter.value, 1)
    }
    
    func testItCanSetThePreviousTrack() throws {
        let mock = RepositoryInjection.shared.transportRepository as? FakeTransportRepositoryImpl
        XCTAssertNotNil(mock)
        mock?.previousTrackCounter.reset()
        
        let group = try Observable.just(secondGroup())
        _ = group
            .setPreviousTrack()
            .toBlocking()
            .materialize()
        
        XCTAssertEqual(mock?.previousTrackCounter.value, 1)
    }
    
    func testItCanGetTheMute() throws {
        let group = try Observable.just(secondGroup())
        let muted = try group
            .getMute()
            .toBlocking()
            .first()!
        
        XCTAssertEqual(muted, [true, true])
    }
    
    func testItCanSetTheMute() throws {
        let mock = RepositoryInjection.shared.renderingControlRepository as? FakeRenderingControlRepositoryImpl
        XCTAssertNotNil(mock)
        mock?.numberSetMuteCalls.reset()
        mock?.numberGetMuteCalls.reset()
        
        let group = try Observable.just(secondGroup())
        _ = group
            .set(mute: true)
            .toBlocking()
            .materialize()
        
        XCTAssertEqual(mock?.numberSetMuteCalls.value, 2)
        XCTAssertEqual(mock?.numberGetMuteCalls.value, 0)
    }
    
    func testItCanGetTheProgress() throws {
        let group = try Observable.just(secondGroup())
        let progress = try group
            .getProgress()
            .toBlocking()
            .first()!
        
        XCTAssertEqual(progress.time, 30)
        XCTAssertEqual(progress.duration, 60)
    }
    
    func testItCanGetTheQueue() throws {
        let group = try Observable.just(secondGroup())
        
        let queue = try group
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
    
    func testItCanGetTheNames() throws {
        XCTAssertEqual(try secondGroup().names, ["Living"])
    }
    
}
