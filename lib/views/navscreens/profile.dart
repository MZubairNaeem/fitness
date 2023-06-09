
import 'package:coachingapp/providers/get_user_type.dart';
import 'package:coachingapp/views/subscribed_coaches.dart';
import 'package:coachingapp/widgets/large_button_trasparent_text_left_align.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/colors.dart';
import '../auth/login.dart';
import 'myaccount.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //  final FirebaseAuth _auth = FirebaseAuth.instance;
  // User? userr = _auth.currentUser;
  String privacyPolicy = " Some Error Occured";

  getPrivacyPolicy() async {
    String responce = await DefaultAssetBundle.of(context)
        .loadString("assets/privacypolicy.txt");
    setState(() {
      privacyPolicy = responce;
    });
  }

@override
  void initState() {
    getPrivacyPolicy();
    super.initState();
  }
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Material(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3.6,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 3.6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors().primaryColor,
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(50))),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "Profile",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            child: Consumer(
                              builder: (context, ref, _) {
                                final userResult = ref.read(userProvider);
                                return userResult.when(
                                  data: (userModel) {
                                    return CircleAvatar(
                                      radius: screenHeight * 0.06,
                                      backgroundImage:
                                          NetworkImage(userModel.photoUrl),
                                    );
                                  },
                                  loading: () => const Text("..."),
                                  error: (error, stackTrace) =>
                                      Text('Error: $error'),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height / 1.38,
                decoration: BoxDecoration(color: AppColors().primaryColor),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 1.38,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(50))),
                    child: Padding(
                      padding: EdgeInsets.all(screenHeight * 0.035),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Consumer(
                            builder: (context, ref, _) {
                              final userResult = ref.read(userProvider);

                              return userResult.when(
                                data: (userModel) {
                                  return Column(
                                    children: [
                                      Text(
                                        userModel.firstName,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors().darKShadowColor,
                                        ),
                                      ),
                                      Text(
                                        userModel.email,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors().darKShadowColor,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                loading: () => CircularProgressIndicator(
                                  color: AppColors().primaryColor,
                                  strokeWidth: 2,
                                ),
                                error: (error, stackTrace) =>
                                    Text('Error: $error'),
                              );
                            },
                          ),
                          LargeButtonTransparentLeftAlignText(
                            name: "My Account",
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ClientAccount()));
                            },
                          ),
                          LargeButtonTransparentLeftAlignText(
                            name: "My Program",
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SubscribedCoaches()));
                            },
                          ),
                          // LargeButtonTransparentLeftAlignText(
                          //   name: "My Tracking",
                          //   onPressed: () {
                          //     // Navigator.push(
                          //     //     context,
                          //     //     MaterialPageRoute(
                          //     //         builder: (context) =>
                          //     //             const Subscription()));
                          //   },
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          LargeButtonTransparentLeftAlignText(
                            name: "Help Center",
                            onPressed: () {},
                          ),
                          LargeButtonTransparentLeftAlignText(
                            name: "Privacy Policy",
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // final privacyPolicyFile =
                                  //     File('assets/privacypolicy.txt');
                                  // final privacyPolicyText =
                                  //     privacyPolicyFile.readAsStringSync();

                                  return AlertDialog(
                                    title: const Text('Privacy Policy'),
                                    content: SingleChildScrollView(
                                      child: Text(privacyPolicy),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          LargeButtonTransparentLeftAlignText(
                            name: "Terms and Services",
                            onPressed: () {},
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.logout,
                                color: AppColors().darKShadowColor,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    final SharedPreferences sharedPreferences =
                                        await SharedPreferences.getInstance();
                                    sharedPreferences.remove('key');
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Login()),
                                        (route) => false);
                                  } catch (e) {
                                    print(e.toString());
                                  }
                                },
                                child: Text(
                                  "Log Out",
                                  style: TextStyle(
                                      color: AppColors().darKShadowColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
