import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/config/constants.dart';
import 'package:adopt_us/controllers/request_controller.dart';
import 'package:adopt_us/models/request.dart';
import 'package:adopt_us/screens/pet/surrended_pet_details.dart';
import 'package:adopt_us/utils/app_router.dart';
import 'package:adopt_us/utils/text_utils.dart';
import 'package:adopt_us/widgets/custom_elevated_button.dart';
import 'package:adopt_us/widgets/no_result_widget.dart';
import 'package:adopt_us/widgets/selected_user_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:adopt_us/widgets/cached_image_container.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({ Key? key }) : super(key: key);

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final _requestController = Get.put(RequestController());

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
      child: Card(
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
              title: Text(
                "${request.requestedBy?.fullName}",
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
                  )
                 
                ],
              ),
              leading: CachedImageContainer(
                imgUrl: request.requestedBy?.profilePic??Constants.defaultPic,
                height: 50,
                width: 50,
                borderRadius: BorderRadius.circular(100),
              ),
            
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      onPressed: (){

                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomElevatedButton(
                      padding: EdgeInsets.all(12),
                      onPressed: (){},
                      text: "Accept",
                      btnColor: Colors.green,
                      borderRadius: 12,
                    ),
                  ),
                )
              ],
            )
          ],
        ),      
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
                  )
                 
                ],
              ),
              
              leading: GestureDetector(
                onTap: (){
                  AppRouter.push(context, SurrendedPetDetailsScreen(pet: request.pet!));
                },
                child: CachedImageContainer(
                  imgUrl: request.pet?.photos[0]??'',
                  height: 100,
                  width: 70,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            
            ),
            Column(
              children: [
                Text("${request.createdAt}"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    onPressed: (){

                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(double.infinity,0)
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),      
      ),
    );
  }
}
