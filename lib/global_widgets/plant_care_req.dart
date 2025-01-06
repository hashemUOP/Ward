import 'package:flutter/material.dart';

class PlantCareReq extends StatelessWidget {
  final Widget reqIcon;
  final String reqText;
  final String reqData;
  final Color containerColor;
  final Color rowColor;
  const PlantCareReq(
      {super.key,
      required this.reqIcon,
      required this.reqText,
      required this.reqData,
      required this.containerColor,
      required this.rowColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: rowColor,
            border: Border(
              top: BorderSide(
                color: Colors.grey.shade200, //change only top border color
              ),
              right: BorderSide.none,
              bottom: BorderSide.none,
              left: BorderSide.none,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 10, top: 15, bottom: 15),
                    child: Container(
                        decoration: BoxDecoration(
                            color: containerColor,
                            borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.all(2),
                        child: reqIcon),
                  ),
                  Text(
                    reqText,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text(reqData),
              )
            ],
          ),
        )
      ],
    );
  }
}
