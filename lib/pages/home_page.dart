import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:post_it/models/user.dart';
import 'package:post_it/pages/intro_page.dart';
import 'package:post_it/pages/search_screen.dart';
import 'package:post_it/pages/user_profile.dart';
import 'package:post_it/services/remote_service.dart';
import 'package:post_it/widget/profile_box.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';

import '../models/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post>? posts;
  Map<int, User?> userMap = {};
  List<bool>? isLikedList;
  List<bool>? isSavedList;
  var isLoaded = false;
  var isLiked = false;
  var isSaved = false;
  var isUserGet = false;
  bool _isShowCase = false;

  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();

  Map<int, String> userImages = {
    1: 'assets/images/1.png',
    2: 'assets/images/2.jpg',
    3: 'assets/images/3.jpg',
    4: 'assets/images/4.jpg',
    5: 'assets/images/5.jpg',
    6: 'assets/images/6.jpg',
    7: 'assets/images/7.jpg',
    8: 'assets/images/8.jpeg',
    9: 'assets/images/9.jpg',
    10: 'assets/images/10.jpg',
  };

  @override
  void initState() {
    super.initState();
    getData();
    _checkIfShowcaseSeen();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      ShowCaseWidget.of(context).startShowCase([_one, _two, _three, _four]);
    });
  }

  Future<void> _checkIfShowcaseSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenShowcase = prefs.getBool('hasSeenShowcase') ?? false;
    if (!hasSeenShowcase) {
      setState(() { _isShowCase = true; });
      prefs.setBool('hasSeenShowcase', true);
    }
  }

  void getData() async {
    posts = await RemoteService().getPosts();
    if (posts != null) {
      setState(() {
        isLoaded = true;
        isLikedList = List.generate(posts!.length, (index) => false);
        isSavedList = List.generate(posts!.length, (index) => false);
      });

      for (var post in posts!) {
        fetchUserByID(post.userId);
      }
    }
  }

  void fetchUserByID(int id) async {
    User? user = await RemoteService().getUserById(id);
    if (user != null) {
      setState(() {
        userMap[id] = user;
      });
    }
  }

  void _onLikePressed(int index) {
    setState(() {
      isLikedList![index] = !isLikedList![index];
    });
  }

  void _onSavePressed(int index) {
    setState(() {
      isSavedList![index] = !isSavedList![index];
    });
  }

  void _onViewProfile(int id) {
    Navigator.of(context).pop();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => UserProfile(userID: id)));
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String capitalizeEveryWord(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  createNewDialog(int index, int userID) {
    showDialog(
        context: context,
        builder: (context) {
          return ProfileBox(
            onLike: () => _onLikePressed(index),
            onSave: () => _onSavePressed(index),
            onView: () => _onViewProfile(userID),
            imageID: userID,
            isLikedList: isLikedList![index],
            isSavedList: isSavedList![index],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

      /* --> <-- --> <-- App Bar --> <-- --> <-- */
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        forceMaterialTransparency: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Padding(
              padding: const EdgeInsets.only(left: 6),
              child: _isShowCase ? Showcase(
                key: _one,
                overlayOpacity: 0.5,
                description: 'Tap to Explore Menu',
                child: const Icon(Icons.menu, color: Colors.black87),
              ) : const Icon(Icons.menu, color: Colors.black87),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),

      /* --> <-- --> <-- Drawer --> <-- --> <-- */
      drawer: Drawer(
        child: Container(
          color: Colors.grey[900],
          child: Column(
            children: [
              DrawerHeader(
                child: Center(
                  child:Image.asset(
                    'assets/images/logo.png',
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  leading: const Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'H O M E',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfile(userID: 1)));
                  },
                  leading: const Icon(
                    Icons.person_outline_sharp,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'P R O F I L E',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 30),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const IntroPage()));
                  },
                  leading: const Icon(
                    Icons.logout_sharp,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'L O G O U T',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: Column(
        children: [
          /* --> <-- --> <-- Search View Function --> <-- --> <-- */
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            child: _isShowCase ? Showcase(
              key: _two,
              overlayOpacity: 0.5,
              targetShapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
              description: 'Tap to Search Content Creators',
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Search for creators',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ) : Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Search for creators',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),

          /* --> <-- --> <-- Tag Line --> <-- --> <-- */
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: AutoSizeText(
              maxLines: 2,
              'Discover and Connect Through Every Thought..!',
              style: TextStyle(
                color: Colors.grey[600],
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          /* --> <-- --> <-- Page Title --> <-- --> <-- */
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Row(
              children: [
                AutoSizeText(
                  'Explore 🔥',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),

          /* --> <-- --> <-- List of posts --> <-- --> <-- */
          Expanded(
            child: Visibility(
              visible: isLoaded,
              replacement: getShimmerLoading(),
              child: ListView.builder(
                itemCount: posts?.length,
                itemBuilder: (context, index) {
                  final post = posts![index];
                  final user = userMap[post.userId];
                  String imagePath = userImages[post.userId] ?? 'assets/images/default.png';
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /* --> <-- --> <-- Profile Design --> <-- --> <-- */
                      Row(
                        children: [
                          /* ---------------------- User Photo ---------------------- */
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20, right: 12, top: 12
                            ),
                            child: GestureDetector(
                              onTap: () => createNewDialog(index, post.userId),
                              child: index == 1 && _isShowCase ? Showcase(
                                  overlayOpacity: 0.5,
                                  targetShapeBorder: const CircleBorder(),
                                  key: _three,
                                  showArrow: true,
                                  description: 'Tap to View Profile Picture',
                                  child: buildUserPhoto(imagePath),
                              ) : buildUserPhoto(imagePath),
                            ),
                          ),

                          /* ---------------------- User name ---------------------- */
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserProfile(
                                      userID: post.userId,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 12),
                                child: index == 1 && _isShowCase ? Showcase(
                                    overlayOpacity: 0.5,
                                    key: _four,
                                    targetPadding: const EdgeInsets.all(7),
                                    description: 'Tap to Visit User Profile',
                                    child: designUserName(user)
                                ) : designUserName(user),
                              ),
                            ),
                          ),

                          /* ---------------------- Icon at the end ---------------------- */
                          Container(
                            margin:
                            const EdgeInsets.only(right: 20, top: 12),
                            child: const Icon(
                              Icons.more_vert,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),

                      /* --> <-- --> <-- Posts --> <-- --> <-- */
                      Container(
                        margin: const EdgeInsets.only(
                            left: 12, right: 12, top: 12),
                        padding: const EdgeInsets.all(8),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey[350],
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /* ---------------------- Post Title ---------------------- */
                              Text(
                                capitalizeEveryWord(post.title),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w600,
                                  wordSpacing: 1.2,
                                  letterSpacing: 0.7,
                                ),
                              ),

                              /* ---------------------- Post Body ---------------------- */
                              const SizedBox(height: 8),
                              Text(
                                capitalizeEveryWord(post.body),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w400,
                                  wordSpacing: 0.6,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      /* --> <-- --> <-- Like & Other Design --> <-- --> <-- */
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 16, bottom: 10),
                        child: Row(
                          children: [
                            /* ---------------------- Like Icon ---------------------- */
                            IconButton(
                              icon: Icon(
                                isLikedList![index]
                                    ? FontAwesomeIcons.solidHeart
                                    : FontAwesomeIcons.heart,
                                color: isLikedList![index]
                                    ? Colors.red
                                    : Colors.black87,
                              ),
                              onPressed: () => _onLikePressed(index),
                            ),

                            /* ---------------------- Comment Icon ---------------------- */
                            const SizedBox(width: 10),
                            const Icon(
                              FontAwesomeIcons.comment,
                              color: Colors.black87,
                            ),

                            /* ---------------------- Share Icon ---------------------- */
                            const SizedBox(width: 10),
                            const Padding(
                              padding: EdgeInsets.only(left: 7),
                              child: Icon(
                                Icons.share_sharp,
                                color: Colors.black87,
                              ),
                            ),

                            /* ---------------------- Save Icon ---------------------- */
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                isSavedList![index]
                                    ? FontAwesomeIcons.solidBookmark
                                    : FontAwesomeIcons.bookmark,
                                color: isSavedList![index]
                                    ? Colors.black87
                                    : Colors.black87,
                              ),
                              onPressed: () => _onSavePressed(index),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildUserPhoto(String imagePath) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: BorderRadius.circular(36),
        gradient: const LinearGradient(
          colors: [
            Colors.purple,
            Colors.pink,
            Colors.orange,
            Colors.yellow
          ],
          stops: [0.0, 0.33, 0.66, 1.0],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(36),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }

  designUserName(User? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          user != null
              ? user.name
              : 'Leanne Graham',
          maxLines: 1,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
            overflow: TextOverflow.ellipsis,
            fontFamily: 'OpenSans',
            letterSpacing: 0.6,
            wordSpacing: 1.2,
          ),
        ),

        /* ---------------------- User Details ---------------------- */
        RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: [
              TextSpan(
                text: "${user != null ? user.company.name : "Romaguera-Crona"} • ",
                style: const TextStyle(
                  color: Colors.black54,
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextSpan(
                text: user != null
                    ? user.website
                    : "hildegard.org",
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getShimmerLoading() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 12, top: 12),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: double.infinity,
                        height: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(right: 20, top: 12),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            Container(
              margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: double.infinity,
                  height: 20,
                  color: Colors.white,
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 12, right: 12, top: 8),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 150,
                      height: 14,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
