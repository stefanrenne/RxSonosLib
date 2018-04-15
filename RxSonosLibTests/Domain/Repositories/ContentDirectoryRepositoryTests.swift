//
//  ContentDirectoryRepositoryTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
import Mockingjay
@testable import RxSonosLib

class ContentDirectoryRepositoryTests: XCTestCase {
    
    let contentDirectoryRepository: ContentDirectoryRepository = ContentDirectoryRepositoryImpl()
    
    override func setUp() {
        CacheManager.shared.deleteAll()
    }
    
    func testItCanGetAQueue() {
        
        stub(soap(call: .browse), soapXml(getBrowseResponse()))
        
        let queue = try! contentDirectoryRepository
            .getQueue(for: firstRoom())
            .toBlocking()
            .first()!
        
        XCTAssertEqual(queue.count, 5)
        
        let track1 = queue[0] as! SpotifyTrack
        XCTAssertEqual(track1.service, .spotify)
        XCTAssertEqual(track1.queueItem, 1)
        XCTAssertEqual(track1.duration, 236)
        XCTAssertEqual(track1.uri, "x-sonos-spotify:spotify%3atrack%3a0Vh1sTeybmGy8Kxl2vw0Ye?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track1.imageUri.absoluteString, "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a0Vh1sTeybmGy8Kxl2vw0Ye?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track1.title, "Time Is Running Out - (Live) Explicit Version")
        XCTAssertEqual(track1.artist, "Papa Roach")
        XCTAssertEqual(track1.album, "Time For Annihilation: On the Record & On the Road")
        XCTAssertEqual(track1.description(), [TrackDescription.title: "Time Is Running Out - (Live) Explicit Version", TrackDescription.artist: "Papa Roach", TrackDescription.album: "Time For Annihilation: On the Record & On the Road"])
        
        let track2 = queue[1] as! SpotifyTrack
        XCTAssertEqual(track2.service, .spotify)
        XCTAssertEqual(track2.queueItem, 2)
        XCTAssertEqual(track2.duration, 146)
        XCTAssertEqual(track2.uri, "x-sonos-spotify:spotify%3atrack%3a6sZbp8aerVAFH9wr6yRU4f?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track2.imageUri.absoluteString, "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a6sZbp8aerVAFH9wr6yRU4f?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track2.title, "The Finger")
        XCTAssertEqual(track2.artist, "Danko Jones")
        XCTAssertEqual(track2.album, "Sleep Is The Enemy")
        XCTAssertEqual(track2.description(), [TrackDescription.title: "The Finger", TrackDescription.artist: "Danko Jones", TrackDescription.album: "Sleep Is The Enemy"])
        
        let track3 = queue[2] as! SpotifyTrack
        XCTAssertEqual(track3.service, .spotify)
        XCTAssertEqual(track3.queueItem, 3)
        XCTAssertEqual(track3.duration, 197)
        XCTAssertEqual(track3.uri, "x-sonos-spotify:spotify%3atrack%3a2cTvamkNzLsIWrSHHW8yzy?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track3.imageUri.absoluteString, "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a2cTvamkNzLsIWrSHHW8yzy?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track3.title, "Christ Copyright")
        XCTAssertEqual(track3.artist, "Nothing More")
        XCTAssertEqual(track3.album, "Nothing More")
        XCTAssertEqual(track3.description(), [TrackDescription.title: "Christ Copyright", TrackDescription.artist: "Nothing More", TrackDescription.album: "Nothing More"])
        
        let track4 = queue[3] as! SpotifyTrack
        XCTAssertEqual(track4.service, .spotify)
        XCTAssertEqual(track4.queueItem, 4)
        XCTAssertEqual(track4.service, .spotify)
        XCTAssertEqual(track4.queueItem, 4)
        XCTAssertEqual(track4.duration, 218)
        XCTAssertEqual(track4.uri, "x-sonos-spotify:spotify%3atrack%3a2cZXlLwkRmDww37tbEygXl?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track4.imageUri.absoluteString, "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a2cZXlLwkRmDww37tbEygXl?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track4.title, "Keys To The Kingdom")
        XCTAssertEqual(track4.artist, "Linkin Park")
        XCTAssertEqual(track4.album, "The Hunting Party")
        XCTAssertEqual(track4.description(), [TrackDescription.title: "Keys To The Kingdom", TrackDescription.artist: "Linkin Park", TrackDescription.album: "The Hunting Party"])
        
        let track5 = queue[4] as! SpotifyTrack
        XCTAssertEqual(track5.service, .spotify)
        XCTAssertEqual(track5.queueItem, 5)
        XCTAssertEqual(track5.service, .spotify)
        XCTAssertEqual(track5.queueItem, 5)
        XCTAssertEqual(track5.duration, 232)
        XCTAssertEqual(track5.uri, "x-sonos-spotify:spotify%3atrack%3a3mJXMEOZGSmq1RfQw4y1qN?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track5.imageUri.absoluteString, "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a3mJXMEOZGSmq1RfQw4y1qN?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track5.title, "Bad Moon")
        XCTAssertEqual(track5.artist, "Hollywood Undead")
        XCTAssertEqual(track5.album, "Five")
        XCTAssertEqual(track5.description(), [TrackDescription.title: "Bad Moon", TrackDescription.artist: "Hollywood Undead", TrackDescription.album: "Five"])
        
    }
    
}

extension ContentDirectoryRepositoryTests {
    
    func firstRoom() -> Room {
        let device = SSDPDevice(ip: URL(string: "http://192.168.3.14:1400")!, usn: "uuid:RINCON_000001::urn:schemas-upnp-org:device:ZonePlayer:1", server: "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS9)", ext: "", st: "urn:schemas-upnp-org:device:ZonePlayer:1", location: "/xml/device_description.xml", cacheControl: "max-age = 1800", uuid: "RINCON_000001", wifiMode: "0", variant: "0", household: "SONOS_HOUSEHOLD_1", bootseq: "81", proxy: nil)
        
        let description = DeviceDescription(name: "Living", modalNumber: "S9", modalName: "Sonos PLAYBAR", modalIcon: "/img/icon-S9.png", serialNumber: "00-00-00-00-00-01:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
        
        return Room(ssdpDevice: device, deviceDescription: description)
    }
    
    func getBrowseResponse() -> String {
        return "<Result>&lt;DIDL-Lite xmlns:dc=&quot;http://purl.org/dc/elements/1.1/&quot; xmlns:upnp=&quot;urn:schemas-upnp-org:metadata-1-0/upnp/&quot; xmlns:r=&quot;urn:schemas-rinconnetworks-com:metadata-1-0/&quot; xmlns=&quot;urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/&quot;&gt;&lt;item id=&quot;Q:0/1&quot; parentID=&quot;Q:0&quot; restricted=&quot;true&quot;&gt;&lt;res protocolInfo=&quot;sonos.com-spotify:*:audio/x-spotify:*&quot; duration=&quot;0:03:56&quot;&gt;x-sonos-spotify:spotify%3atrack%3a0Vh1sTeybmGy8Kxl2vw0Ye?sid=9&amp;amp;flags=8224&amp;amp;sn=1&lt;/res&gt;&lt;upnp:albumArtURI&gt;/getaa?s=1&amp;amp;u=x-sonos-spotify%3aspotify%253atrack%253a0Vh1sTeybmGy8Kxl2vw0Ye%3fsid%3d9%26flags%3d8224%26sn%3d1&lt;/upnp:albumArtURI&gt;&lt;dc:title&gt;Time Is Running Out - (Live) Explicit Version&lt;/dc:title&gt;&lt;upnp:class&gt;object.item.audioItem.musicTrack&lt;/upnp:class&gt;&lt;dc:creator&gt;Papa Roach&lt;/dc:creator&gt;&lt;upnp:album&gt;Time For Annihilation: On the Record &amp;amp; On the Road&lt;/upnp:album&gt;&lt;r:tags&gt;1&lt;/r:tags&gt;&lt;/item&gt;&lt;item id=&quot;Q:0/2&quot; parentID=&quot;Q:0&quot; restricted=&quot;true&quot;&gt;&lt;res protocolInfo=&quot;sonos.com-spotify:*:audio/x-spotify:*&quot; duration=&quot;0:02:26&quot;&gt;x-sonos-spotify:spotify%3atrack%3a6sZbp8aerVAFH9wr6yRU4f?sid=9&amp;amp;flags=8224&amp;amp;sn=1&lt;/res&gt;&lt;upnp:albumArtURI&gt;/getaa?s=1&amp;amp;u=x-sonos-spotify%3aspotify%253atrack%253a6sZbp8aerVAFH9wr6yRU4f%3fsid%3d9%26flags%3d8224%26sn%3d1&lt;/upnp:albumArtURI&gt;&lt;dc:title&gt;The Finger&lt;/dc:title&gt;&lt;upnp:class&gt;object.item.audioItem.musicTrack&lt;/upnp:class&gt;&lt;dc:creator&gt;Danko Jones&lt;/dc:creator&gt;&lt;upnp:album&gt;Sleep Is The Enemy&lt;/upnp:album&gt;&lt;/item&gt;&lt;item id=&quot;Q:0/3&quot; parentID=&quot;Q:0&quot; restricted=&quot;true&quot;&gt;&lt;res protocolInfo=&quot;sonos.com-spotify:*:audio/x-spotify:*&quot; duration=&quot;0:03:17&quot;&gt;x-sonos-spotify:spotify%3atrack%3a2cTvamkNzLsIWrSHHW8yzy?sid=9&amp;amp;flags=8224&amp;amp;sn=1&lt;/res&gt;&lt;upnp:albumArtURI&gt;/getaa?s=1&amp;amp;u=x-sonos-spotify%3aspotify%253atrack%253a2cTvamkNzLsIWrSHHW8yzy%3fsid%3d9%26flags%3d8224%26sn%3d1&lt;/upnp:albumArtURI&gt;&lt;dc:title&gt;Christ Copyright&lt;/dc:title&gt;&lt;upnp:class&gt;object.item.audioItem.musicTrack&lt;/upnp:class&gt;&lt;dc:creator&gt;Nothing More&lt;/dc:creator&gt;&lt;upnp:album&gt;Nothing More&lt;/upnp:album&gt;&lt;/item&gt;&lt;item id=&quot;Q:0/4&quot; parentID=&quot;Q:0&quot; restricted=&quot;true&quot;&gt;&lt;res protocolInfo=&quot;sonos.com-spotify:*:audio/x-spotify:*&quot; duration=&quot;0:03:38&quot;&gt;x-sonos-spotify:spotify%3atrack%3a2cZXlLwkRmDww37tbEygXl?sid=9&amp;amp;flags=8224&amp;amp;sn=1&lt;/res&gt;&lt;upnp:albumArtURI&gt;/getaa?s=1&amp;amp;u=x-sonos-spotify%3aspotify%253atrack%253a2cZXlLwkRmDww37tbEygXl%3fsid%3d9%26flags%3d8224%26sn%3d1&lt;/upnp:albumArtURI&gt;&lt;dc:title&gt;Keys To The Kingdom&lt;/dc:title&gt;&lt;upnp:class&gt;object.item.audioItem.musicTrack&lt;/upnp:class&gt;&lt;dc:creator&gt;Linkin Park&lt;/dc:creator&gt;&lt;upnp:album&gt;The Hunting Party&lt;/upnp:album&gt;&lt;r:tags&gt;1&lt;/r:tags&gt;&lt;/item&gt;&lt;item id=&quot;Q:0/5&quot; parentID=&quot;Q:0&quot; restricted=&quot;true&quot;&gt;&lt;res protocolInfo=&quot;sonos.com-spotify:*:audio/x-spotify:*&quot; duration=&quot;0:03:52&quot;&gt;x-sonos-spotify:spotify%3atrack%3a3mJXMEOZGSmq1RfQw4y1qN?sid=9&amp;amp;flags=8224&amp;amp;sn=1&lt;/res&gt;&lt;upnp:albumArtURI&gt;/getaa?s=1&amp;amp;u=x-sonos-spotify%3aspotify%253atrack%253a3mJXMEOZGSmq1RfQw4y1qN%3fsid%3d9%26flags%3d8224%26sn%3d1&lt;/upnp:albumArtURI&gt;&lt;dc:title&gt;Bad Moon&lt;/dc:title&gt;&lt;upnp:class&gt;object.item.audioItem.musicTrack&lt;/upnp:class&gt;&lt;dc:creator&gt;Hollywood Undead&lt;/dc:creator&gt;&lt;upnp:album&gt;Five&lt;/upnp:album&gt;&lt;r:tags&gt;1&lt;/r:tags&gt;&lt;/item&gt;&lt;/DIDL-Lite&gt;</Result><NumberReturned>5</NumberReturned><TotalMatches>5</TotalMatches><UpdateID>179</UpdateID>"
    }
}
