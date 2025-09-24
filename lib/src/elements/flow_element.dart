// ignore_for_file: avoid_positional_boolean_parameters, avoid_dynamic_calls
// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes
// ignore_for_file: use_setters_to_change_properties

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flow_chart/flutter_flow_chart.dart';
import 'package:flutter_flow_chart/src/elements/connection_params.dart';
import 'package:uuid/uuid.dart';

/// Kind of element
enum ElementKind {
  ///
  rectangle,

  ///
  diamond,

  ///
  storage,

  ///
  oval,

  ///
  parallelogram,

  ///
  hexagon,

  ///
  image,

  ///
  curvedRectangle,
}

/// Text position relative to the element
enum TextPosition {
  ///
  center,

  ///
  below,
}

/// Status indicator for the element
enum ElementStatus {
  ///
  none,

  ///
  success,

  ///
  error,

  ///
  warning,

  ///
  info,
}

/// Handler supported by elements
enum Handler {
  ///
  topCenter,

  ///
  bottomCenter,

  ///
  rightCenter,

  ///
  leftCenter;

  /// Convert to [Alignment]
  Alignment toAlignment() {
    switch (this) {
      case Handler.topCenter:
        return Alignment.topCenter;
      case Handler.bottomCenter:
        return Alignment.bottomCenter;
      case Handler.rightCenter:
        return Alignment.centerRight;
      case Handler.leftCenter:
        return Alignment.centerLeft;
    }
  }
}

/// Class to store [FlowElement]s and notify its changes
class FlowElement extends ChangeNotifier {
  ///
  FlowElement({
    Offset position = Offset.zero,
    this.size = Size.zero,
    this.text = '',
    this.title = '',
    this.subtitle = '',
    this.textColor = Colors.black,
    this.titleColor = Colors.black,
    this.subtitleColor = Colors.grey,
    this.fontFamily,
    this.textSize = 24,
    this.titleSize = 16,
    this.subtitleSize = 12,
    this.textIsBold = false,
    this.titleIsBold = true,
    this.subtitleIsBold = false,
    this.textAlign = TextAlign.center,
    this.titleAlign = TextAlign.center,
    this.subtitleAlign = TextAlign.center,
    this.textPosition = TextPosition.center,
    this.kind = ElementKind.rectangle,
    this.handlers = const [
      Handler.topCenter,
      Handler.bottomCenter,
      Handler.rightCenter,
      Handler.leftCenter,
    ],
    this.handlerSize = 15.0,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.blue,
    this.borderThickness = 3,
    this.elevation = 4,
    this.data,
    this.imageProvider,
    this.deleteIconProvider,
    this.isDraggable = true,
    this.isResizable = false,
    this.isConnectable = true,
    this.isDeletable = true,
    this.status = ElementStatus.none,
    this.statusIconProvider,
    List<ConnectionParams>? next,
  })  : next = next ?? [],
        id = const Uuid().v4(),
        isEditingText = false,
        // fixing offset issue under extreme scaling
        position = position -
            Offset(
              size.width / 2 + handlerSize / 2,
              size.height / 2 + handlerSize / 2,
            );

  ///
  factory FlowElement.fromMap(Map<String, dynamic> map) {
    final e = FlowElement(
      size: Size(
        (map['size.width'] as num).toDouble(),
        (map['size.height'] as num).toDouble(),
      ),
      text: map['text'] as String,
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      textColor: Color(map['textColor'] as int),
      titleColor: map['titleColor'] != null ? Color(map['titleColor'] as int) : Colors.black,
      subtitleColor: map['subtitleColor'] != null ? Color(map['subtitleColor'] as int) : Colors.grey,
      fontFamily: map['fontFamily'] as String?,
      textSize: (map['textSize'] as num).toDouble(),
      titleSize: (map['titleSize'] as num?)?.toDouble() ?? 16.0,
      subtitleSize: (map['subtitleSize'] as num?)?.toDouble() ?? 12.0,
      textIsBold: map['textIsBold'] as bool,
      titleIsBold: map['titleIsBold'] as bool? ?? true,
      subtitleIsBold: map['subtitleIsBold'] as bool? ?? false,
      textAlign: map['textAlign'] != null 
          ? TextAlign.values[map['textAlign'] as int]
          : TextAlign.center,
      titleAlign: map['titleAlign'] != null 
          ? TextAlign.values[map['titleAlign'] as int]
          : TextAlign.center,
      subtitleAlign: map['subtitleAlign'] != null 
          ? TextAlign.values[map['subtitleAlign'] as int]
          : TextAlign.center,
      textPosition: map['textPosition'] != null 
          ? TextPosition.values[map['textPosition'] as int]
          : TextPosition.center,
      kind: ElementKind.values[map['kind'] as int],
      handlers: List<Handler>.from(
        (map['handlers'] as List<dynamic>).map<Handler>(
          (x) => Handler.values[x as int],
        ),
      ),
      handlerSize: (map['handlerSize'] as num).toDouble(),
      backgroundColor: Color(map['backgroundColor'] as int),
      borderColor: Color(map['borderColor'] as int),
      borderThickness: (map['borderThickness'] as num).toDouble(),
      elevation: (map['elevation'] as num).toDouble(),
      next: (map['next'] as List).isNotEmpty
          ? List<ConnectionParams>.from(
              (map['next'] as List<dynamic>).map<dynamic>(
                (x) => ConnectionParams.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      isDraggable: map['isDraggable'] as bool? ?? true,
      isResizable: map['isResizable'] as bool? ?? false,
      isConnectable: map['isConnectable'] as bool? ?? true,
      isDeletable: map['isDeletable'] as bool? ?? false,
      status: map['status'] != null 
          ? ElementStatus.values[map['status'] as int]
          : ElementStatus.none,
    )
      ..setId(map['id'] as String)
      ..position = Offset(
        (map['positionDx'] as num).toDouble(),
        (map['positionDy'] as num).toDouble(),
      )
      ..serializedData = map['data'] as String?
      ..imageProvider = map['imageProvider'] != null 
          ? AssetImage(map['imageProvider'] as String)
          : null
      ..deleteIconProvider = map['deleteIconProvider'] != null 
          ? AssetImage(map['deleteIconProvider'] as String)
          : null
      ..statusIconProvider = map['statusIconProvider'] != null 
          ? AssetImage(map['statusIconProvider'] as String)
          : null;
    return e;
  }

  ///
  factory FlowElement.fromJson(String source) =>
      FlowElement.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Unique id set when adding a [FlowElement] with [Dashboard.addElement()]
  String id;

  /// The position of the [FlowElement]
  Offset position;

  /// The size of the [FlowElement]
  Size size;

  /// Element text (legacy - use title instead)
  String text;

  /// Title text (displayed below element when image is present)
  String title;

  /// Subtitle text (displayed below title when image is present)
  String subtitle;

  /// Text color
  Color textColor;

  /// Title text color
  Color titleColor;

  /// Subtitle text color
  Color subtitleColor;

  /// Text font family
  String? fontFamily;

  /// Text size
  double textSize;

  /// Title text size
  double titleSize;

  /// Subtitle text size
  double subtitleSize;

  /// Makes text bold if true
  bool textIsBold;

  /// Makes title bold if true
  bool titleIsBold;

  /// Makes subtitle bold if true
  bool subtitleIsBold;

  /// Text alignment for regular text
  TextAlign textAlign;

  /// Title text alignment
  TextAlign titleAlign;

  /// Subtitle text alignment
  TextAlign subtitleAlign;

  /// Position of text relative to element
  TextPosition textPosition;

  /// Element shape
  ElementKind kind;

  /// Connection handlers
  List<Handler> handlers;

  /// The size of element handlers
  double handlerSize;

  /// Background color of the element
  Color backgroundColor;

  /// Border color of the element
  Color borderColor;

  /// Border thickness of the element
  double borderThickness;

  /// Shadow elevation
  double elevation;

  /// List of connections from this element
  List<ConnectionParams> next;

  /// Whether this element can be dragged around
  bool isDraggable;

  /// Whether this element can be resized
  bool isResizable;

  /// Whether this element can be deleted quickly by clicking on the trash icon
  bool isDeletable;

  /// Whether this element can be connected to others
  bool isConnectable;

  /// Whether the text of this element is being edited with a form field
  bool isEditingText;

  /// Kind-specific data
  final dynamic data;

  /// Kind-specific data to load/save
  String? serializedData;

  /// Image provider for the element (can be AssetImage, NetworkImage, etc.)
  ImageProvider? imageProvider;

  /// Image provider for the delete icon (can be AssetImage, NetworkImage, etc.)
  ImageProvider? deleteIconProvider;

  /// Status indicator for the element
  ElementStatus status;

  /// Image provider for the status icon (can be AssetImage, NetworkImage, etc.)
  ImageProvider? statusIconProvider;

  @override
  String toString() {
    return 'FlowElement{kind: $kind, text: $text}';
  }

  /// Get the handler center of this handler for the given alignment.
  Offset getHandlerPosition(Alignment alignment) {
    // The zero position coordinate is the top-left of this element.
    final ret = Offset(
      position.dx + (size.width * ((alignment.x + 1) / 2)) + handlerSize / 2,
      position.dy + (size.height * ((alignment.y + 1) / 2) + handlerSize / 2),
    );
    return ret;
  }

  /// Sets a new scale
  void setScale(double currentZoom, double factor) {
    size = size / currentZoom * factor;
    handlerSize = handlerSize / currentZoom * factor;
    textSize = textSize / currentZoom * factor;
    for (final element in next) {
      element.arrowParams.setScale(currentZoom, factor);
    }

    notifyListeners();
  }

  /// Used internally to set an unique Uuid to this element
  void setId(String id) => this.id = id;

  /// Set text
  void setText(String text) {
    this.text = text;
    notifyListeners();
  }

  /// Set title
  void setTitle(String title) {
    this.title = title;
    notifyListeners();
  }

  /// Set subtitle
  void setSubtitle(String subtitle) {
    this.subtitle = subtitle;
    notifyListeners();
  }

  /// Set text color
  void setTextColor(Color color) {
    textColor = color;
    notifyListeners();
  }

  /// Set title color
  void setTitleColor(Color color) {
    titleColor = color;
    notifyListeners();
  }

  /// Set subtitle color
  void setSubtitleColor(Color color) {
    subtitleColor = color;
    notifyListeners();
  }

  /// Set text font family
  void setFontFamily(String? fontFamily) {
    this.fontFamily = fontFamily;
    notifyListeners();
  }

  /// Set text size
  void setTextSize(double size) {
    textSize = size;
    notifyListeners();
  }

  /// Set title size
  void setTitleSize(double size) {
    titleSize = size;
    notifyListeners();
  }

  /// Set subtitle size
  void setSubtitleSize(double size) {
    subtitleSize = size;
    notifyListeners();
  }

  /// Set text bold
  void setTextIsBold(bool isBold) {
    textIsBold = isBold;
    notifyListeners();
  }

  /// Set title bold
  void setTitleIsBold(bool isBold) {
    titleIsBold = isBold;
    notifyListeners();
  }

  /// Set subtitle bold
  void setSubtitleIsBold(bool isBold) {
    subtitleIsBold = isBold;
    notifyListeners();
  }

  /// Set text alignment
  void setTextAlign(TextAlign align) {
    textAlign = align;
    notifyListeners();
  }

  /// Set title alignment
  void setTitleAlign(TextAlign align) {
    titleAlign = align;
    notifyListeners();
  }

  /// Set subtitle alignment
  void setSubtitleAlign(TextAlign align) {
    subtitleAlign = align;
    notifyListeners();
  }

  /// Set text position
  void setTextPosition(TextPosition position) {
    textPosition = position;
    notifyListeners();
  }

  /// Set image provider
  void setImageProvider(ImageProvider? provider) {
    imageProvider = provider;
    notifyListeners();
  }

  /// Set background color
  void setBackgroundColor(Color color) {
    backgroundColor = color;
    notifyListeners();
  }

  /// Set border color
  void setBorderColor(Color color) {
    borderColor = color;
    notifyListeners();
  }

  /// Set border thickness
  void setBorderThickness(double thickness) {
    borderThickness = thickness;
    notifyListeners();
  }

  /// Set elevation
  void setElevation(double elevation) {
    this.elevation = elevation;
    notifyListeners();
  }

  /// Set status
  void setStatus(ElementStatus status) {
    this.status = status;
    notifyListeners();
  }

  /// Set status icon provider
  void setStatusIconProvider(ImageProvider? provider) {
    statusIconProvider = provider;
    notifyListeners();
  }

  /// Change element position in the dashboard
  void changePosition(Offset newPosition) {
    position = newPosition;
    notifyListeners();
  }

  /// Change element size
  void changeSize(Size newSize) {
    size = newSize;
    if (size.width < 40) size = Size(40, size.height);
    if (size.height < 40) size = Size(size.width, 40);
    notifyListeners();
  }

  @override
  bool operator ==(covariant FlowElement other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode {
    return position.hashCode ^
        size.hashCode ^
        text.hashCode ^
        title.hashCode ^
        subtitle.hashCode ^
        textColor.hashCode ^
        titleColor.hashCode ^
        subtitleColor.hashCode ^
        fontFamily.hashCode ^
        textSize.hashCode ^
        titleSize.hashCode ^
        subtitleSize.hashCode ^
        textIsBold.hashCode ^
        titleIsBold.hashCode ^
        subtitleIsBold.hashCode ^
        textAlign.hashCode ^
        titleAlign.hashCode ^
        subtitleAlign.hashCode ^
        textPosition.hashCode ^
        id.hashCode ^
        kind.hashCode ^
        handlers.hashCode ^
        handlerSize.hashCode ^
        backgroundColor.hashCode ^
        borderColor.hashCode ^
        borderThickness.hashCode ^
        elevation.hashCode ^
        next.hashCode ^
        isResizable.hashCode ^
        isConnectable.hashCode ^
        isDeletable.hashCode ^
        imageProvider.hashCode ^
        status.hashCode ^
        statusIconProvider.hashCode;
  }

  ///
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'positionDx': position.dx,
      'positionDy': position.dy,
      'size.width': size.width,
      'size.height': size.height,
      'text': text,
      'title': title,
      'subtitle': subtitle,
      'textColor': textColor.value,
      'titleColor': titleColor.value,
      'subtitleColor': subtitleColor.value,
      'fontFamily': fontFamily,
      'textSize': textSize,
      'titleSize': titleSize,
      'subtitleSize': subtitleSize,
      'textIsBold': textIsBold,
      'titleIsBold': titleIsBold,
      'subtitleIsBold': subtitleIsBold,
      'textAlign': textAlign.index,
      'titleAlign': titleAlign.index,
      'subtitleAlign': subtitleAlign.index,
      'textPosition': textPosition.index,
      'id': id,
      'kind': kind.index,
      'handlers': handlers.map((x) => x.index).toList(),
      'handlerSize': handlerSize,
      'backgroundColor': backgroundColor.value,
      'borderColor': borderColor.value,
      'borderThickness': borderThickness,
      'elevation': elevation,
      'data': serializedData,
      'imageProvider': imageProvider is AssetImage ? (imageProvider as AssetImage).assetName : null,
      'deleteIconProvider': deleteIconProvider is AssetImage ? (deleteIconProvider as AssetImage).assetName : null,
      'next': next.map((x) => x.toMap()).toList(),
      'isDraggable': isDraggable,
      'isResizable': isResizable,
      'isConnectable': isConnectable,
      'isDeletable': isDeletable,
      'status': status.index,
      'statusIconProvider': statusIconProvider is AssetImage ? (statusIconProvider as AssetImage).assetName : null,
    };
  }

  ///
  String toJson() => json.encode(toMap());
}
