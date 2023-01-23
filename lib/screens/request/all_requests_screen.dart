import 'dart:developer';

import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/config/constants.dart';
import 'package:adopt_us/controllers/bottom_nav_controller.dart';
import 'package:adopt_us/controllers/chat_controller.dart';
import 'package:adopt_us/controllers/request_controller.dart';
import 'package:adopt_us/models/request.dart';
import 'package:adopt_us/screens/pet/surrended_pet_details.dart';
import 'package:adopt_us/utils/app_navigator.dart';
import 'package:adopt_us/utils/text_utils.dart';
import 'package:adopt_us/widgets/confirmation_dialog.dart';
import 'package:adopt_us/widgets/custom_elevated_button.dart';
import 'package:adopt_us/widgets/custom_loading_indicator.dart';
import 'package:adopt_us/widgets/custom_outlined_button.dart';
import 'package:adopt_us/widgets/custom_snack_bar.dart';
import 'package:adopt_us/widgets/no_result_widget.dart';
import 'package:adopt_us/widgets/selected_user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:adopt_us/widgets/cached_image_container.dart';

class AllRequestsScreen extends StatefulWidget {
  const AllRequestsScreen({ Key? key }) : super(key: key);

  @override
  State<AllRequestsScreen> createState() => _AllRequestsScreenState();
}

class _AllRequestsScreenState extends State<AllRequestsScreen> {
  final _requestController = Get.put(RequestController());
  final _chatController = Get.put(ChatController());
  final _bottomNavController= Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Adopt Requests"),
          bottom: const TabBar(
            indicatorColor: Themes.colorPrimary,
            tabs: [
              Tab(
                text: "Requests Received",
              ),
              Tab(
                text: "Requests Made",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Obx((){
              if(_requestController.loadingReqReceived){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if(_requestController.reqReceived.isEmpty){
                return NoResultWidget(
                  title: "No Adopt Requests Received",
                  onRefresh: ()async{
                    _requestController.fetchRequestsReceived(enableLoading: true);
                  },
                );
              }
              return RefreshIndicator(
                onRefresh: ()async{
                  await _requestController.fetchRequestsReceived(enableLoading: true);
                },
                child: ListView.builder(
                  itemCount: _requestController.reqReceived.length,
                  itemBuilder: (BuildContext context, int index){
                    return _requestReceivedTile(
                      _requestController.reqReceived[index]
                    );
                  },
                ),
              );
            }),
            Obx((){
              if(_requestController.loadingReqMade){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if(_requestController.reqMade.isEmpty){
                return NoResultWidget(
                  title: "No Adopt Requests Made",
                  onRefresh: ()async{
                    _requestController.fetchRequestsMade(enableLoading: true);
                  },
                );
              }
              return RefreshIndicator(
                onRefresh: ()async{
                  await _requestController.fetchRequestsMade(enableLoading: true);
                },
                child: ListView.builder(
                  itemCount: _requestController.reqMade.length,
                  itemBuilder: (BuildContext context, int index){
                    return _requestMadeTile(
                      _requestController.reqMade[index]
                    );
                  },
                ),
              );
            }),
          ],
        ),
        
      ),
    );
  }

  Widget _requestReceivedTile(Request request){
    return Padding(
      padding: const EdgeInsets.only(top: 6,left: 6,right: 6),
      child: Stack(
        children: [
          
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            elevation: 3,
            child: Column(
              children: [            
                ListTile(
                  onTap: (){
                    showUserProfile(request.requestedBy!);
                  },
                  contentPadding: const EdgeInsets.all(6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  title: Padding(
                    padding: EdgeInsets.only(
                      right: request.isAccepted ? 40 : 0
                    ),
                    child: Text(
                      "${request.requestedBy?.fullName}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "requested to adopt ",
                          children: [
                            TextSpan(
                              text: "${TextUtils.capitalizeFirstLetter(request.pet?.petName??'')}",
                              style: const TextStyle(
                                fontSize: 15,
                                color: Themes.colorBlack,
                                fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                          style: TextStyle(
                            fontSize: 15,
                            color: Themes.colorBlack.withOpacity(0.8)
                          ),
                        ),
                      ),
                      const SizedBox(height: 8,),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 18,
                            color: Themes.colorBlack.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4,),
                          Text(
                            "${request.requestedBy?.mobile}",
                            style: const TextStyle(
                              fontSize: 14
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.email,
                            size: 18,
                            color: Themes.colorBlack.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4,),
                          Text(
                            "${request.requestedBy?.email}",
                            style: const TextStyle(
                              fontSize: 14
                            ),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "${request.date}, ${request.time}",
                          style: const TextStyle(
                            fontSize: 12
                          ),
                        ),
                      ),
                    ],
                  ),
                  leading: CachedImageContainer(
                    imgUrl: request.requestedBy?.profilePic??Constants.defaultPic,
                    height: 50,
                    width: 50,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: request.isPending
                  ? Row(
                      children: [
                        Expanded(
                          child : CustomOutlinedButton(
                            onPressed: ()async{
                              bool? confirmCancel = await showConfirmationDialog(
                                title: "Cancel Request",
                                description: "Do you want to cancel request?",
                                cancelText: "No",
                                confirmText: "Yes",
                                cancelTextColor: Themes.colorBlack,
                                confirmTextColor: Colors.red,
                                onCancel: (){
                                  Navigator.pop(context,false);
                                },
                                onConfirm: (){
                                  Navigator.pop(context,true);
                                }
                              );
                              
                              if(confirmCancel==true){
                                customLoadingIndicator(context: context,canPop: false);
                                //Reject/Cancel Request
                                bool res = await _requestController.updateRequestStatus(
                                  requestId: request.requestId,
                                  status: RequestStatus.rejected
                                );
                                if(res){
                                  CustomSnackbar.message(msg: "Request Cancelled");
                                }
                                if(mounted){
                                  Navigator.pop(context); //Dismiss Loading Indicator
                                }
                                
                              }
                            },
                            text: "Cancel",
                          ),
                        ),
                        const SizedBox(width: 16,),
                        Expanded(
                          child: CustomElevatedButton(
                            padding: const EdgeInsets.all(12),
                            onPressed: ()async{
                              customLoadingIndicator(context: context,canPop: false);
                                //Accept Request
                                bool res = await _requestController.updateRequestStatus(
                                  requestId: request.requestId,
                                  status: RequestStatus.accepted
                                );
                                if(res){
                                  CustomSnackbar.success(msg: "Request Accepted");
                                }
                                if(mounted){
                                  Navigator.pop(context); //Dismiss Loading Indicator
                                }
                            },
                            text: "Accept",
                            btnColor: Colors.green,
                            borderRadius: 12,
                          ),
                        )
                      ],
                    )
                  : CustomElevatedButton(
                      onPressed: null,
                      text: request.status,
                      txtColor: request.isAccepted 
                        ? Colors.green 
                        : request.isAccepted 
                          ? Colors.red[400] : null,
                      padding: const EdgeInsets.all(14),
                    ),
                )
              ],
            ),      
          ),
          if(request.isAccepted)
            Positioned(
              right: 2,
              child: FloatingActionButton(
                onPressed: ()async{
                  customLoadingIndicator(context: context,canPop: false);
                  _chatController.createRooom(
                    userId1: (request.requestedTo?.userId).toString(), 
                    userId2: (request.requestedBy?.userId).toString(), 
                  );
                  await Future.delayed(const Duration(seconds: 3));
                  if(mounted){
                    Navigator.pop(context);  //Dismiss loading
                    Navigator.pop(context);  //Go to home
                    _bottomNavController.changeRoute(index: 2);
                  }
                }, 
                backgroundColor: Colors.green,
                child: const Icon(
                  CupertinoIcons.chat_bubble_text,
                  size: 30,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _requestMadeTile(Request request){
    return Padding(
      padding: const EdgeInsets.only(top: 6,left: 6,right: 6),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        elevation: 3,
        child: Column(
          children: [            
            ListTile(
              onTap: (){
                showUserProfile(request.requestedTo!);
              },
              contentPadding: const EdgeInsets.all(6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              title: Text(
                "${request.pet?.petName}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "owned by ",
                      children: [
                        TextSpan(
                          text: "${TextUtils.capitalizeFirstLetter(request.requestedTo?.fullName??'')}",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Themes.colorBlack,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                      style: TextStyle(
                        fontSize: 15,
                        color: Themes.colorBlack.withOpacity(0.8)
                      ),
                    ),
                  ),
                  const SizedBox(height: 8,),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 18,
                        color: Themes.colorBlack.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4,),
                      Text(
                        "${request.requestedTo?.mobile}",
                        style: const TextStyle(
                          fontSize: 14
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.email,
                        size: 18,
                        color: Themes.colorBlack.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4,),
                      Text(
                        "${request.requestedTo?.email}",
                        style: const TextStyle(
                          fontSize: 14
                        ),
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "${request.date}, ${request.time}",
                      style: const TextStyle(
                        fontSize: 12
                      ),
                    ),
                  ),
                 
                ],
              ),
              
              leading: GestureDetector(
                onTap: (){
                  AppNavigator.push(context, SurrendedPetDetailsScreen(pet: request.pet!));
                },
                child: CachedImageContainer(
                  imgUrl: request.pet?.photos[0]??'',
                  height: 100,
                  width: 70,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomOutlinedButton(
                onPressed: ()async{
                  //Delete Request
                  bool? confirmDelete = await showConfirmationDialog(
                    title: "Cancel Request",
                    description: "Do you want to cancel request?",
                    cancelText: "No",
                    confirmText: "Yes",
                    cancelTextColor: Themes.colorBlack,
                    confirmTextColor: Colors.red,
                    onCancel: (){
                      Navigator.pop(context,false);
                    },
                    onConfirm: (){
                      Navigator.pop(context,true);
                    }
                  );
                  if(confirmDelete==true){
                    customLoadingIndicator(context: context,canPop: false);
                    bool res =await _requestController.deleteRequest(requestId: request.requestId);
                    if(res){
                      CustomSnackbar.message(msg: "Request Cancelled");
                    }
                    if(mounted){
                      Navigator.pop(context); //Dismiss Loading Indicator
                    }
                  }
                },
                text: "Cancel",
              ),
            )
          ],
        ),      
      ),
    );
  }
}
