import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/config/constants.dart';
import 'package:adopt_us/controllers/bottom_nav_controller.dart';
import 'package:adopt_us/controllers/user_controller.dart';
import 'package:adopt_us/models/user.dart';
import 'package:adopt_us/screens/auth/sign_in_screen.dart';
import 'package:adopt_us/screens/pet/favorite_pets_screen.dart';
import 'package:adopt_us/screens/request/all_requests_screen.dart';
import 'package:adopt_us/splash_screen.dart';
import 'package:adopt_us/utils/app_navigator.dart';
import 'package:adopt_us/widgets/cached_image_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AppDrawer extends StatelessWidget {
  AppDrawer({ Key? key, }) : super(key: key);
  final _bottomNavController = Get.put(BottomNavController());
  final _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Obx((){
          return ListView(
            children: [
              const SizedBox(height: 30,),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                  if(_userController.isSignedIn){
                    return;
                  }
                  AppNavigator.push(context, const SignInScreen());
                },  
                child: Container(
                  color: Colors.transparent,
                  child: drawerHeader(_userController.user))
              ),
              const SizedBox(height: 30,),
              const Divider(thickness: 2,),
              _DrawerTile(
                onTap: ()async{
                  Navigator.pop(context);
                  await Future.delayed(const Duration(milliseconds: 300));
                  _bottomNavController.changeRoute(index: 0);
                }, 
                icon: CupertinoIcons.home, 
                title: "Home",
                isSelected: _bottomNavController.currentIndex==0,
              ),
              _DrawerTile(
                onTap: (){
                  Navigator.pop(context);
                  AppNavigator.push(context, FavoritePetsScreen());
                }, 
                icon: Icons.favorite_border_outlined, 
                title: "Favorites",
                isSelected: false,
              ),
              _DrawerTile(
                onTap: ()async{
                  Navigator.pop(context);
                  await Future.delayed(const Duration(milliseconds: 300));
                  _bottomNavController.changeRoute(index: 1);
                }, 
                icon: CupertinoIcons.search,
                title: "Missing Pets",
                isSelected: _bottomNavController.currentIndex==1,
              ),
              _DrawerTile(
                onTap: (){
                  Navigator.pop(context);
                  AppNavigator.push(context, const AllRequestsScreen());
                }, 
                icon: Icons.pets,
                title: "Requests",
              ),
              const Divider(thickness: 2,),
              if(_userController.isSignedIn)
               _DrawerTile(
                  onTap: ()async{
                    _userController.logOut();
                    AppNavigator.pushAndRemoveUntil(context, const SplashScreen());
                  }, 
                  icon: Icons.logout,
                  title: "Sign Out",
                ),
             
              _DrawerTile(
                onTap: (){
                  Navigator.pop(context);
                }, 
                icon: Icons.info_outlined,
                title: "About Us",
              ),
              _DrawerTile(
                onTap: (){}, 
                icon: Icons.support_agent_outlined,
                title: "Help & Support",
              ),
              
            ],
          );  
        })
        
      ),
    );
  }


  Widget drawerHeader(User? user){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 12,),
        //Profile Pic
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: CachedImageContainer(
            imgUrl: user?.profilePic??Constants.defaultPic,
            height: 60,
            width: 60,
            borderRadius: BorderRadius.circular(100),
          )
        ),
        const SizedBox(width: 12,),
        Flexible(
          child: Text(
            user!=null
            ? "Hello ${user.fullName}"
            : "Sign In",
            style: const TextStyle(
              fontSize: 24
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8,),
      
      ],
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  final bool? isSelected;
  const _DrawerTile({ 
    Key? key,
    required this.onTap,
    required this.icon,
    required this.title,
    this.isSelected
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: onTap,
          leading: Icon(
            icon,
            color : isSelected==true? Colors.white : Themes.colorBlack,
          ),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                color: isSelected==true? Colors.white : Themes.colorBlack,
                fontSize: 18,
              ),
            ),
          ),
          horizontalTitleGap: 4,
          selectedTileColor: Themes.colorPrimary.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          selected: isSelected??false,
          focusColor: Themes.colorPrimary.withOpacity(0.5)
        ),
      ),
    );
  }
}