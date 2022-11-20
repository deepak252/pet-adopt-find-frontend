import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/controllers/bottom_nav_controller.dart';
import 'package:adopt_us/screens/auth/sign_in_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AppDrawer extends StatelessWidget {
  AppDrawer({ Key? key, }) : super(key: key);
  final _bottomNavController = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            SizedBox(height: 100,),
            _DrawerTile(
              onTap: (){
                Navigator.pop(context);
              }, 
              icon: Icons.home_outlined, 
              title: "Home",
              isSelected: true,
            ),
            _DrawerTile(
              onTap: (){
                
              }, 
              icon: Icons.favorite_border_outlined, 
              title: "Favorites",
              isSelected: false,
            ),
            _DrawerTile(
              onTap: (){
                Navigator.pop(context);
              }, 
              icon: Icons.search,
              title: "Find Pet",
            ),
            const Divider(thickness: 2,),
            _DrawerTile(
              onTap: ()async{
                Navigator.pop(context);
                Get.to(()=>const SignInScreen());
              }, 
              icon: Icons.login,
              title: "Sign In",
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
        ),
      ),
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