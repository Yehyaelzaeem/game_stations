import 'package:flutter/material.dart';
import '../models/Constant.dart';
import '../models/cities/cityModle.dart';


class LabeledBottomSheet extends StatefulWidget {
  final List? data;
  final ValueChanged<BottomSheetModel>? onChange;
  final String? label;
  final bool? ontap;
  final double? paddingTop;

  const LabeledBottomSheet(
      {  Key? key,
      this.data,
      this.onChange,
      this.label,
      this.ontap,
      this.paddingTop})
      : super(key: key);

  @override
  _LabeledBottomSheetState createState() => _LabeledBottomSheetState();
}

class _LabeledBottomSheetState extends State<LabeledBottomSheet> {
  String? _title;

  @override
  void initState() {
    super.initState();
    _title = widget.label;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: 10, right: 10, top: widget.paddingTop ?? 20),
      child: InkWell(
        onTap: () {
          if (widget.ontap == null || widget.ontap == true) {
            showModalBottomSheet(
                backgroundColor: Colors.black12,
                context: context,
                builder: (_) {
                  return Container(
                    height: 350,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(10.0),
                          topRight: const Radius.circular(10.0),
                        ),
                        color: Colors.white),
                    child: ListView.builder(
                      itemCount: widget.data!.length,
                      itemBuilder: (_, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: TextButton(
                                child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text(widget.data![index].title ?? "")),
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    _title = widget.data![index].title;
                                    widget.onChange!(widget.data![index]);
                                  });
                                },
                              ),
                            ),
                            Divider(
                              indent: 10.0,
                              endIndent: 10.0,
                            ),
                          ],
                        );
                      },
                    ),
                  );
                });
          } else
           print("object");
        },
        child: Directionality(
          textDirection:Constant.lang == "ar" ? TextDirection.ltr:TextDirection.rtl,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey)),
            padding: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.arrow_drop_down),
                  Text(_title!.length > 25 ? _title!.substring(0, 20) : _title!)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

