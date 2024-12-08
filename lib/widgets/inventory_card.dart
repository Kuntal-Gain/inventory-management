import 'package:flutter/material.dart';
import 'package:flutter_datetime_format/flutter_datetime_format.dart' as fd;

Widget inventoryCard({
  required IconData icon,
  required String label,
  required double gainValue,
  required num value,
  required bool isMoney,
}) {
  return Container(
    height: 200,
    width: 200,
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Color(0xffc2c2c2),
      ),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 2),
          color: Colors.grey.shade200,
          spreadRadius: 2,
          blurRadius: 2,
        )
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.red.shade50,
              child: Icon(
                icon,
                color: Colors.orange,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xffd9d9d9),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${isMoney ? "\$" : ""} ${getValue(value)}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
            Container(
              width: 70,
              height: 30,
              decoration: BoxDecoration(
                color: gainValue >= 0
                    ? const Color.fromARGB(255, 186, 255, 188)
                    : const Color.fromARGB(255, 255, 180, 174),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Icon(
                    gainValue >= 0
                        ? Icons.arrow_drop_up_outlined
                        : Icons.arrow_drop_down_outlined,
                    color: gainValue >= 0 ? Colors.green : Colors.red,
                    size: 30,
                  ),
                  Text(
                    "${gainValue >= 0 ? "+" : "-"}${gainValue.abs()}",
                    style: TextStyle(
                      color: gainValue >= 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w900,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            Text(
              'Update : ${fd.FLDateTime.formatWithNames(DateTime.now(), 'DD-MM-YYYY')}',
              style: TextStyle(
                color: Color(0xffc2c2c2),
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        )
      ],
    ),
  );
}

String getValue(num val) {
  String value = val.abs().toString();

  if (val >= 1000 && val <= 99999) {
    value = "${(val / 1000).toStringAsFixed(1)}K";
  } else if (val >= 100000) {
    value = "${(val / 100000).toStringAsFixed(1)}L";
  } else {
    value = value;
  }

  return value;
}
