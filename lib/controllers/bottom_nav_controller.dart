import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// For the STATE of bottom navigation bar index.
class BottomNavController extends GetxController{
  final _currentIndex = 0.obs;
  final _pageController = PageController();
  set setIndex(int index)=>_currentIndex(index);

  int get currentIndex=>_currentIndex.value;
  PageController get pageController=>_pageController;
  
  void changeRoute({required int index}){
    _currentIndex.update((val)=>_currentIndex(index));
    if(_pageController.hasClients){
      _pageController.jumpToPage(index);
    }
  }

  
}