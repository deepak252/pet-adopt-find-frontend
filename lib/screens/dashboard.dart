import 'dart:developer';

import 'package:adopt_us/config/image_path.dart';
import 'package:adopt_us/controllers/bottom_nav_controller.dart';
import 'package:adopt_us/controllers/chat_controller.dart';
import 'package:adopt_us/controllers/user_controller.dart';
import 'package:adopt_us/screens/chat/all_chats_screen.dart';
import 'package:adopt_us/screens/find_screen.dart';
import 'package:adopt_us/screens/home_screen.dart';
import 'package:adopt_us/screens/notification_screen.dart';
import 'package:adopt_us/screens/profile/edit_user_profile_screen.dart';
import 'package:adopt_us/screens/profile/user_profile_screen.dart';
import 'package:adopt_us/utils/app_navigator.dart';
import 'package:adopt_us/widgets/app_drawer.dart';
import 'package:adopt_us/widgets/custom_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({ Key? key }) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _bottomNavController = Get.put(BottomNavController());
  final _userController = Get.put(UserController());
  // final _chatController = Get.put(ChatController());
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(_userController.isSignedIn && !_userController.validateUser){
        AppNavigator.push(context, const EditUserProfileScreen(
          canPop: false,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if(_bottomNavController.currentIndex!=0){
          _bottomNavController.changeRoute(index: 0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity,55),
          child: Obx((){
            int index=_bottomNavController.currentIndex;
            return AppBar(
              leading: IconButton(
                icon: Image.asset(
                  ImagePath.menu,
                  height: 28,
                  width: 28,
                ),
                onPressed: (){
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              title: Text(
                index<2
                ? "Adopt Us"
                : index==2
                  ? "Messages"
                  : "Profile",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20
                ),
              ),
              actions: [
                if(index==0)
                  CustomIconButton(
                    onPressed: (){
                      AppNavigator.push(context, NotificationScreen());
                    },
                    icon: Icons.notifications_on_rounded,
                  )
                // else if(index==1)
                //   CustomIconButton(
                //     onPressed: (){
                //     },
                //     icon: Icons.filter_list,
                //   )
              ]
            );}
          ),
        ),
        drawer: AppDrawer(),

        body: PageView(
          controller: _bottomNavController.pageController,
          children: [
            HomeScreen(),
            FindScreen(),
            AllChatsScreen(),
            UserProfileScreen(),
          ],
          onPageChanged: (index) {
            _bottomNavController.setIndex=index;
          },
        ),

        bottomNavigationBar: Obx((){
          return Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  blurRadius: 16,
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                // backgroundColor: Themes.colorPrimary,
                currentIndex: _bottomNavController.currentIndex,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.home),
                    label: "Home"
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.search, size: 22,),
                    label: "Find"
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.chat_bubble_2, size: 22,),
                    label: "Chat"
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.person),
                    label:"Profile"
                  ),
                ],
                onTap: (int index) {
                  _bottomNavController.changeRoute(index: index);
                },
              ),
            ),
          );
        })
      ),
    );
  }
}