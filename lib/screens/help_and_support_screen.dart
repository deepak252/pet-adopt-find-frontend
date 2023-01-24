
import 'package:adopt_us/widgets/app_icon_widget.dart';
import 'package:adopt_us/widgets/custom_elevated_button.dart';
import 'package:adopt_us/widgets/custom_icon_button.dart';
import 'package:adopt_us/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help & Support"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 40,),
                const AppIconWidget(),
                const SizedBox(height: 100,),
                CustomElevatedButton(
                  onPressed: ()async{
                    if (!await launchUrl(Uri.parse("tel:+919354356689"))) {
                      CustomSnackbar.error(error: "Can't make call!");
                    }
                  },
                  btnColor: Colors.green,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.phone, color: Colors.white,size: 28,),
                      SizedBox(width: 12,),
                      Flexible(
                        child: Text("+919354356689",
                          style: TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  )
                ),
                const SizedBox(height: 20,),
                CustomElevatedButton(
                  onPressed: ()async{
                    if (!await launchUrl(Uri.parse("mailto:deepakkudc@gmail.com"))) {
                      CustomSnackbar.error(error: "Can't email");
                    }
                  },
                  btnColor: const Color(0xFFD64A3E),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.email, color: Colors.white,size: 28,),
                      SizedBox(width: 12,),
                      Flexible(
                        child: Text("deepakkudc@gmail.com",
                          style: TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}