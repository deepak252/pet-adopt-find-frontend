import 'package:adopt_us/widgets/cached_image_container.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedImageContainer(
                    imgUrl: "https://assets-global.website-files.com/60e5f2de011b86acebc30db7/61aa5a5ff33bfa3e4d4e9a21_avatar-24-denis.jpg",
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(width: 12,),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello Deepak",
                          style: TextStyle(
                            fontSize: 24
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 12,),
                        Text(
                          "+9198765432120",
                          style: TextStyle(
                            fontSize: 14
                          ),
                        ),
                        Text(
                          "deepak@gmail.com",
                          style: TextStyle(
                            fontSize: 14
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 100,),
              Divider(),
              optionWidget(
                label: "Settings",
                icon: Icons.settings
              ),
              optionWidget(
                label: "My Pets",
                icon: Icons.pets
              ),
              optionWidget(
                label: "Edit Profile",
                icon: Icons.edit
              ),
             
              

            ],
          ),
        ),
      ),
    );
  }

  Widget optionWidget({
    required String label,
    required IconData icon,
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
      leading: Icon(
        icon,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
      ),
    );
  }

}