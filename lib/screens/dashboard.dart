import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/config/image_path.dart';
import 'package:adopt_us/controllers/bottom_nav_controller.dart';
import 'package:adopt_us/screens/find_screen.dart';
import 'package:adopt_us/screens/home_screen.dart';
import 'package:adopt_us/screens/notification_screen.dart';
import 'package:adopt_us/screens/profile/user_profile_screen.dart';
import 'package:adopt_us/services/user_service.dart';
import 'package:adopt_us/storage/user_prefs.dart';
import 'package:adopt_us/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({ Key? key }) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _bottomNavController = Get.put(BottomNavController());
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
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
        title: const Text(
          "Adopt Us",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20
          ),
        ),
        actions: [
          Obx((){
            switch(_bottomNavController.currentIndex){
              case 0 : {
                return SizedBox(
                  height: 50,width: 50,
                  child: RawMaterialButton(
                    shape: const CircleBorder(),
                    onPressed: (){
                      Get.to(()=> NotificationScreen());
                    }, 
                    child: const Icon(Icons.notifications_on_rounded)
                  ),
                );
              }
              case 1 : {
                return SizedBox(
                  height: 50,width: 50,
                  child: RawMaterialButton(
                    shape: const CircleBorder(),
                    onPressed: (){
                      
                    }, 
                    child: const Icon(Icons.filter_list,),
                  ),
                );
              }
            }
            // if(_bottomNavController.currentIndex==1){
            //   return SizedBox(
            //     height: 50,width: 50,
            //     child: RawMaterialButton(
            //       shape: const CircleBorder(),
            //       onPressed: (){
            //       }, 
            //       child: const Icon(Icons.filter_list,),
            //     ),
            //   );
            // }
            return const SizedBox();
          }),
        ]
      ),
      drawer: AppDrawer(),

      body: PageView(
        controller: _bottomNavController.pageController,
        children: [
          HomeScreen(),
          FindScreen(),
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
                  icon: Icon(Icons.home_outlined),
                  label: "Home"
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search, size: 22,),
                  label: "Find"
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_outlined),
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
    );
  }
}