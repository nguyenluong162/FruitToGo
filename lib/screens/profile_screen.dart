import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../widgets/double_circle.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _avatarImage;
  final ImagePicker _picker = ImagePicker();
  bool _showSettings = false;

  Future<void> _showAvatarOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromCamera();
                },
              ),
              if (_avatarImage != null)
                ListTile(
                  leading: Icon(Icons.visibility),
                  title: Text('View Avatar'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _viewAvatar();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _avatarImage = File(image.path);
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _avatarImage = File(image.path);
      });
    }
  }

  void _viewAvatar() {
    if (_avatarImage != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.file(_avatarImage!),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Close'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void _toggleSettings() {
    setState(() {
      _showSettings = !_showSettings;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSettings) {
      return _buildSettingsScreen();
    }
    return _buildProfileScreen();
  }

  Widget _buildProfileScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 300,
            left: -100,
            child: const DoubleCircle(outerRadius: 60, innerRadius: 48),
          ),
          Positioned(
            top: 120,
            right: -70,
            child: const DoubleCircle(outerRadius: 60, innerRadius: 48),
          ),
          Column(
            children: [
              // Custom Header
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/icons/setting.png', width: 45, color: Colors.white,),

                    Text(
                      'General',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 34,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: Image.asset('assets/icons/setting.png'),
                      onPressed: _toggleSettings,
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar Section
                      GestureDetector(
                        onTap: _showAvatarOptions,
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFF9DA82),
                                image: _avatarImage != null
                                    ? DecorationImage(
                                        image: FileImage(_avatarImage!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey[300]!, width: 2),
                                ),
                                child: Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                
                      SizedBox(height: 32),
                      
                      // Pro Upgrade Section
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        decoration: BoxDecoration(
                          color: Color(0XFFFFE7A1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFFF9DA82),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text(
                                'Pro',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Text(
                              'Upgrade to Premium',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 32),
                      
                      // You may like section
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'You may like',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Cards Row
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: AssetImage('assets/images/profile1.jpeg'), // You'll need to add this image
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: AssetImage('assets/images/profile2.jpeg'), // You'll need to add this image
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 32),
                      
                      // Rate this app section
                      Text(
                        'Rate this app',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Star Rating
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFE7A1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(
                                Icons.star_rounded,
                                size: 40,
                                color: index < 4 ? Colors.orange : Colors.white,
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]
      ),
    );
  }

  Widget _buildSettingsScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                bottom: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Image.asset('assets/icons/left-arrow.png', width: 24, height: 24),
                    onPressed: _toggleSettings,
                  ),

                  Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 34,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFE7A1),
                      borderRadius: BorderRadius.circular(16),
                    ),   
                    child: IconButton(
                      icon: Image.asset('assets/icons/setting.png'),
                      onPressed: _toggleSettings,
                    ),
                  ),
                ],
              ),
            ),

            // Account Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFFFE7A1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Image.asset('assets/icons/user.png', width: 32, height: 32),
                  SizedBox(width: 16),
                  Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 16),
            
            // Account sub-options
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                children: [
                  _buildSettingsOption('Changing password'),
                  SizedBox(height: 12),
                  _buildSettingsOption('Editing personal info'),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Notifications Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0XFFFFE7A1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Image.asset('assets/icons/bell-ring.png', width: 32, height: 32),
                  SizedBox(width: 16),
                  Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 16),
            
            // Notifications sub-options
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                children: [
                  _buildSettingsOption('Sound/Vibration'),
                  SizedBox(height: 12),
                  _buildSettingsOption('Do not disturb'),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // More Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFFFE7A1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Image.asset('assets/icons/rocket.png', width: 32, height: 32),
                  SizedBox(width: 16),
                  Text(
                    'More',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 16),
            
            // More sub-options
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                children: [
                  _buildSettingsOption('Language'),
                  SizedBox(height: 12),
                  _buildSettingsOption('Update'),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Log out
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logged out. Please sign in.')),
                );
                Navigator.pushNamed(context,'/login');
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFFFE7A1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Image.asset('assets/icons/door.png', width: 32, height: 32),
                    SizedBox(width: 16),
                    Text(
                      'Log out',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  
  Widget _buildSettingsOption(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}