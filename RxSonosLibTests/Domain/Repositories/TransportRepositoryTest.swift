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
    
    func testItCantGetTheNowPlayingTrack() throws {
        
        stub(soap(call: TransportTarget.transportInfo), soapXml(""))
        stub(soap(call: TransportTarget.mediaInfo), soapXml(""))
        stub(soap(call: TransportTarget.positionInfo), soapXml(""))
        
        let track = try transportRepository
            .getNowPlaying(for: firstRoom())
            .toBlocking()
            .first()!
        
        XCTAssertNil(track)
    }
    
    func testItCanGetSpotifyNowPlayingTrack() throws {
        
        stub(soap(call: TransportTarget.mediaInfo), soapXml(getSpotifyMediaInfoResponse()))
        stub(soap(call: TransportTarget.positionInfo), soapXml(getSpotifyPositionInfoResponse()))
        
        let track = try transportRepository
            .getNowPlaying(for: firstRoom())
            .toBlocking()
            .first() as? MusicProviderTrack
        
        XCTAssertEqual(track?.providerId, 9)
        XCTAssertEqual(track?.flags, 8224)
        XCTAssertEqual(track?.sn, 1)
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
    
    func testItCanGetTVNowPlayingTrack() throws {
        
        stub(soap(call: TransportTarget.mediaInfo), soapXml(getTVMediaInfoResponse()))
        stub(soap(call: TransportTarget.positionInfo), soapXml(getTVPositionInfoResponse()))
        
        let track = try transportRepository
            .getNowPlaying(for: firstRoom())
            .toBlocking()
            .first() as? TVTrack
        
        XCTAssertEqual(track?.queueItem, 1)
        XCTAssertEqual(track?.duration, 0)
        XCTAssertEqual(track?.uri, "x-sonos-htastream:RINCON_000E58B4AE9601400:spdif")
        XCTAssertNil(track?.title)
        XCTAssertNil(track?.artist)
        XCTAssertNil(track?.album)
        XCTAssertNil(track?.information)
        XCTAssertEqual(track?.description, [:])
    }
    
    func testItCanGetTuneinNowPlayingTrack() throws {
        
        stub(soap(call: TransportTarget.mediaInfo), soapXml(getTuneinMediaInfoResponse()))
        stub(soap(call: TransportTarget.positionInfo), soapXml(getTuneinPositionInfoResponse()))
        
        let track = try transportRepository
            .getNowPlaying(for: firstRoom())
            .toBlocking()
            .first() as? MusicProviderTrack
        
        XCTAssertEqual(track?.queueItem, 1)
        XCTAssertEqual(track?.duration, 0)
        XCTAssertEqual(track?.uri, "x-sonosapi-stream:s6712?sid=254&flags=32")
        XCTAssertEqual(track?.imageUri.absoluteString, "http://192.168.3.14:1400/getaa?s=1&u=x-sonosapi-stream:s6712?sid=254&flags=32")
        XCTAssertEqual(track?.title, "538")
        XCTAssertNil(track?.album)
        XCTAssertNil(track?.artist)
        XCTAssertEqual(track?.information, "DUA LIPA - IDGAF")
        XCTAssertEqual(track?.description, [TrackDescription.title: "538", TrackDescription.information: "DUA LIPA - IDGAF"])
    }
    
    func testItCanGetLibraryNowPlayingTrack() throws {
        
        stub(soap(call: TransportTarget.mediaInfo), soapXml(getLibraryMediaInfoResponse()))
        stub(soap(call: TransportTarget.positionInfo), soapXml(getLibraryPositionInfoResponse()))
        
        let track = try transportRepository
            .getNowPlaying(for: firstRoom())
            .toBlocking()
            .first() as? LibraryTrack
        
        XCTAssertEqual(track?.queueItem, 1)
        XCTAssertEqual(track?.duration, 45)
        XCTAssertEqual(track?.uri, "x-file-cifs://Stefan-MacBook/Music/iTunes/iTunes%20Media/Music/Sample%20Audio.mp3")
        XCTAssertEqual(track?.imageUri.absoluteString, "http://192.168.3.14:1400/getaa?u=x-file-cifs%3A%2F%2FStefan-MacBook%2FMusic%2FiTunes%2FiTunes%2520Media%2FMusic%2FSample%2520Audio.mp3")
        XCTAssertEqual(track?.title, "Perfect")
        XCTAssertEqual(track?.album, "Divide")
        XCTAssertEqual(track?.artist, "Ed Sheeran")
        XCTAssertNil(track?.information)
        XCTAssertEqual(track?.description, [TrackDescription.title: "Perfect", TrackDescription.artist: "Ed Sheeran", TrackDescription.album: "Divide"])
    }
    
    func testItCanGetTheTransportState() throws {
        
        stub(soap(call: TransportTarget.transportInfo), soapXml(getTransportInfoResponse()))
        
        let state = try transportRepository
            .getTransportState(for: firstRoom())
            .toBlocking()
            .first()!
        
        XCTAssertEqual(state, .paused)
    }
    
    func testItCanGetTheImageForATrackWithAnImageUri() throws {
        let data = UIImage(named: "papa-roach-the-connection.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil)!.jpegData(compressionQuality: 1.0)!
        stub(everything, http(download: .content(data)))
                
        let imageData = try transportRepository
            .getImage(for: firstTrack())
            .toBlocking()
            .first()!
        
        XCTAssertEqual(imageData, data)
    }
    
    func testItCantGetTheImageForATrackWithoutAnImageUri() throws {
        let data = UIImage(named: "papa-roach-the-connection.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil)!.jpegData(compressionQuality: 1.0)!
        stub(everything, http(download: .content(data)))

        let track = TVTrack(queueItem: 1, uri: "x-sonos-htastream:RINCON_000E58B4AE9601400:spdif")
        
        let image = try transportRepository
            .getImage(for: track)
            .toBlocking()
            .first()
        
        XCTAssertNil(image)
    }
    
    func testItCanGetTheCurrentGroupProgress() throws {
        
        stub(soap(call: TransportTarget.positionInfo), soapXml(getSpotifyPositionInfoResponse()))
        
        let progress = try transportRepository
            .getNowPlayingProgress(for: firstRoom())
            .toBlocking()
            .first()!
        
        XCTAssertEqual(progress.time, 149)
        XCTAssertEqual(progress.timeString, "2:29")
        XCTAssertEqual(progress.duration, 265)
        XCTAssertEqual(progress.durationString, "4:25")
        XCTAssertEqual(progress.progress, 0.56)
        XCTAssertEqual(progress.remainingTimeString, "-1:56")
    }
    
    func testItCanSetTheNextTrack() {
        stub(soap(call: TransportTarget.next), soapXml(""))
        
        XCTAssertNoThrow(try transportRepository
            .setNextTrack(for: firstRoom())
            .toBlocking()
            .toArray())
    }
    
    func testItCanSetThePreviousTrack() {
        stub(soap(call: TransportTarget.previous), soapXml(""))
        
        XCTAssertNoThrow(try transportRepository
            .setPreviousTrack(for: firstRoom())
            .toBlocking()
            .toArray())
    }
    
    func testItCanPlayTheActiveGroupTrack() {
        
        stub(soap(call: TransportTarget.play), soapXml(""))
        
        XCTAssertNoThrow(try transportRepository
            .setPlay(group: secondGroup())
            .toBlocking()
            .toArray())
    }
    
    func testItCanPauseTheActiveGroupTrack() {
        
        stub(soap(call: TransportTarget.pause), soapXml(""))
        
        XCTAssertNoThrow(try transportRepository
            .setPause(group: secondGroup())
            .toBlocking()
            .toArray())
    }
    
    func testItCanStopTheActiveGroupTrack() {
        
        stub(soap(call: TransportTarget.stop), soapXml(""))
        
        XCTAssertNoThrow(try transportRepository
            .setStop(group: secondGroup())
            .toBlocking()
            .toArray())
    }
}

private extension TransportRepositoryTest {
    
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
        return "<Track>1</Track><TrackDuration>0:00:00</TrackDuration><TrackMetaData>&lt;DIDL-Lite xmlns:dc=&quot;http://purl.org/dc/elements/1.1/&quot; xmlns:upnp=&quot;urn:schemas-upnp-org:metadata-1-0/upnp/&quot; xmlns:r=&quot;urn:schemas-rinconnetworks-com:metadata-1-0/&quot; xmlns=&quot;urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/&quot;&gt;&lt;item id=&quot;-1&quot; parentID=&quot;-1&quot; restricted=&quot;true&quot;&gt;&lt;res protocolInfo=&quot;x-rincon-mp3radio:*:*:*&quot;&gt;x-rincon-mp3radio://http://20863.live.streamtheworld.com:80/RADIO538.mp3?tdtok=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6ImZTeXA4In0.eyJpc3MiOiJ0aXNydiIsInN1YiI6IjIxMDY0IiwiaWF0IjoxNTIyNDQzMDQ5LCJ0ZC1yZWciOmZhbHNlfQ.kvTa2wxGb7-Rs7TjFjeRmPlzrkMnZGwDyBdyrru0Wbs&lt;/res&gt;&lt;r:streamContent&gt;DUA LIPA - IDGAF&lt;/r:streamContent&gt;&lt;dc:title&gt;RADIO538.mp3?tdtok=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6ImZTeXA4In0.eyJpc3MiOiJ0aXNydiIsInN1YiI6IjIxMDY0IiwiaWF0IjoxNTIyNDQzMDQ5LCJ0ZC1yZWciOmZhbHNlfQ.kvTa2wxGb7-Rs7TjFjeRmPlzrkMnZGwDyBdyrru0Wbs&lt;/dc:title&gt;&lt;upnp:class&gt;object.item&lt;/upnp:class&gt;&lt;/item&gt;&lt;/DIDL-Lite&gt;</TrackMetaData><TrackURI>x-rincon-mp3radio://http://20863.live.streamtheworld.com:80/RADIO538.mp3?tdtok=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6ImZTeXA4In0.eyJpc3MiOiJ0aXNydiIsInN1YiI6IjIxMDY0IiwiaWF0IjoxNTIyNDQzMDQ5LCJ0ZC1yZWciOmZhbHNlfQ.kvTa2wxGb7-Rs7TjFjeRmPlzrkMnZGwDyBdyrru0Wbs</TrackURI><RelTime>0:01:54</RelTime><AbsTime>NOT_IMPLEMENTED</AbsTime><RelCount>2147483647</RelCount><AbsCount>2147483647</AbsCount>"
    }
    
    func getLibraryMediaInfoResponse() -> String {
        return "<NrTracks>1</NrTracks><MediaDuration>NOT_IMPLEMENTED</MediaDuration><CurrentURI>x-rincon-queue:RINCON_000E58B4AE9601400#0</CurrentURI><CurrentURIMetaData></CurrentURIMetaData><NextURI></NextURI><NextURIMetaData></NextURIMetaData><PlayMedium>NETWORK</PlayMedium><RecordMedium>NOT_IMPLEMENTED</RecordMedium><WriteStatus>NOT_IMPLEMENTED</WriteStatus>"
    }
    
    func getLibraryPositionInfoResponse() -> String {
        return "<Track>1</Track><TrackDuration>0:00:45</TrackDuration><TrackMetaData>&lt;DIDL-Lite xmlns:dc=&quot;http://purl.org/dc/elements/1.1/&quot; xmlns:upnp=&quot;urn:schemas-upnp-org:metadata-1-0/upnp/&quot; xmlns:r=&quot;urn:schemas-rinconnetworks-com:metadata-1-0/&quot; xmlns=&quot;urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/&quot;&gt;&lt;item id=&quot;-1&quot; parentID=&quot;-1&quot; restricted=&quot;true&quot;&gt;&lt;res protocolInfo=&quot;x-file-cifs:*:audio/mpeg:*&quot; duration=&quot;0:00:45&quot;&gt;x-file-cifs://Stefan-MacBook/Music/iTunes/iTunes%20Media/Music/Sample%20Audio.mp3&lt;/res&gt;&lt;r:streamContent&gt;&lt;/r:streamContent&gt;&lt;dc:title&gt;Perfect&lt;/dc:title&gt;&lt;upnp:class&gt;object.item.audioItem.musicTrack&lt;/upnp:class&gt;&lt;dc:creator&gt;Ed Sheeran&lt;/dc:creator&gt;&lt;upnp:album&gt;Divide&lt;/upnp:album&gt;&lt;r:albumArtist&gt;Sample&lt;/r:albumArtist&gt;&lt;/item&gt;&lt;/DIDL-Lite&gt;</TrackMetaData><TrackURI>x-file-cifs://Stefan-MacBook/Music/iTunes/iTunes%20Media/Music/Sample%20Audio.mp3</TrackURI><RelTime>0:00:38</RelTime><AbsTime>NOT_IMPLEMENTED</AbsTime><RelCount>2147483647</RelCount><AbsCount>2147483647</AbsCount>"
    }
    
}
