import 'package:flutter/material.dart';

import '../../stringee_flutter_plugin.dart';

class StringeeVideoTrack {
  String _id;
  String _localId;
  StringeeRoomUser _publisher;
  bool _audioEnable;
  bool _videoEnable;
  bool _isScreenCapture;
  bool _isLocal;
  StringeeClient _client;

  String get id => _id;

  String get localId => _localId;

  StringeeRoomUser get publisher => _publisher;

  bool get audioEnable => _audioEnable;

  bool get videoEnable => _videoEnable;

  bool get isScreenCapture => _isScreenCapture;

  bool get isLocal => _isLocal;

  @override
  String toString() {
    return '{id: $_id, publisher: $_publisher, audioEnable: $_audioEnable, videoEnable: $_videoEnable, isScreenCapture: $_isScreenCapture, isLocal: $_isLocal}';
  }

  StringeeVideoTrack(
    StringeeClient client,
    Map<dynamic, dynamic> info,
  ) {
    this._client = client;
    this._id = info['id'];
    this._audioEnable = info['audio'];
    this._videoEnable = info['video'];
    this._isScreenCapture = info['screen'];
    this._isLocal = info['isLocal'];
    this._publisher = StringeeRoomUser(info['publisher']);
  }

  StringeeVideoTrack.local(
    StringeeClient client,
    Map<dynamic, dynamic> info,
  ) {
    this._client = client;
    this._localId = info['localId'];
    this._audioEnable = info['audio'];
    this._videoEnable = info['video'];
    this._isScreenCapture = info['screen'];
    this._isLocal = info['isLocal'];
    this._publisher = StringeeRoomUser(info['publisher']);
  }

  /// Mute
  Future<Map<dynamic, dynamic>> mute(bool mute) async {
    final params = {
      'trackId': _id,
      'uuid': _client.uuid,
      'mute': mute,
    };
    return await StringeeClient.methodChannel
        .invokeMethod('track.mute', params);
  }

  /// Enable video
  Future<Map<dynamic, dynamic>> enableVideo(bool enable) async {
    final params = {
      'trackId': _id,
      'uuid': _client.uuid,
      'enable': enable,
    };
    return await StringeeClient.methodChannel
        .invokeMethod('track.enableVideo', params);
  }

  /// Switch camera
  Future<Map<dynamic, dynamic>> switchCamera({int cameraId}) async {
    final params = {
      'trackId': _id,
      'uuid': _client.uuid,
      if (cameraId != null) 'cameraId': cameraId,
    };
    return await StringeeClient.methodChannel
        .invokeMethod('track.switchCamera', params);
  }

  /// Attach view
  StringeeVideoView attach({
    Key key,
    Color color,
    bool isOverlay,
    bool isMirror,
    double height,
    double width,
    EdgeInsetsGeometry margin,
    AlignmentGeometry alignment,
    EdgeInsetsGeometry padding,
    Widget child,
    ScalingType scalingType,
  }) {
    StringeeVideoView videoView = StringeeVideoView.forTrack(
      _id,
      color: color,
      height: height,
      isOverlay: isOverlay,
      isMirror: isMirror,
      width: width,
      margin: margin,
      padding: padding,
      alignment: alignment,
      child: child,
      scalingType: scalingType,
    );
    return videoView;
  }

  /// Close track
  Future<Map<dynamic, dynamic>> close() async {
    final params = {
      'trackId': _id,
      'uuid': _client.uuid,
    };
    return await StringeeClient.methodChannel
        .invokeMethod('track.close', params);
  }
}
