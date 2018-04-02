//
//  TransportRepositoryTest.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 26/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
import Mockingjay
@testable import RxSonosLib

class TransportRepositoryTest: XCTestCase {
    
    let transportRepository: TransportRepository = TransportRepositoryImpl()
    
    
    func testItCantGetTheNowPlayingTrack() {
        
        stub(soap(call: .transportInfo), soapXml(""))
        stub(soap(call: .mediaInfo), soapXml(""))
        stub(soap(call: .positionInfo), soapXml(""))
        
        XCTAssertThrowsError(try transportRepository.getNowPlaying(for: randomRoom()).toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, NSError.sonosLibNoDataError().localizedDescription)
        }
    }
    
    func testItCanGetSpotifyNowPlayingTrack() {
        
        stub(soap(call: .mediaInfo), soapXml(getSpotifyMediaInfoResponse()))
        stub(soap(call: .positionInfo), soapXml(getSpotifyPositionInfoResponse()))
        
        let track = try! transportRepository
            .getNowPlaying(for: randomRoom())
            .toBlocking()
            .first()!
        
        XCTAssertEqual(track.service, .spotify)
        XCTAssertEqual(track.queueItem, 7)
        XCTAssertEqual(track.duration, 265)
        XCTAssertEqual(track.uri, "x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track.imageUri!.absoluteString, "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track.title, "Before I Die")
        XCTAssertEqual(track.artist, "Papa Roach")
        XCTAssertEqual(track.album, "The Connection")
    }
    
    func testItCanGetTVNowPlayingTrack() {
        
        stub(soap(call: .mediaInfo), soapXml(getTVMediaInfoResponse()))
        stub(soap(call: .positionInfo), soapXml(getTVPositionInfoResponse()))
        
        let track = try! transportRepository
            .getNowPlaying(for: randomRoom())
            .toBlocking()
            .first()!
        
        XCTAssertEqual(track.service, .tv)
        XCTAssertEqual(track.queueItem, 1)
        XCTAssertEqual(track.duration, 0)
        XCTAssertEqual(track.uri, "x-sonos-htastream:RINCON_000E58B4AE9601400:spdif")
        XCTAssertNil(track.imageUri)
        XCTAssertEqual(track.title, "TV")
        XCTAssertNil(track.artist)
        XCTAssertNil(track.album)
    }
    
    func testItCanGetTuneinNowPlayingTrack() {
        
        stub(soap(call: .mediaInfo), soapXml(getTuneinMediaInfoResponse()))
        stub(soap(call: .positionInfo), soapXml(getTuneinPositionInfoResponse()))
        
        let track = try! transportRepository
            .getNowPlaying(for: randomRoom())
            .toBlocking()
            .first()!
        
        XCTAssertEqual(track.service, .tunein)
        XCTAssertEqual(track.queueItem, 1)
        XCTAssertEqual(track.duration, 0)
        XCTAssertEqual(track.uri, "x-rincon-mp3radio://http://20863.live.streamtheworld.com:80/RADIO538.mp3?tdtok=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6ImZTeXA4In0.eyJpc3MiOiJ0aXNydiIsInN1YiI6IjIxMDY0IiwiaWF0IjoxNTIyNDQzMDQ5LCJ0ZC1yZWciOmZhbHNlfQ.kvTa2wxGb7-Rs7TjFjeRmPlzrkMnZGwDyBdyrru0Wbs")
        XCTAssertEqual(track.imageUri!.absoluteString, "http://192.168.3.14:1400/getaa?s=1&u=x-sonosapi-stream:s6712?sid=254&flags=32")
        XCTAssertEqual(track.title, "538")
        XCTAssertNil(track.artist)
        XCTAssertNil(track.album)
    }
    
    func testItCanGetTheTransportState() {
        
        stub(soap(call: .transportInfo), soapXml(getTransportInfoResponse()))
        
        let state = try! transportRepository
            .getTransportState(for: randomRoom())
            .toBlocking()
            .first()!
        
        XCTAssertEqual(state, .paused)
    }
    
    func testItCanGetTheImageForATrackWithAnImageUri() {
        let data = UIImageJPEGRepresentation(UIImage(named: "papa-roach-the-connection.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil)!, 1.0)!
        stub(everything, http(download: .content(data)))
        
        let track = Track(service: .spotify, queueItem: 7, duration: 265, uri: "x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1", imageUri: URL(string: "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1"), title: "Before I Die", artist: "Papa Roach", album: "The Connection")
        
        let image = try! transportRepository
            .getImage(for: track)
            .toBlocking()
            .first()!
        
        XCTAssert(image!.isEqual(to: UIImage(data: data)!))
    }
    
    func testItCantGetTheImageForATrackWithoutAnImageUri() {
        let data = UIImageJPEGRepresentation(UIImage(named: "papa-roach-the-connection.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil)!, 1.0)!
        stub(everything, http(download: .content(data)))

        let track = Track(service: .spotify, queueItem: 7, duration: 265, uri: "x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1", imageUri: nil, title: "Before I Die", artist: "Papa Roach", album: "The Connection")
        
        let image = try! transportRepository
            .getImage(for: track)
            .toBlocking()
            .first()!
        
        XCTAssertNil(image)
    }
    
    func testItCanGetTheCurrentGroupProgress() {
        
        stub(soap(call: .positionInfo), soapXml(getSpotifyPositionInfoResponse()))
        
        let progress = try! transportRepository
            .getNowPlayingProgress(for: randomRoom())
            .toBlocking()
            .first()!
        
        XCTAssertEqual(progress.time, 149)
        XCTAssertEqual(progress.timeString, "2:29")
        XCTAssertEqual(progress.duration, 265)
        XCTAssertEqual(progress.durationString, "4:25")
        XCTAssertEqual(progress.progress, 0.56)
        XCTAssertEqual(progress.remainingTimeString, "-1:56")
    }
}

fileprivate extension TransportRepositoryTest {
    
    func randomRoom() -> Room {
        let device = SSDPDevice(ip: URL(string: "http://192.168.3.14:1400")!, usn: "uuid:RINCON_000001::urn:schemas-upnp-org:device:ZonePlayer:1", server: "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS9)", ext: "", st: "urn:schemas-upnp-org:device:ZonePlayer:1", location: "/xml/device_description.xml", cacheControl: "max-age = 1800", uuid: "RINCON_000001", wifiMode: "0", variant: "0", household: "SONOS_HOUSEHOLD_1", bootseq: "81", proxy: nil)
        
        let description = DeviceDescription(name: "Living", modalNumber: "S9", modalName: "Sonos PLAYBAR", modalIcon: "/img/icon-S9.png", serialNumber: "00-00-00-00-00-01:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
        
        return Room(ssdpDevice: device, deviceDescription: description)
    }
    
    func getTransportInfoResponse() -> String {
        return "<CurrentTransportState>PAUSED_PLAYBACK</CurrentTransportState><CurrentTransportStatus>OK</CurrentTransportStatus><CurrentSpeed>1</CurrentSpeed>"
    }
    
    func getSpotifyMediaInfoResponse() -> String {
        return "<NrTracks>473</NrTracks><MediaDuration>NOT_IMPLEMENTED</MediaDuration><CurrentURI>x-rincon-queue:RINCON_000E58B4AE9601400#0</CurrentURI><CurrentURIMetaData></CurrentURIMetaData><NextURI></NextURI><NextURIMetaData></NextURIMetaData><PlayMedium>NETWORK</PlayMedium><RecordMedium>NOT_IMPLEMENTED</RecordMedium><WriteStatus>NOT_IMPLEMENTED</WriteStatus>"
    }
    
    func getSpotifyPositionInfoResponse() -> String {
        return "<Track>7</Track><TrackDuration>0:04:25</TrackDuration><TrackMetaData>&lt;DIDL-Lite xmlns:dc=&quot;http://purl.org/dc/elements/1.1/&quot; xmlns:upnp=&quot;urn:schemas-upnp-org:metadata-1-0/upnp/&quot; xmlns:r=&quot;urn:schemas-rinconnetworks-com:metadata-1-0/&quot; xmlns=&quot;urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/&quot;&gt;&lt;item id=&quot;-1&quot; parentID=&quot;-1&quot; restricted=&quot;true&quot;&gt;&lt;res protocolInfo=&quot;sonos.com-spotify:*:audio/x-spotify:*&quot; duration=&quot;0:04:25&quot;&gt;x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&amp;amp;flags=8224&amp;amp;sn=1&lt;/res&gt;&lt;r:streamContent&gt;&lt;/r:streamContent&gt;&lt;upnp:albumArtURI&gt;/getaa?s=1&amp;amp;u=x-sonos-spotify%3aspotify%253atrack%253a2MUy4hpwlwAaHV5mYHgMzd%3fsid%3d9%26flags%3d8224%26sn%3d1&lt;/upnp:albumArtURI&gt;&lt;dc:title&gt;Before I Die&lt;/dc:title&gt;&lt;upnp:class&gt;object.item.audioItem.musicTrack&lt;/upnp:class&gt;&lt;dc:creator&gt;Papa Roach&lt;/dc:creator&gt;&lt;upnp:album&gt;The Connection&lt;/upnp:album&gt;&lt;/item&gt;&lt;/DIDL-Lite&gt;</TrackMetaData><TrackURI>x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&amp;flags=8224&amp;sn=1</TrackURI><RelTime>0:02:29</RelTime><AbsTime>NOT_IMPLEMENTED</AbsTime><RelCount>2147483647</RelCount><AbsCount>2147483647</AbsCount>"
    }
    
    func getTVMediaInfoResponse() -> String {
        return "<NrTracks>1</NrTracks><MediaDuration>NOT_IMPLEMENTED</MediaDuration><CurrentURI>x-sonos-htastream:RINCON_000E58B4AE9601400:spdif</CurrentURI><CurrentURIMetaData>&lt;DIDL-Lite xmlns:dc=&quot;http://purl.org/dc/elements/1.1/&quot; xmlns:upnp=&quot;urn:schemas-upnp-org:metadata-1-0/upnp/&quot; xmlns:r=&quot;urn:schemas-rinconnetworks-com:metadata-1-0/&quot; xmlns=&quot;urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/&quot;&gt;&lt;item id=&quot;spdif-input&quot; parentID=&quot;0&quot; restricted=&quot;false&quot;&gt;&lt;dc:title&gt;RINCON_000E58B4AE9601400&lt;/dc:title&gt;&lt;upnp:class&gt;object.item.audioItem&lt;/upnp:class&gt;&lt;res protocolInfo=&quot;spdif&quot;&gt;x-sonos-htastream:RINCON_000E58B4AE9601400:spdif&lt;/res&gt;&lt;/item&gt;&lt;/DIDL-Lite&gt;</CurrentURIMetaData><NextURI></NextURI><NextURIMetaData></NextURIMetaData><PlayMedium>NETWORK</PlayMedium><RecordMedium>NOT_IMPLEMENTED</RecordMedium><WriteStatus>NOT_IMPLEMENTED</WriteStatus>"
    }
    
    func getTVPositionInfoResponse() -> String {
        return "<TrackDuration>NOT_IMPLEMENTED</TrackDuration><AbsTime>NOT_IMPLEMENTED</AbsTime><Track>1</Track><TrackMetaData>NOT_IMPLEMENTED</TrackMetaData><TrackURI>x-sonos-htastream:RINCON_000E58B4AE9601400:spdif</TrackURI><RelTime>NOT_IMPLEMENTED</RelTime><RelCount>2147483647</RelCount><AbsCount>2147483647</AbsCount>"
    }
    
    func getTuneinMediaInfoResponse() -> String {
        return "<NrTracks>1</NrTracks><MediaDuration>NOT_IMPLEMENTED</MediaDuration><CurrentURI>x-sonosapi-stream:s6712?sid=254&amp;flags=32</CurrentURI><CurrentURIMetaData>&lt;DIDL-Lite xmlns:dc=&quot;http://purl.org/dc/elements/1.1/&quot; xmlns:upnp=&quot;urn:schemas-upnp-org:metadata-1-0/upnp/&quot; xmlns:r=&quot;urn:schemas-rinconnetworks-com:metadata-1-0/&quot; xmlns=&quot;urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/&quot;&gt;&lt;item id=&quot;-1&quot; parentID=&quot;-1&quot; restricted=&quot;true&quot;&gt;&lt;dc:title&gt;538&lt;/dc:title&gt;&lt;upnp:class&gt;object.item.audioItem.audioBroadcast&lt;/upnp:class&gt;&lt;desc id=&quot;cdudn&quot; nameSpace=&quot;urn:schemas-rinconnetworks-com:metadata-1-0/&quot;&gt;SA_RINCON65031_&lt;/desc&gt;&lt;/item&gt;&lt;/DIDL-Lite&gt;</CurrentURIMetaData><NextURI></NextURI><NextURIMetaData></NextURIMetaData><PlayMedium>NETWORK</PlayMedium><RecordMedium>NOT_IMPLEMENTED</RecordMedium><WriteStatus>NOT_IMPLEMENTED</WriteStatus>"
    }
    
    func getTuneinPositionInfoResponse() -> String {
        return "<Track>1</Track><TrackDuration>0:00:00</TrackDuration><TrackMetaData>&lt;DIDL-Lite xmlns:dc=&quot;http://purl.org/dc/elements/1.1/&quot; xmlns:upnp=&quot;urn:schemas-upnp-org:metadata-1-0/upnp/&quot; xmlns:r=&quot;urn:schemas-rinconnetworks-com:metadata-1-0/&quot; xmlns=&quot;urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/&quot;&gt;&lt;item id=&quot;-1&quot; parentID=&quot;-1&quot; restricted=&quot;true&quot;&gt;&lt;res protocolInfo=&quot;x-rincon-mp3radio:*:*:*&quot;&gt;x-rincon-mp3radio://http://20863.live.streamtheworld.com:80/RADIO538.mp3?tdtok=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6ImZTeXA4In0.eyJpc3MiOiJ0aXNydiIsInN1YiI6IjIxMDY0IiwiaWF0IjoxNTIyNDQzMDQ5LCJ0ZC1yZWciOmZhbHNlfQ.kvTa2wxGb7-Rs7TjFjeRmPlzrkMnZGwDyBdyrru0Wbs&lt;/res&gt;&lt;r:streamContent&gt;&lt;/r:streamContent&gt;&lt;dc:title&gt;RADIO538.mp3?tdtok=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6ImZTeXA4In0.eyJpc3MiOiJ0aXNydiIsInN1YiI6IjIxMDY0IiwiaWF0IjoxNTIyNDQzMDQ5LCJ0ZC1yZWciOmZhbHNlfQ.kvTa2wxGb7-Rs7TjFjeRmPlzrkMnZGwDyBdyrru0Wbs&lt;/dc:title&gt;&lt;upnp:class&gt;object.item&lt;/upnp:class&gt;&lt;/item&gt;&lt;/DIDL-Lite&gt;</TrackMetaData><TrackURI>x-rincon-mp3radio://http://20863.live.streamtheworld.com:80/RADIO538.mp3?tdtok=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6ImZTeXA4In0.eyJpc3MiOiJ0aXNydiIsInN1YiI6IjIxMDY0IiwiaWF0IjoxNTIyNDQzMDQ5LCJ0ZC1yZWciOmZhbHNlfQ.kvTa2wxGb7-Rs7TjFjeRmPlzrkMnZGwDyBdyrru0Wbs</TrackURI><RelTime>0:01:54</RelTime><AbsTime>NOT_IMPLEMENTED</AbsTime><RelCount>2147483647</RelCount><AbsCount>2147483647</AbsCount>"
    }
    
}

extension UIImage {
    
    func isEqual(to image: UIImage) -> Bool {
        let data1 = UIImagePNGRepresentation(self)!
        let data2 = UIImagePNGRepresentation(image)!
        return data1.count == data2.count
    }
    
}
