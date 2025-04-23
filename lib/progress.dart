import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hiq/constant/data_json.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hiq/pages/course_detail_page.dart';

class CircularWaveProgress extends StatefulWidget {
  final double size;
  final double progress;
  const CircularWaveProgress({Key? key, required this.size, required this.progress}) : super(key: key);

  @override
  _CircularWaveProgressState createState() => _CircularWaveProgressState();
}

class _CircularWaveProgressState extends State<CircularWaveProgress> with TickerProviderStateMixin {
  late final AnimationController _waveController;
  late final AnimationController _progressController;
  late final Animation<double> _waveAnimation;
  late final Animation<double> _progressAnimation;
  double _currentProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _progressController = AnimationController(vsync: this, duration: const Duration(seconds: 5));

    _waveAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(_waveController);
    _progressAnimation = Tween<double>(begin: 0.0, end: widget.progress).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    )..addListener(() {
        setState(() {
          _currentProgress = _progressAnimation.value;
        });
      });

    _waveController.repeat();
    _progressController.forward();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CustomPaint(
        painter: WavePainter(progress: _currentProgress, wavePhase: _waveAnimation.value),
        foregroundPainter: ProgressPainter(progress: _currentProgress),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double progress;
  final double wavePhase;
  WavePainter({required this.progress, required this.wavePhase});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(radius, radius);
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.clipPath(Path()..addOval(rect));

    final wavePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue.withOpacity(0.5);

    final path = Path();
    final amplitude = 10.0;
    final angularFrequency = 2 * pi / size.width;
    final waterLevel = size.height * (1 - progress);

    path.moveTo(0, size.height);
    path.lineTo(0, waterLevel);

    for (double x = 0; x <= size.width; x++) {
      final y = amplitude * sin(angularFrequency * x + wavePhase) + waterLevel;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(covariant WavePainter old) {
    return old.progress != progress || old.wavePhase != wavePhase;
  }
}

class ProgressPainter extends CustomPainter {
  final double progress;
  ProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 8.0;
    final radius = (size.width - strokeWidth) / 2;
    final center = Offset(size.width / 2, size.height / 2);

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = Colors.grey.shade300;

    final fgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = Colors.blue;

    canvas.drawCircle(center, radius, bgPaint);

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      fgPaint,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: '${(progress * 100).toInt()}%',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final offset = center - Offset(textPainter.width / 2, textPainter.height / 2);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant ProgressPainter old) {
    return old.progress != progress;
  }
}

class StudentProgress extends StatefulWidget{
  User user;
  final String subjectID;
  final double progress;
  StudentProgress({required this.subjectID, required this.progress, required this.user});
  @override
  _StudentProgress createState() => _StudentProgress();

}
class _StudentProgress extends State<StudentProgress> {
  String subjectID = "";
  double progress = 0.0; // Progress should be between 0.0 and 1.0;

  String imgData = "";
  String title = "";
  void loadData(){
    subjectID = widget.subjectID;
    progress = widget.progress;
    if(subjectID == "1"){
      setState(() {
        imgData = "assets/images/marketing_detail.png";
        title = "Physics";
      });
    }
  }
  void initState() {
    loadData();
    super.initState();
  }
  Widget funny(){
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.1), // Translucent background
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular Wave Progress
          CircularWaveProgress(
            size: 60,
            progress: progress,
          ),
          SizedBox(width: 16),

          // Column for Name and Progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                // Row(
                //   children: [
                   
                //     // Text(
                //     //   '${(progress * 100).toStringAsFixed(0)}%',
                //     //   style: TextStyle(
                //     //     color: Colors.cyanAccent,
                //     //     fontWeight: FontWeight.bold,
                //     //     fontSize: 16,
                //     //   ),
                //     // ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: false,
      onTap: () => Navigator.push(
        context, 
        MaterialPageRoute(builder: (_) => CourseDetailPage(
                      imgDetail: imgData,
                      title: title,
                      user: widget.user,
                      
                    ))
      ),
      child:funny(),

    );
    
  }
}
