import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:med_reminder/provider/auth_provider.dart';
import 'package:med_reminder/screens/feedback.dart';
import 'package:med_reminder/screens/medicine.dart';
import 'package:med_reminder/screens/prescriptions.dart';
import 'package:med_reminder/screens/search_med.dart';
import 'package:med_reminder/screens/searchpage.dart' as searchpage;
import 'package:med_reminder/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return Drawer(
      child: ListView(
        children: [
          // Drawer Header with User Info
          _buildDrawerHeader(ap),

          // Drawer Items as Static Background Tiles
          _buildStaticDrawerItem(
            context,
            CupertinoIcons.search,
            "Medicine Information",
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePageWidget()),
            ),
          ),
          _buildStaticDrawerItem(
            context,
            CupertinoIcons.map,
            "Search Hospitals",
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const searchpage.HomePageWidget()),
            ),
          ),
          _buildStaticDrawerItem(
            context,
            CupertinoIcons.pen,
            "Feedback",
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FeedbackByUser()),
            ),
          ),
          _buildStaticDrawerItem(
            context,
            CupertinoIcons.square_arrow_right,
            "Log Out",
                () {
              _showLogoutDialog(context, ap);
            },
          ),
        ],
      ),
    );
  }

  // Drawer Header with user details
  Widget _buildDrawerHeader(AuthProvider ap) {
    return Container(
      padding: EdgeInsets.zero,
      color: Colors.blueGrey.shade800,
      child: UserAccountsDrawerHeader(
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(color: Colors.blueGrey.shade800),
        accountName: Text(
          ap.userModel.name,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        accountEmail: Text(
          ap.userModel.email,
          style: GoogleFonts.abel(
            color: Colors.white70,
            fontSize: 12.sp,
          ),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            CupertinoIcons.person,
            color: Colors.blueGrey.shade800,
            size: 28.sp,
          ),
        ),
      ),
    );
  }

  // Static Drawer Item Widget with black text and solid background
  Widget _buildStaticDrawerItem(
      BuildContext context,
      IconData icon,
      String title,
      VoidCallback onTap,
      ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.0.h),
      child: Card(
        elevation: 8,  // Increased elevation for more visible floating effect
        shadowColor: Colors.black.withOpacity(0.2),  // More noticeable shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),  // Slightly smaller radius
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200, // Static background color (light grey)
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 6.sp, horizontal: 10.sp),  // Reduced padding
            leading: Icon(
              icon,
              color: Colors.black,  // Black icon for contrast on light background
              size: 22.sp,  // Slightly smaller icon size
            ),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,  // Smaller font size for a more compact look
                color: Colors.black,  // Black text for better readability
              ),
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }

  // Logout confirmation dialog
  void _showLogoutDialog(BuildContext context, AuthProvider ap) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 2.h),
          title: Text(
            'Are you sure you want to log out?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "No",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                ap.userSignOut().then(
                      (value) => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                        (route) => false,
                  ),
                );
              },
              child: Text(
                "Yes",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
