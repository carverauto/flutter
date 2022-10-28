import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../const/sizings.dart';

//Add this CustomPaint widget to the Widget Tree

class ChaseAppWheel extends StatelessWidget {
  const ChaseAppWheel({
    super.key,
    required this.wheels,
  });

  final Map<String, dynamic>? wheels;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(
        kIconSizeLargeConstant,
        (kIconSizeLargeConstant * 1).toDouble(),
      ), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
      painter: RPSCustomPainter(
        wheels: wheels,
      ),
    );
  }
}

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  RPSCustomPainter({
    required this.wheels,
  });

  final Map<String, dynamic>? wheels;

  Color getWheelColor(String wheel) {
    log('Wheel Color:$wheel');
    final String w1ColorHex =
        wheel.isNotEmpty ? wheel.replaceFirst('fill:#', '') : '5CDA3F';
    final Color wheelColor =
        Color(0xFF + int.parse(w1ColorHex.trim(), radix: 16));

    return wheelColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    log(wheels!['W4'].toString());
    final Path path_0 = Path();
    final Color chasisColor = Colors.grey[800]!;
    final Color w1Color = getWheelColor(wheels!['W1'].toString());
    final Color w2Color = getWheelColor(wheels!['W2'].toString());
    final Color w3Color = getWheelColor(wheels!['W3'].toString());
    final Color w4Color = getWheelColor(wheels!['W4'].toString());
    path_0.moveTo(size.width * 0.8296730, size.height * 0.3070724);
    path_0.lineTo(size.width * 0.8694588, size.height * 0.3070724);
    path_0.cubicTo(
      size.width * 0.9066837,
      size.height * 0.3070724,
      size.width * 0.9369667,
      size.height * 0.2767893,
      size.width * 0.9369667,
      size.height * 0.2395644,
    );
    path_0.lineTo(size.width * 0.9369667, size.height * 0.06750797);
    path_0.cubicTo(
      size.width * 0.9369667,
      size.height * 0.03028302,
      size.width * 0.9066837,
      0,
      size.width * 0.8694588,
      0,
    );
    path_0.lineTo(size.width * 0.8296730, 0);
    path_0.cubicTo(
      size.width * 0.7924454,
      0,
      size.width * 0.7621597,
      size.height * 0.03028302,
      size.width * 0.7621597,
      size.height * 0.06750797,
    );
    path_0.lineTo(size.width * 0.7621597, size.height * 0.1294800);
    path_0.lineTo(size.width * 0.5941530, size.height * 0.1294800);
    path_0.cubicTo(
      size.width * 0.5834207,
      size.height * 0.08750241,
      size.width * 0.5452842,
      size.height * 0.05637202,
      size.width * 0.5000080,
      size.height * 0.05637202,
    );
    path_0.cubicTo(
      size.width * 0.4547292,
      size.height * 0.05637202,
      size.width * 0.4165900,
      size.height * 0.08750241,
      size.width * 0.4058577,
      size.height * 0.1294800,
    );
    path_0.lineTo(size.width * 0.2378403, size.height * 0.1294800);
    path_0.lineTo(size.width * 0.2378403, size.height * 0.06750797);
    path_0.cubicTo(
      size.width * 0.2378403,
      size.height * 0.03028302,
      size.width * 0.2075573,
      0,
      size.width * 0.1703377,
      0,
    );
    path_0.lineTo(size.width * 0.1305493, 0);
    path_0.cubicTo(
      size.width * 0.09332164,
      0,
      size.width * 0.06303327,
      size.height * 0.03028302,
      size.width * 0.06303327,
      size.height * 0.06750797,
    );
    path_0.lineTo(size.width * 0.06303327, size.height * 0.2395644);
    path_0.cubicTo(
      size.width * 0.06303327,
      size.height * 0.2767893,
      size.width * 0.09332164,
      size.height * 0.3070724,
      size.width * 0.1305519,
      size.height * 0.3070724,
    );
    path_0.lineTo(size.width * 0.1703377, size.height * 0.3070724);
    path_0.cubicTo(
      size.width * 0.2075573,
      size.height * 0.3070724,
      size.width * 0.2378403,
      size.height * 0.2767893,
      size.width * 0.2378403,
      size.height * 0.2395644,
    );
    path_0.lineTo(size.width * 0.2378403, size.height * 0.1775923);
    path_0.lineTo(size.width * 0.4058577, size.height * 0.1775923);
    path_0.cubicTo(
      size.width * 0.4146227,
      size.height * 0.2118742,
      size.width * 0.4416660,
      size.height * 0.2389148,
      size.width * 0.4759505,
      size.height * 0.2476798,
    );
    path_0.lineTo(size.width * 0.4759505, size.height * 0.6967688);
    path_0.cubicTo(
      size.width * 0.4450153,
      size.height * 0.7069104,
      size.width * 0.4226017,
      size.height * 0.7360413,
      size.width * 0.4226017,
      size.height * 0.7703259,
    );
    path_0.lineTo(size.width * 0.4226017, size.height * 0.8224023);
    path_0.lineTo(size.width * 0.2378403, size.height * 0.8224023);
    path_0.lineTo(size.width * 0.2378403, size.height * 0.7604303);
    path_0.cubicTo(
      size.width * 0.2378403,
      size.height * 0.7232053,
      size.width * 0.2075573,
      size.height * 0.6929223,
      size.width * 0.1703377,
      size.height * 0.6929223,
    );
    path_0.lineTo(size.width * 0.1305493, size.height * 0.6929223);
    path_0.cubicTo(
      size.width * 0.09331897,
      size.height * 0.6929223,
      size.width * 0.06303060,
      size.height * 0.7232053,
      size.width * 0.06303060,
      size.height * 0.7604303,
    );
    path_0.lineTo(size.width * 0.06303060, size.height * 0.9324867);
    path_0.cubicTo(
      size.width * 0.06303060,
      size.height * 0.9697116,
      size.width * 0.09331897,
      size.height * 0.9999947,
      size.width * 0.1305493,
      size.height * 0.9999947,
    );
    path_0.lineTo(size.width * 0.1703350, size.height * 0.9999947);
    path_0.cubicTo(
      size.width * 0.2075546,
      size.height * 0.9999947,
      size.width * 0.2378376,
      size.height * 0.9697116,
      size.width * 0.2378376,
      size.height * 0.9324867,
    );
    path_0.lineTo(size.width * 0.2378376, size.height * 0.8705146);
    path_0.lineTo(size.width * 0.4225991, size.height * 0.8705146);
    path_0.lineTo(size.width * 0.4225991, size.height * 0.9225937);
    path_0.cubicTo(
      size.width * 0.4225991,
      size.height * 0.9652717,
      size.width * 0.4573247,
      size.height * 0.9999920,
      size.width * 0.5000053,
      size.height * 0.9999920,
    );
    path_0.cubicTo(
      size.width * 0.5426806,
      size.height * 0.9999920,
      size.width * 0.5774009,
      size.height * 0.9652717,
      size.width * 0.5774009,
      size.height * 0.9225937,
    );
    path_0.lineTo(size.width * 0.5774009, size.height * 0.8705146);
    path_0.lineTo(size.width * 0.7621570, size.height * 0.8705146);
    path_0.lineTo(size.width * 0.7621570, size.height * 0.9324867);
    path_0.cubicTo(
      size.width * 0.7621570,
      size.height * 0.9697116,
      size.width * 0.7924427,
      size.height * 0.9999947,
      size.width * 0.8296704,
      size.height * 0.9999947,
    );
    path_0.lineTo(size.width * 0.8694561, size.height * 0.9999947);
    path_0.cubicTo(
      size.width * 0.9066810,
      size.height * 0.9999947,
      size.width * 0.9369641,
      size.height * 0.9697116,
      size.width * 0.9369641,
      size.height * 0.9324867,
    );
    path_0.lineTo(size.width * 0.9369641, size.height * 0.7604303);
    path_0.cubicTo(
      size.width * 0.9369641,
      size.height * 0.7232053,
      size.width * 0.9066810,
      size.height * 0.6929223,
      size.width * 0.8694561,
      size.height * 0.6929223,
    );
    path_0.lineTo(size.width * 0.8296704, size.height * 0.6929223);
    path_0.cubicTo(
      size.width * 0.7924427,
      size.height * 0.6929223,
      size.width * 0.7621570,
      size.height * 0.7232053,
      size.width * 0.7621570,
      size.height * 0.7604303,
    );
    path_0.lineTo(size.width * 0.7621570, size.height * 0.8224023);
    path_0.lineTo(size.width * 0.5774009, size.height * 0.8224023);
    path_0.lineTo(size.width * 0.5774009, size.height * 0.7703259);
    path_0.cubicTo(
      size.width * 0.5774009,
      size.height * 0.7360467,
      size.width * 0.5549927,
      size.height * 0.7069184,
      size.width * 0.5240628,
      size.height * 0.6967742,
    );
    path_0.lineTo(size.width * 0.5240628, size.height * 0.2476825);
    path_0.cubicTo(
      size.width * 0.5583447,
      size.height * 0.2389175,
      size.width * 0.5853853,
      size.height * 0.2118742,
      size.width * 0.5941503,
      size.height * 0.1775950,
    );
    path_0.lineTo(size.width * 0.7621570, size.height * 0.1775950);
    path_0.lineTo(size.width * 0.7621570, size.height * 0.2395671);
    path_0.cubicTo(
      size.width * 0.7621597,
      size.height * 0.2767893,
      size.width * 0.7924454,
      size.height * 0.3070724,
      size.width * 0.8296730,
      size.height * 0.3070724,
    );
    path_0.close();
    path_0.moveTo(size.width * 0.1897253, size.height * 0.2395644);
    path_0.cubicTo(
      size.width * 0.1897253,
      size.height * 0.2502566,
      size.width * 0.1810299,
      size.height * 0.2589574,
      size.width * 0.1703377,
      size.height * 0.2589574,
    );
    path_0.lineTo(size.width * 0.1305493, size.height * 0.2589574);
    path_0.cubicTo(
      size.width * 0.1198517,
      size.height * 0.2589574,
      size.width * 0.1111456,
      size.height * 0.2502566,
      size.width * 0.1111456,
      size.height * 0.2395644,
    );
    path_0.lineTo(size.width * 0.1111456, size.height * 0.06750797);
    path_0.cubicTo(
      size.width * 0.1111456,
      size.height * 0.05681575,
      size.width * 0.1198490,
      size.height * 0.04811496,
      size.width * 0.1305493,
      size.height * 0.04811496,
    );
    path_0.lineTo(size.width * 0.1703350, size.height * 0.04811496);
    path_0.cubicTo(
      size.width * 0.1810272,
      size.height * 0.04811496,
      size.width * 0.1897226,
      size.height * 0.05681575,
      size.width * 0.1897226,
      size.height * 0.06750797,
    );
    path_0.lineTo(size.width * 0.1897226, size.height * 0.2395644);
    path_0.close();
    path_0.moveTo(size.width * 0.1897253, size.height * 0.9324920);
    path_0.cubicTo(
      size.width * 0.1897253,
      size.height * 0.9431842,
      size.width * 0.1810299,
      size.height * 0.9518850,
      size.width * 0.1703377,
      size.height * 0.9518850,
    );
    path_0.lineTo(size.width * 0.1305493, size.height * 0.9518850);
    path_0.cubicTo(
      size.width * 0.1198517,
      size.height * 0.9518850,
      size.width * 0.1111456,
      size.height * 0.9431842,
      size.width * 0.1111456,
      size.height * 0.9324920,
    );
    path_0.lineTo(size.width * 0.1111456, size.height * 0.7604356);
    path_0.cubicTo(
      size.width * 0.1111456,
      size.height * 0.7497434,
      size.width * 0.1198490,
      size.height * 0.7410426,
      size.width * 0.1305493,
      size.height * 0.7410426,
    );
    path_0.lineTo(size.width * 0.1703350, size.height * 0.7410426);
    path_0.cubicTo(
      size.width * 0.1810272,
      size.height * 0.7410426,
      size.width * 0.1897226,
      size.height * 0.7497434,
      size.width * 0.1897226,
      size.height * 0.7604356,
    );
    path_0.lineTo(size.width * 0.1897226, size.height * 0.9324920);
    path_0.close();
    path_0.moveTo(size.width * 0.8102747, size.height * 0.7604329);
    path_0.cubicTo(
      size.width * 0.8102747,
      size.height * 0.7497407,
      size.width * 0.8189755,
      size.height * 0.7410399,
      size.width * 0.8296730,
      size.height * 0.7410399,
    );
    path_0.lineTo(size.width * 0.8694588, size.height * 0.7410399);
    path_0.cubicTo(
      size.width * 0.8801510,
      size.height * 0.7410399,
      size.width * 0.8888518,
      size.height * 0.7497407,
      size.width * 0.8888518,
      size.height * 0.7604329,
    );
    path_0.lineTo(size.width * 0.8888518, size.height * 0.9324894);
    path_0.cubicTo(
      size.width * 0.8888518,
      size.height * 0.9431816,
      size.width * 0.8801536,
      size.height * 0.9518824,
      size.width * 0.8694588,
      size.height * 0.9518824,
    );
    path_0.lineTo(size.width * 0.8296730, size.height * 0.9518824);
    path_0.cubicTo(
      size.width * 0.8189781,
      size.height * 0.9518824,
      size.width * 0.8102747,
      size.height * 0.9431816,
      size.width * 0.8102747,
      size.height * 0.9324894,
    );
    path_0.lineTo(size.width * 0.8102747, size.height * 0.7604329);
    path_0.close();
    path_0.moveTo(size.width * 0.5292886, size.height * 0.9225991);
    path_0.cubicTo(
      size.width * 0.5292886,
      size.height * 0.9387470,
      size.width * 0.5161533,
      size.height * 0.9518824,
      size.width * 0.5000080,
      size.height * 0.9518824,
    );
    path_0.lineTo(size.width * 0.5000027, size.height * 0.9518824);
    path_0.cubicTo(
      size.width * 0.4838548,
      size.height * 0.9518824,
      size.width * 0.4707167,
      size.height * 0.9387470,
      size.width * 0.4707167,
      size.height * 0.9225991,
    );
    path_0.lineTo(size.width * 0.4707167, size.height * 0.7703259);
    path_0.cubicTo(
      size.width * 0.4707167,
      size.height * 0.7541780,
      size.width * 0.4838574,
      size.height * 0.7410399,
      size.width * 0.5000080,
      size.height * 0.7410399,
    );
    path_0.cubicTo(
      size.width * 0.5161533,
      size.height * 0.7410399,
      size.width * 0.5292886,
      size.height * 0.7541780,
      size.width * 0.5292886,
      size.height * 0.7703259,
    );
    path_0.lineTo(size.width * 0.5292886, size.height * 0.9225991);
    path_0.close();
    path_0.moveTo(size.width * 0.5017108, size.height * 0.2024998);
    path_0.cubicTo(
      size.width * 0.5011467,
      size.height * 0.2024597,
      size.width * 0.5005827,
      size.height * 0.2024143,
      size.width * 0.5000080,
      size.height * 0.2024143,
    );
    path_0.cubicTo(
      size.width * 0.4994333,
      size.height * 0.2024143,
      size.width * 0.4988693,
      size.height * 0.2024597,
      size.width * 0.4983053,
      size.height * 0.2024998,
    );
    path_0.cubicTo(
      size.width * 0.4720479,
      size.height * 0.2015910,
      size.width * 0.4509548,
      size.height * 0.1800088,
      size.width * 0.4509548,
      size.height * 0.1535375,
    );
    path_0.cubicTo(
      size.width * 0.4509548,
      size.height * 0.1264916,
      size.width * 0.4729594,
      size.height * 0.1044870,
      size.width * 0.5000107,
      size.height * 0.1044870,
    );
    path_0.cubicTo(
      size.width * 0.5270566,
      size.height * 0.1044870,
      size.width * 0.5490586,
      size.height * 0.1264889,
      size.width * 0.5490586,
      size.height * 0.1535375,
    );
    path_0.cubicTo(
      size.width * 0.5490559,
      size.height * 0.1800088,
      size.width * 0.5279628,
      size.height * 0.2015910,
      size.width * 0.5017108,
      size.height * 0.2024998,
    );
    path_0.close();
    path_0.moveTo(size.width * 0.8102747, size.height * 0.06750797);
    path_0.cubicTo(
      size.width * 0.8102747,
      size.height * 0.05681575,
      size.width * 0.8189755,
      size.height * 0.04811496,
      size.width * 0.8296730,
      size.height * 0.04811496,
    );
    path_0.lineTo(size.width * 0.8694588, size.height * 0.04811496);
    path_0.cubicTo(
      size.width * 0.8801510,
      size.height * 0.04811496,
      size.width * 0.8888518,
      size.height * 0.05681575,
      size.width * 0.8888518,
      size.height * 0.06750797,
    );
    path_0.lineTo(size.width * 0.8888518, size.height * 0.2395644);
    path_0.cubicTo(
      size.width * 0.8888518,
      size.height * 0.2502566,
      size.width * 0.8801536,
      size.height * 0.2589574,
      size.width * 0.8694588,
      size.height * 0.2589574,
    );
    path_0.lineTo(size.width * 0.8296730, size.height * 0.2589574);
    path_0.cubicTo(
      size.width * 0.8189781,
      size.height * 0.2589574,
      size.width * 0.8102747,
      size.height * 0.2502566,
      size.width * 0.8102747,
      size.height * 0.2395644,
    );
    path_0.lineTo(size.width * 0.8102747, size.height * 0.06750797);
    path_0.close();

    final Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = chasisColor.withOpacity(1);
    canvas.drawPath(path_0, paint0Fill);

    final Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = w1Color.withOpacity(1);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.1094897,
        size.height * 0.04761808,
        size.width * 0.08528264,
        size.height * 0.2158925,
      ),
      paint1Fill,
    );

    final Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = w2Color.withOpacity(1);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.8056412,
        size.height * 0.04529443,
        size.width * 0.09758301,
        size.height * 0.2186354,
      ),
      paint2Fill,
    );

    final Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.color = w3Color.withOpacity(1);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.1039115,
        size.height * 0.7331185,
        size.width * 0.09695386,
        size.height * 0.2309699,
      ),
      paint3Fill,
    );

    final Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.color = w4Color.withOpacity(1);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.8054461,
        size.height * 0.7330428,
        size.width * 0.09579625,
        size.height * 0.2254425,
      ),
      paint4Fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
