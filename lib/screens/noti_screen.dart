import 'package:flutter/material.dart';

class NotiScreen extends StatelessWidget {
  NotiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 34,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            'You have 5 notifications today.',
            style: TextStyle(fontSize: 18, color: Colors.orange),
          ),
          SizedBox(height: 16),
          Text(
            'Today',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          _buildNotification(
              'Time to check your fruit inventory!', '3 hours ago'),
          _buildNotification(
              'Unable to identify fruit. Please try again in brighter light.',
              '5 hours ago'),
          _buildNotification(
              'This banana appears spoiled. Please inspect it carefully. Make sure to check for any unusual spots or textures that might indicate spoilage, and consider discarding it if it smells off or feels too soft.',
              '5 hours ago'),
          _buildNotification(
              'Reminder: Check your apple stock today. Look for any signs of bruising or overripeness, and ensure they are stored in a cool, dry place.',
              '6 hours ago'),
          _buildNotification(
              'Orange inventory update: One orange shows signs of mold. Please remove it immediately to prevent spreading to other fruits.',
              '7 hours ago'),
          SizedBox(height: 16),
          Text(
            'This week',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          _buildNotificationNoDot(
              'New update: Now supports scanning 10 more fruit types! Including exotic fruits like mango and papaya.',
              ''),
          _buildNotificationNoDot(
              'This banana appears spoiled. Please inspect it carefully. Check for brown or black spots, and ensure proper storage to avoid future spoilage.',
              ''),
          _buildNotificationNoDot(
              'This banana appears spoiled. Please inspect it carefully. Look for any soft spots or an overly strong odor, and dispose of it if necessary.',
              ''),
          _buildNotificationNoDot(
              'Grape check: Some grapes appear shriveled. Please inspect and consider replacing the bunch if more than half are affected.',
              ''),
          _buildNotificationNoDot(
              'Pineapple alert: One pineapple seems overripe. Check the base for a strong sweet smell and soft spots before using.',
              ''),
          _buildNotificationNoDot(
              'Kiwi inspection needed: A few kiwis feel too soft. Please check and remove any that don’t meet quality standards.',
              ''),
        ],
      ),
    );
  }

  Widget _buildNotification(String message, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.circle, size: 8, color: Colors.orange),
            SizedBox(width: 8),
            Expanded(child: Text(message, style: TextStyle(fontSize: 16))),
          ],
        ),
        if (time.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: 16, top: 4),
            child: Text(
              time,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        Divider(color: Colors.orange, thickness: 1),
      ],
    );
  }

  Widget _buildNotificationNoDot(String message, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
          child: Text(message, style: TextStyle(fontSize: 16)),
        ),
        if (time.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: 16, top: 4),
            child: Text(
              time,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        Divider(color: Colors.orange, thickness: 1),
      ],
    );
  }
}