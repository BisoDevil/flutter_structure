import 'dart:io' as io;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';

import '../../index.dart';
import '../utils/constants.dart';

class ImageWidget extends StatefulWidget {
  final String? imagePath;
  final BoxFit fit;
  final BoxShape shape;
  final double? size;
  final double? borderRadius;

  final bool showEdit;
  final ValueChanged<Uint8List>? onImage;
  const ImageWidget(
    this.imagePath, {
    Key? key,
    this.fit = BoxFit.cover,
    this.shape = BoxShape.rectangle,
    this.size,
    this.showEdit = false,
    this.borderRadius = 0,
    this.onImage,
  }) : super(key: key);

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  Uint8List? _imageFile;
  bool hide = true;
  Future<void> _pickImage() async {
    // var file = await ImagePicker().pickImage(source: ImageSource.gallery);
    // if (file != null) {
    //   _imageFile = await file.readAsBytes();
    //   setState(() {});
    //   widget.onImage?.call(await file.readAsBytes());
    // }
  }

  Widget _getImage() {
    if (_imageFile != null) {
      return Image.memory(
        _imageFile!,
        fit: widget.fit,
        height: widget.size,
        width: widget.size,
      );
    }
    if (widget.imagePath == null) {
      return Image.asset(
        Constants.defaultUserImage,
        fit: widget.fit,
        height: widget.size,
        width: widget.size,
      );
    }

    // else
    if (!kIsWeb) {
      if (!widget.imagePath!.startsWith('http') &&
          !widget.imagePath!.startsWith('assets')) {
        return Image.file(
          io.File(widget.imagePath!),
          fit: widget.fit,
          height: widget.size,
          width: widget.size,
        );
      }
    }

    if (widget.imagePath!.startsWith('http') &&
        widget.imagePath!.endsWith('svg')) {
      return SvgPicture.network(
        widget.imagePath!,
        fit: widget.fit,
        height: widget.size,
        width: widget.size,
      );
    } else if (widget.imagePath!.startsWith('http') &&
        !widget.imagePath!.endsWith('svg')) {
      return CachedNetworkImage(
        imageUrl: widget.imagePath!,
        fit: widget.fit,
        height: widget.size,
        width: widget.size,
        progressIndicatorBuilder: (context, url, progress) => Center(
          child: CircularProgressIndicator(
            value: progress.progress,
            strokeWidth: 1,
          ),
        ),
        errorWidget: (context, url, error) => Image.asset(
          Constants.defaultUserImage,
          fit: widget.fit,
          alignment: Alignment.center,
          height: widget.size,
          width: widget.size,
        ),
      );
    } else if (widget.imagePath!.startsWith("assets") &&
        widget.imagePath!.endsWith("svg")) {
      return SvgPicture.asset(
        widget.imagePath!,
        fit: widget.fit,
        height: widget.size,
        width: widget.size,
      );
    } else if (widget.imagePath!.startsWith("assets") &&
        !widget.imagePath!.endsWith("svg")) {
      return Image.asset(
        widget.imagePath!,
        fit: widget.fit,
        height: widget.size,
        width: widget.size,
      );
    } else {
      return Image.asset(
        Constants.defaultUserImage,
        fit: widget.fit,
        height: widget.size,
        width: widget.size,
      );
    }
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (ev) {
          setState(() {
            hide = false;
          });
        },
        onExit: (ev) {
          setState(() {
            hide = true;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            shape: widget.shape,
            borderRadius:
                widget.borderRadius == null || widget.shape == BoxShape.circle
                    ? null
                    : BorderRadius.circular(
                        widget.borderRadius!,
                      ),
          ),
          constraints: BoxConstraints(
            maxWidth: widget.size ?? double.infinity,
            maxHeight: widget.size ?? double.infinity,
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              _getImage(),
              if (widget.showEdit && !hide) ...[
                Container(
                  color: Colors.black87,
                ),
                IconButton(
                  onPressed: _pickImage,
                  icon: Icon(
                    FontAwesomeIcons.penToSquare,
                    color: Get.theme.colorScheme.secondary,
                  ),
                )
              ]
            ],
          ),
        ),
      );
}
