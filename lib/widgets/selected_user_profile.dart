
import 'package:adopt_us/models/user.dart';
import 'package:adopt_us/widgets/cached_image_container.dart';
import 'package:flutter/material.dart';

class SelectedUserProfile extends StatelessWidget {
  final User user;
  const SelectedUserProfile({ Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CachedImageContainer(
              imgUrl: user.profilePic??"https://assets-global.website-files.com/60e5f2de011b86acebc30db7/61aa5a5ff33bfa3e4d4e9a21_avatar-24-denis.jpg",
              height: 50,
              width: 50,
              borderRadius: BorderRadius.circular(100),
            ),
            const SizedBox(width: 6,),
            Text(
              "${user.fullName}",
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              optionWidget(
                label: "${user.mobile}",
                trailingIcon: Icons.phone,
                trailingColor: Colors.green,
                onTap: (){

                }
              ),
              optionWidget(
                label: "${user.email}",
                trailingIcon: Icons.email,
                trailingColor: const Color(0xFFD64A3E),
                onTap: (){
                  
                }
              ),
              
              // Row(
              //   children: [
              //     Icon(
              //       Icons.email,
              //       size: 20,
              //     ),
              //     SizedBox(width: 6,),
              //     Text(
              //       "${user.email}",
              //       style: TextStyle(
              //         fontSize: 16
              //       ),
              //     ),
              //   ],
              // ),
            
              Divider(),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget optionWidget({
    required String label,
    IconData? trailingIcon,
    Color? trailingColor,
    VoidCallback? onTap,
  }){
    return ListTile(
      onTap: onTap,
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 18
        ),
      ),
      trailing: trailingIcon !=null
      ? SizedBox(
          height: 50,width: 50,
          child: RawMaterialButton(
            fillColor: trailingColor,
            shape: const CircleBorder(),
            onPressed: onTap, 
            child: Icon(trailingIcon, color: Colors.white,)
          ),
        )
      : null
    );
    return ListTile(
      onTap: onTap,
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 18
        ),
      ),
     
      trailing: const Icon(
        Icons.arrow_forward_ios,
      ),
    );
  }

}