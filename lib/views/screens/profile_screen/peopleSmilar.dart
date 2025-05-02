import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class ProfileNetworkWidget extends StatelessWidget {
  const ProfileNetworkWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final circleSize = size.width;
    final centerRadius = circleSize * 0.18;
    final outerCircleRadius = circleSize * 0.45;
    final middleCircleRadius = circleSize * 0.34;
    final innerCircleRadius = circleSize * 0.25;

    // ຄ່າເລີ່ມຕົ້ນສໍາລັບຂະຫນາດໂປຣໄຟລ໌
    final baseSmallProfileRadius = circleSize * 0.06;
    final baseMediumProfileRadius = circleSize * 0.08;

    final apiData = [
      {
        'image':
            'https://static.vecteezy.com/system/resources/thumbnails/035/041/137/small_2x/ai-generated-ai-generative-close-up-of-a-cat-photo.jpg',
        'number': 100,
      },
      {
        'image': 'https://ichef.bbci.co.uk/images/ic/480xn/p0jkdrqs.jpg.webp',
        'number': 60
      },
      {
        'image':
            'https://as1.ftcdn.net/v2/jpg/05/67/05/74/1000_F_567057488_WxhGgAJAWpA8KAzTnYxQZTXS9b9Hr1zm.jpg',
        'number': 40
      },
      {
        'image':
            'https://www.boredpanda.com/blog/wp-content/uploads/2022/10/Digital-artist-creates-cute-animals-with-clothes-and-its-hard-not-to-fall-in-love-with-them-74-Pics-634d0d116c435__700.jpg',
        'number': 60
      },
      {
        'image':
            'https://lumenor.ai/cdn-cgi/imagedelivery/F5KOmplEz0rStV2qDKhYag/7c596007-0681-4a8f-7c97-5cad13778800/tn',
        'number': 55
      },
      {
        'image':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGXj94hlS-762IA3h64GFYe_JJzchVfI1vyw&s',
        'number': 60
      },
      {
        'image':
            'https://lumenor.ai/cdn-cgi/imagedelivery/F5KOmplEz0rStV2qDKhYag/7c596007-0681-4a8f-7c97-5cad13778800/tn',
        'number': 10
      },
      {
        'image':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGXj94hlS-762IA3h64GFYe_JJzchVfI1vyw&s',
        'number': 0
      },
    ];

    final maxNumber = apiData.map((data) => data['number'] as int).reduce(max);

    final basePositions = [
      {
        'left': circleSize * 0.5 - outerCircleRadius * 0.65,
        'top': circleSize * 0.5 - outerCircleRadius * 0.55,
        'baseRadius': baseMediumProfileRadius,
      },
      {
        'left': circleSize * 0.5,
        'top': circleSize * 0.5 - outerCircleRadius * 0.7,
        'baseRadius': baseMediumProfileRadius,
      },
      {
        'left': circleSize * 0.5 + outerCircleRadius * 0.6,
        'top': circleSize * 0.5 - outerCircleRadius * 0.4,
        'baseRadius': baseMediumProfileRadius,
      },
      {
        'left': circleSize * 0.5 + outerCircleRadius * 0.5,
        'top': circleSize * 0.5 + outerCircleRadius * 0.45,
        'baseRadius': baseMediumProfileRadius,
      },
      {
        'left': circleSize * 0.5,
        'top': circleSize * 0.5 + outerCircleRadius * 0.65,
        'baseRadius': baseMediumProfileRadius,
      },
      {
        'left': circleSize * 0.5 - outerCircleRadius * 0.55,
        'top': circleSize * 0.5 + outerCircleRadius * 0.35,
        'baseRadius': baseSmallProfileRadius,
      },
      {
        'left': circleSize * 0.5,
        'top': circleSize * 0.5 + innerCircleRadius * 1.0,
        'baseRadius': baseSmallProfileRadius,
      },
      {
        'left': circleSize * 0.5 - innerCircleRadius * 0.90,
        'top': circleSize * 0.5 + innerCircleRadius * 0.20,
        'baseRadius': baseSmallProfileRadius,
      },
    ];

    int minLength = min(basePositions.length, apiData.length);

    final positions = List.generate(minLength, (i) {
      final number = apiData[i]['number'] as int;
      final scaleFactor = 1.0 + (number / maxNumber);

      final scaledRadius =
          (basePositions[i]['baseRadius'] as double) * scaleFactor;

      return {
        'left': basePositions[i]['left'] as double,
        'top': basePositions[i]['top'] as double,
        'radius': scaledRadius,
      };
    });

    // คำนวณระยะทางจากจุดศูนย์กลางเพื่อหาวงกลมที่ใกล้ที่สุด
    final center = Offset(circleSize * 0.5, circleSize * 0.5);
    int closestIndex = 0;
    double closestDistance = double.infinity;

    for (var i = 0; i < positions.length; i++) {
      final position = positions[i];
      final circleCenter =
          Offset(position['left'] as double, position['top'] as double);
      final distance = (circleCenter - center).distance;

      if (distance < closestDistance) {
        closestDistance = distance;
        closestIndex = i;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'People similar to you!',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: circleSize,
          height: circleSize,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: CirclesPainter(
                    outerRadius: outerCircleRadius,
                    middleRadius: middleCircleRadius,
                    innerRadius: innerCircleRadius,
                  ),
                ),
              ),

              // สร้างวงกลมโปรไฟล์จากข้อมูล API และตำแหน่งที่คำนวณไว้
              for (var i = 0; i < minLength; i++)
                if (apiData[i]['image'] != null &&
                    apiData[i]['image']!.toString() != '')
                  _buildProfileCircle(
                    context,
                    positions[i]['left'] as double,
                    positions[i]['top'] as double,
                    positions[i]['radius'] as double,
                    apiData[i]['image'] as String,
                    number: apiData[i]['number'] as int,
                    isClosest: i == closestIndex,
                  ),

              Positioned(
                left: circleSize * 0.5 - 100,
                top: circleSize * 0.5 + outerCircleRadius * 0.5,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[800],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                  ),
                ),
              ),

              // profile Center
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: centerRadius * 3 + 20,
                      height: centerRadius * 3 + 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.amber.withOpacity(0.10),
                            Colors.amber.withOpacity(0.10),
                          ],
                        ),
                      ),
                    ),

                    // in
                    Container(
                      width: centerRadius * 2 + 8,
                      height: centerRadius * 2 + 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber.withOpacity(0.5),
                      ),
                    ),

                    // ขอบสีเหลืองอำพัน
                    Container(
                      width: centerRadius * 2,
                      height: centerRadius * 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.amber, width: 4),
                      ),
                    ),

                    Container(
                      width: centerRadius * 2 - 8,
                      height: centerRadius * 2 - 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              'https://imagef2.promeai.pro/process/do/6174ceea7d612c45ebeccc1026e66521.webp?sourceUrl=/g/p/gallery/publish/2023/11/13/0c3b1d24022945619b1fdfae8bfadc4f.png&x-oss-process=image/resize,w_500,h_500/format,webp&sign=baea85498a968ce65aab1c4c3b5c09a4'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCircle(BuildContext context, double left, double top,
      double radius, String imagePath,
      {int? number, bool isClosest = false}) {
    // ปรับขนาดของวงกลมตามค่า number
    final scaleFactor = number != null && number > 0 ? 1 + (number / 100) : 1.0;
    final containerSize = radius * 0.8 * scaleFactor;

    return Positioned(
      left: left - containerSize / 2,
      top: top - containerSize / 2,
      child: Stack(
        children: [
          // แสดง Container ตามเงื่อนไข number > 50
          if (number != null && number > 50)
            Container(
              width: containerSize,
              height: containerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: imagePath.isNotEmpty
                    ? DecorationImage(
                        image: CachedNetworkImageProvider(imagePath),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: imagePath.isEmpty ? Colors.grey[300] : null,
                // border: isClosest
                //     ? Border.all(color: Colors.amber, width: 3)
                //     : null,
              ),
            )
          else
            Container(
              width: containerSize,
              height: containerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: null,
                color: imagePath.isEmpty ? Colors.grey[300] : null,
                // border: isClosest
                //     ? Border.all(color: Colors.amber, width: 3)
                //     : null,
              ),
            ),
        ],
      ),
    );
  }
}

class CirclesPainter extends CustomPainter {
  final double outerRadius;
  final double middleRadius;
  final double innerRadius;

  CirclesPainter({
    required this.outerRadius,
    required this.middleRadius,
    required this.innerRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final dashPaint = Paint()
      ..color = Colors.amber.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    _drawDashedCircle(canvas, center, outerRadius, dashPaint);
    _drawDashedCircle(canvas, center, middleRadius, dashPaint);
    _drawDashedCircle(canvas, center, innerRadius, dashPaint);
  }

  void _drawDashedCircle(
      Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const dashSize = 8.0;
    const dashSpace = 8.0;
    double startAngle = 0;

    while (startAngle < 360) {
      path.addArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle * (pi / 180),
        dashSize * (pi / 180),
      );
      startAngle += dashSize + dashSpace;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

