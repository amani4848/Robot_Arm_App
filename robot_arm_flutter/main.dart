import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(RobotArmApp());
}

class RobotArmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Robot Arm Controller',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RobotArmHomePage(),
    );
  }
}

class RobotArmHomePage extends StatefulWidget {
  @override
  _RobotArmHomePageState createState() => _RobotArmHomePageState();
}

class _RobotArmHomePageState extends State<RobotArmHomePage> {
  double motor1 = 0;
  double motor2 = 0;
  double motor3 = 0;
  double motor4 = 0;

  List<Map<String, dynamic>> savedPoses = [];

  final String baseUrl = 'http://10.0.2.2/flutter_arm_api';

  @override
  void initState() {
    super.initState();
    fetchPoses();
  }

  Future<void> fetchPoses() async {
    final response = await http.get(Uri.parse('$baseUrl/get_poses.php'));
    if (response.statusCode == 200) {
      setState(() {
        savedPoses = List<Map<String, dynamic>>.from(
          json.decode(response.body),
        );
      });
    }
  }

  Future<void> savePose() async {
    final response = await http.post(
      Uri.parse('$baseUrl/save_pose.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'motor1': motor1.toInt(),
        'motor2': motor2.toInt(),
        'motor3': motor3.toInt(),
        'motor4': motor4.toInt(),
      }),
    );
    if (response.statusCode == 200) {
      fetchPoses();
    }
  }

  Future<void> deletePose(String id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delete_pose.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': id}),
    );
    if (response.statusCode == 200) {
      fetchPoses();
    }
  }

  void runPose(Map<String, dynamic> pose) {
    setState(() {
      motor1 = double.parse(pose['motor1']);
      motor2 = double.parse(pose['motor2']);
      motor3 = double.parse(pose['motor3']);
      motor4 = double.parse(pose['motor4']);
    });
  }

  void resetMotors() {
    setState(() {
      motor1 = motor2 = motor3 = motor4 = 0;
    });
  }

  Widget buildSlider(String label, double value, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toInt()}'),
        Slider(
          value: value,
          min: 0,
          max: 180,
          divisions: 180,
          activeColor: Colors.blue,
          thumbColor: Colors.blue,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget buildCustomButton(String text, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.blue,
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.blue),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Robot Arm Control Panel')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildSlider(
              "Motor 1",
              motor1,
              (val) => setState(() => motor1 = val),
            ),
            buildSlider(
              "Motor 2",
              motor2,
              (val) => setState(() => motor2 = val),
            ),
            buildSlider(
              "Motor 3",
              motor3,
              (val) => setState(() => motor3 = val),
            ),
            buildSlider(
              "Motor 4",
              motor4,
              (val) => setState(() => motor4 = val),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildCustomButton("Reset", resetMotors),
                buildCustomButton("Save Pose", savePose),
                buildCustomButton("Run", () {}),
              ],
            ),
            SizedBox(height: 20),
            Text("Saved Poses:", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: savedPoses.length,
                itemBuilder: (context, index) {
                  final pose = savedPoses[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        "Pose ${pose['id']}: ${pose['motor1']}, ${pose['motor2']}, ${pose['motor3']}, ${pose['motor4']}",
                      ),
                      leading: IconButton(
                        icon: Icon(Icons.play_arrow, color: Colors.blue),
                        onPressed: () => runPose(pose),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deletePose(pose['id'].toString()),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
