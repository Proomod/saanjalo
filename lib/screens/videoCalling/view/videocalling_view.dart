import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final Map<String, dynamic> configuration = {
  // ignore: always_specify_types
  'iceServers': [
    // ignore: always_specify_types
    {
      'url': [
        'stun:stun1.l.google.com:19302',
        'stun:stun2.l.google.com:19302',
      ]
    }
  ]
};

final loopbackConstraints = <String, dynamic>{
  'mandatory': {},
  'optional': [
    {'DtlsSrtpKeyAgreement': true},
  ],
};

class VideoCalling extends StatefulWidget {
  const VideoCalling({Key? key}) : super(key: key);

  @override
  _VideoCallingState createState() => _VideoCallingState();
}

class _VideoCallingState extends State<VideoCalling> {
  MediaStream? _localStream;

  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _inCalling = false;

  bool _isOffer = false;
  // final bool _isTorchOn = false;
  MediaRecorder? _mediaRecorder;
  // ignore: use_late_for_private_fields_and_variables
  RTCPeerConnection? _peerConnection;

  bool get _isRec => _mediaRecorder != null;
  List<MediaDeviceInfo>? _mediaDeviceList;

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    initRenderers();
  }

  Future<void> initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  @override
  void deactivate() {
    super.deactivate();
    // ignore: always_put_control_body_on_new_line
    if (_inCalling) _hangUp();
    _remoteRenderer.dispose();
    _localRenderer.dispose();
  }

  Future<void> _stop() async {
    try {
      await _localStream?.dispose();
      _localStream = null;
      _localRenderer.srcObject = null;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _hangUp() async {
    await _stop();
    setState(() {
      _inCalling = false;
    });
  }

  Future<void> _makeCall() async {
    print(_inCalling);

    // ignore: always_put_control_body_on_new_line
    if (_peerConnection != null) return;

    try {
      await _getUserMedia();

      _peerConnection =
          await createPeerConnection(configuration, loopbackConstraints);
      print(_peerConnection!.getConfiguration);
      await _peerConnection!.addStream(_localStream!);
      // final bool _remoteDescription =
      // await _peerConnection!.getRemoteDescription() == null;

      final DocumentReference<Map<String, dynamic>> roomRef =
          await _createOffer();
      //get answer from signallingSertver
      roomRef
          .snapshots()
          .listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
        final Map<String, dynamic> data = snapshot.data()!;
        if (data['answer'] != null) {
          final String sdp = data['answer']['sdp'] as String;
          final String type = data['answer']['type'] as String;
          _setRemoteDescription(sdp, type);
        }
      });

      _peerConnection!.onIceCandidate = (RTCIceCandidate event) => {
            if (event.candidate!.isNotEmpty)
              {
                print(json.encode({
                  'candidate': event.candidate,
                  'sdpMid': event.sdpMid,
                  'sdpMlineIndex': event.sdpMlineIndex
                }))
              }
          };

      _peerConnection!.onIceConnectionState =
          (RTCIceConnectionState event) => print(event);

      _peerConnection?.onAddStream =
          (MediaStream stream) => _remoteRenderer.srcObject = stream;
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentReference<Map<String, dynamic>>> _createOffer() async {
    final offerSdpConstraints = <String, dynamic>{
      // ignore: always_specify_types
      'mandatory': {
        'OfferToReceiveAudio': true,
        'OfferToReceiveVideo': true,
      },
      'optional': [],
    };

    final RTCSessionDescription description =
        await _peerConnection!.createOffer(offerSdpConstraints);
    //put that offer in peer connectionState
    await _peerConnection!.setLocalDescription(description);

    // TO:DO send to server which will be signalling server

    final Map<String, dynamic> roomWithOffer = {
      'offer': {
        'type': description.type,
        'sdp': description.sdp,
      }
    };
    final DocumentReference<Map<String, dynamic>> roomRef =
        await _fireStore.collection('IceRooms').add(roomWithOffer);
    print('the room created is ${roomRef.id}');
    return roomRef;
  }

//after receiver signal from our serverr we can create rtcSessions with a offer

  Future<void> _addCandidate(
      String candidate, String sdpMid, int sdpMlineIndex) async {
    //create a iceCandidate and add ito to LocalDescription
    final RTCIceCandidate icecandidate =
        RTCIceCandidate(candidate, sdpMid, sdpMlineIndex);
    await _peerConnection!.addCandidate(icecandidate);
  }

  Future<void> collectIceCandidates(
      DocumentReference roomRef, Map<String, dynamic> candidate) async {
    final candidateCollection = roomRef.collection('PRAMOD');
    await candidateCollection.add(candidate);

    roomRef.collection('BHUSAL').snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) async {
        if (change.type == DocumentChangeType.added) {
          final Map<String, dynamic> data = change.doc.data()!;
          final candidate = await _addCandidate(data['candidate'] as String,
              data['sdpMid'] as String, data['sdpMlineIndex'] as int);
        }
      });
    });
  }

  Future<void> _getUserMedia() async {
    //define media constraints
    final Map<String, dynamic> mediaConstraints = <String, dynamic>{
      'audio': true,
      // ignore: always_specify_types
      'video': {
        // ignore: always_specify_types
        'mandatory': {
          'minWidth':
              '1280', // Provide your own width, height and frame rate here
          'minHeight': '720',
        },
        'facingMode': 'user',
        // ignore: always_specify_types
        'optional': [],
      }
    };
    try {
      final MediaStream stream =
          await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _mediaDeviceList = await navigator.mediaDevices.enumerateDevices();
      _localStream = stream;
      _localRenderer.srcObject = _localStream;
    } catch (e) {
      print(e.toString());
    }

    // ignore: always_put_control_body_on_new_line
    if (!mounted) return;
    setState(() {
      _inCalling = true;
    });
  }

  Future<void> _setRemoteDescription(String sdp, String type) async {
    //server bata aako answer lliyera remote session create garne
    final remoteDesc =
        RTCSessionDescription(sdp, _isOffer ? 'answer' : 'offer');
    await _peerConnection!.setRemoteDescription(remoteDesc);
  }

  Future<void> _joinCall(String roomId) async {
    final DocumentReference<Map<String, dynamic>> roomRef =
        _fireStore.collection('IceRooms').doc(roomId);
    final DocumentSnapshot<Map<String, dynamic>> roomSnapShot =
        await roomRef.get();
    if (roomSnapShot.exists) {
      if (_peerConnection != null) return;
      _peerConnection = await createPeerConnection(configuration);
      final offer = roomSnapShot.data()!['offer'];

      await _setRemoteDescription(
          offer['sdp'] as String, offer['type'] as String);
      await _createAnswer(roomRef);
    }
  }

  Future<void> _createAnswer(DocumentReference roomRef) async {
    final RTCSessionDescription description =
        await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(description);

    final Map<String, dynamic> roomWithAnswer = {
      'answer': {
        'type': description.type,
        'sdp': description.sdp,
      }
    };
    await roomRef.update(roomWithAnswer);

    //TO:DO send to server
  }

  Future<void> _toggleCamera() async {
    if (_localStream == null) throw Exception('Stream is not initialized');

    final MediaStreamTrack videoTrack = _localStream!
        .getVideoTracks()
        .firstWhere((track) => track.kind == 'video');

    await Helper.switchCamera(videoTrack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('camera'),
        ),
        body: OrientationBuilder(
          builder: (BuildContext context, orientation) {
            return Center(
              child: Stack(children: <Widget>[
                // Positioned(
                // top: 0,
                // right: 0,
                // height: 500,
                // width: 500,
                // child: Container(
                // decoration: const BoxDecoration(color: Colors.blue),
                // child: RTCVideoView(_localRenderer),
                // )),
                SafeArea(
                    child: TextField(
                  onSubmitted: (String value) => _joinCall(value),
                )),
                Container(
                  margin: const EdgeInsets.all(0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(color: Colors.black),
                  child: RTCVideoView(
                    _localRenderer,
                    mirror: true,
                  ),
                ),
              ]),
            );
          },
        ),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          FloatingActionButton(
            onPressed: _toggleCamera,
            child: const Icon(Icons.camera),
          ),
          const SizedBox(
            width: 20,
          ),
          FloatingActionButton(
              foregroundColor: _inCalling ? Colors.red : Colors.green,
              onPressed: _inCalling ? _hangUp : _makeCall,
              tooltip: _inCalling ? 'Hangup' : 'Call',
              child: Icon(
                _inCalling ? Icons.call_end : Icons.phone,
                color: _inCalling ? Colors.red : Colors.white,
              )),
        ]));
  }
}
