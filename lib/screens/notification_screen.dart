import 'package:adopt_us/config/app_theme.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body : ListView.separated(
        itemCount: 20,
        separatorBuilder: (BuildContext context, int index){
          return const Divider();
        },
        itemBuilder: (BuildContext context, int index){
          return notificationTile();
        },
      ),
    );
  }

  Widget notificationTile(){
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Themes.colorPrimary.withOpacity(1),
        child: const Icon(Icons.notifications),
      ),
      title: const Text(
        "New Notification",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4,),
          Text(
            "Short description"*10,
            style: TextStyle(
              fontSize: 14
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2,),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              DateTime.now().toLocal().toString(),
              style: const TextStyle(
                fontSize: 12
              ),
            ),
          ),
        ],
      ),
      

    );
  }
  
}