import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toopgames_client/util/extension_funs.dart';
import 'package:toopgames_client/view/widgets/texts.dart';

class AppImagePicker extends StatefulWidget {
  final String? initImageUrl;
  final ValueNotifier<XFile?>? imageFile;
  final VoidCallback? onDelete;

  const AppImagePicker({Key? key, this.imageFile, this.initImageUrl, this.onDelete}) : super(key: key);

  @override
  State<AppImagePicker> createState() => _AppImagePickerState();
}

class _AppImagePickerState extends State<AppImagePicker> {
  // XFile? imageFile;
  Uint8List? imageBytes;
  late String? initImageUrl = widget.initImageUrl;

  pickImage() async {
    widget.imageFile?.value = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 92, maxWidth: 800, maxHeight: 800);
    imageBytes = await widget.imageFile?.value?.readAsBytes();
    if (widget.imageFile?.value != null) {
      if ((imageBytes?.length ?? 0) > 2048 * 1024) {
        widget.imageFile?.value = null;
        imageBytes = null;
        context.showSnackBar("لطفا تصویری با حجم کمتر از 2 مگابایت انتخاب کنید.");
      } else {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(78),
          child: Stack(
            children: [
              if (widget.imageFile?.value != null)
                SizedBox(
                  width: 78,
                  height: 78,
                  child: Image.memory(
                    imageBytes!,
                    width: 78,
                    height: 78,
                    fit: BoxFit.cover,
                  ),
                )
              else if (initImageUrl?.isNotEmpty ?? false)
                SizedBox(
                  width: 78,
                  height: 78,
                  child: Image.network(
                    widget.initImageUrl!,
                    width: 78,
                    height: 78,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(
                width: 78,
                height: 78,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (widget.imageFile?.value != null || (initImageUrl?.isNotEmpty ?? false)) {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (_) => CupertinoActionSheet(
                                  actions: [
                                    CupertinoActionSheetAction(
                                        onPressed: () {
                                          pickImage();
                                          Navigator.pop(context);
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            AppText("انتخاب تصویر جدید"),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(Feather.camera),
                                            ),
                                          ],
                                        )),
                                    CupertinoActionSheetAction(
                                        onPressed: () {
                                          setState(() {
                                            widget.imageFile?.value = null;
                                            initImageUrl = null;
                                            widget.onDelete?.call();
                                          });
                                          Navigator.pop(context);
                                        },
                                        isDestructiveAction: true,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            AppText("حذف تصویر فعلی"),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(Feather.camera_off),
                                            ),
                                          ],
                                        )),
                                  ],
                                ));
                      } else {
                        pickImage();
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
