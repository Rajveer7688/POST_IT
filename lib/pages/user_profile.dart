import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:post_it/widget/profile_menu.dart';
import 'package:shimmer/shimmer.dart';

import '../models/post.dart';
import '../models/user.dart';
import '../services/remote_service.dart';

class UserProfile extends StatefulWidget {
  final int userID;

  /* --> <-- --> <-- Fetch User ID --> <-- --> <-- */
  const UserProfile({
    super.key,
    required this.userID,
  });

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  List<Post>? posts;
  User? user;
  var isLoaded = false;
  var isPostsLoaded = false;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.grey[300],
          statusBarIconBrightness: Brightness.dark,
        ),
      );
    });
    super.initState();

    getUserPosts();
    fetchUserByFilter();
  }

  void getUserPosts() async {
    posts = await RemoteService().getUserPosts(widget.userID);
    if (posts != null) {
      setState(() {
        isPostsLoaded = true;
      });
    }
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

  void fetchUserByFilter() async {
    User? fetchUser = await RemoteService().getUserById(widget.userID);
    setState(() {
      user = fetchUser;
      isLoaded = true;
    });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        forceMaterialTransparency: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Padding(
              padding: EdgeInsets.only(left: 6),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black45,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: isLoaded ? Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  /* ---------------------- Profile Picture ---------------------- */
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[350],
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              userImages[widget.userID] ?? 'assets/images/1.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /* ---------------------- Profile Information ---------------------- */
                  const SizedBox(height: 4),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      AutoSizeText(
                        "PROFILE INFORMATION",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'OpenSans',
                          fontSize: 14,
                          letterSpacing: 1,
                          wordSpacing: 1.2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                        softWrap: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  ProfileMenu(title: 'Name', value: user != null ? user!.name : 'Leanne Graham', onPressed: true),
                  ProfileMenu(title: 'Username', value: user != null ? user!.username : 'Bret', onPressed: true),
                  ProfileMenu(title: 'Company', value: user != null ? user!.company.name : 'Bret', onPressed: true),

                  /* ---------------------- Personal Information ---------------------- */
                  const SizedBox(height: 4),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Text(
                        "PERSONAL INFORMATION",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'OpenSans',
                          fontSize: 14,
                          letterSpacing: 1,
                          wordSpacing: 1.2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                        softWrap: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  ProfileMenu(title: 'User ID', value: user != null ? (user!.id).toString() : '1', onPressed: true),
                  ProfileMenu(title: 'Email-ID', value: user != null ? user!.email : 'Sincere@april.biz', onPressed: true),
                  ProfileMenu(title: 'Phone', value: user != null ? user!.phone : '1-770-736-8031 x56442', onPressed: true),
                  ProfileMenu(title: 'Website', value: user != null ? user!.website : 'hildegard.org', onPressed: true),
                  ProfileMenu(title: 'City', value: user != null ? user!.address.city : 'Gwenborough', onPressed: true),
                  ProfileMenu(title: 'Pin Code', value: user != null ? user!.address.zipcode : '92998-3874', onPressed: true),
                ],
              ),
            ),

            /* ---------------------- Profile Posts ---------------------- */
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AutoSizeText(
                    "EXPLORE POSTS",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'OpenSans',
                      fontSize: 14,
                      letterSpacing: 1,
                      wordSpacing: 1.2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                    softWrap: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                height: 500,
                child: Visibility(
                  visible: isLoaded,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: ListView.builder(
                    itemCount: posts?.length,
                    itemBuilder: (context, index) {
                      final post = posts![index];
                      String imagePath = userImages[post.userId] ?? 'assets/images/default.png';
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /* --> <-- --> <-- Profile Design --> <-- --> <-- */
                          Row(
                            children: [
                              /* ---------------------- User Photo ---------------------- */
                              Container(
                                height: 50,
                                width: 50,
                                margin: const EdgeInsets.only(left: 20, right: 12, top: 12),
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
                              ),

                              /* ---------------------- User name ---------------------- */
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        user != null
                                            ? user!.name
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
                                              text:
                                              "${user != null ? user!.company.name : "Romaguera-Crona"} • ",
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
                                                  ? user!.website
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
                            margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
                            padding: const EdgeInsets.all(8),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[350],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /* ---------------------- Error Message Handling ---------------------- */
                                  if (post.title.isEmpty || post.body.isEmpty)
                                    const Text(
                                      'Error: No data available',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  else ...[
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
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 15)
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ) : _buildShimmerEffect(),
      )
    );
  }

  Widget _buildShimmerEffect() {
    return Column(
      children: [
        // Profile picture shimmer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[350],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 16,
                  width: 120,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 8),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 16,
                  width: 200,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
            ],
          ),
        ),
        // Personal information shimmer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: List.generate(6, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 16,
                    width: double.infinity,
                    color: Colors.grey[300],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
