/// Model for image-specific metadata from Google Custom Search API
///
/// This contains information about the image result including dimensions,
/// thumbnail, and the page context where the image appears.
class ImageMetadata {
  /// URL of the page containing the image
  final String contextLink;

  /// Image height in pixels
  final int height;

  /// Image width in pixels
  final int width;

  /// Image file size in bytes
  final int byteSize;

  /// URL of the image thumbnail
  final String thumbnailLink;

  /// Thumbnail height in pixels
  final int thumbnailHeight;

  /// Thumbnail width in pixels
  final int thumbnailWidth;

  const ImageMetadata({
    required this.contextLink,
    required this.height,
    required this.width,
    required this.byteSize,
    required this.thumbnailLink,
    required this.thumbnailHeight,
    required this.thumbnailWidth,
  });

  /// Create ImageMetadata from JSON response
  factory ImageMetadata.fromJson(Map<String, dynamic> json) {
    return ImageMetadata(
      contextLink: json['contextLink'] as String? ?? '',
      height: json['height'] as int? ?? 0,
      width: json['width'] as int? ?? 0,
      byteSize: json['byteSize'] as int? ?? 0,
      thumbnailLink: json['thumbnailLink'] as String? ?? '',
      thumbnailHeight: json['thumbnailHeight'] as int? ?? 0,
      thumbnailWidth: json['thumbnailWidth'] as int? ?? 0,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'contextLink': contextLink,
      'height': height,
      'width': width,
      'byteSize': byteSize,
      'thumbnailLink': thumbnailLink,
      'thumbnailHeight': thumbnailHeight,
      'thumbnailWidth': thumbnailWidth,
    };
  }

  /// Create a copy with updated fields
  ImageMetadata copyWith({
    String? contextLink,
    int? height,
    int? width,
    int? byteSize,
    String? thumbnailLink,
    int? thumbnailHeight,
    int? thumbnailWidth,
  }) {
    return ImageMetadata(
      contextLink: contextLink ?? this.contextLink,
      height: height ?? this.height,
      width: width ?? this.width,
      byteSize: byteSize ?? this.byteSize,
      thumbnailLink: thumbnailLink ?? this.thumbnailLink,
      thumbnailHeight: thumbnailHeight ?? this.thumbnailHeight,
      thumbnailWidth: thumbnailWidth ?? this.thumbnailWidth,
    );
  }

  @override
  String toString() {
    return 'ImageMetadata(contextLink: $contextLink, size: ${width}x$height, thumbnailLink: $thumbnailLink)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ImageMetadata &&
        other.contextLink == contextLink &&
        other.height == height &&
        other.width == width &&
        other.byteSize == byteSize &&
        other.thumbnailLink == thumbnailLink &&
        other.thumbnailHeight == thumbnailHeight &&
        other.thumbnailWidth == thumbnailWidth;
  }

  @override
  int get hashCode {
    return Object.hash(
      contextLink,
      height,
      width,
      byteSize,
      thumbnailLink,
      thumbnailHeight,
      thumbnailWidth,
    );
  }
}
