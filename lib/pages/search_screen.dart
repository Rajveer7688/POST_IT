import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:post_it/pages/user_profile.dart';
import 'package:post_it/services/remote_service.dart';

import '../models/user.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  User? user;
  var isLoaded = false;
  final TextEditingController _controller = TextEditingController();

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

  Map<int, String> userRating = {
    1: '4.5',
    2: '4.8',
    3: '3.2',
    4: '4.9',
    5: '5.0',
    6: '4.6',
    7: '4.2',
    8: '4.7',
    9: '3.8',
    10: '3.4',
  };

  // Suggested user name list
  final List<String> usernames = [
    'Leanne Graham',
    'Ervin Howell',
    'Clementine Bauch',
    'Patricia Lebsack',
    'Chelsey Dietrich',
    'Mrs. Dennis Schulist',
    'Kurtis Weissnat',
    'Nicholas Runolfsdottir V',
    'Glenna Reichert',
    'Clementina DuBuque',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.grey[300],
          statusBarIconBrightness: Brightness.dark,
        ),
      );
    });

    _controller.addListener(() {
      setState(() {});
    });
  }

  void fetchUserByFilter(int value) async {
    User? fetchUser = await RemoteService().getUserById(value);
    setState(() {
      user = fetchUser;
      isLoaded = true;
    });
    }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

      /* ---------------------- App Bar ---------------------- */
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        forceMaterialTransparency: true,
        toolbarHeight: 0,
      ),

      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /* ---------------------- Back Button ---------------------- */
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black45,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

              /* --> <-- --> <-- Search View --> <-- --> <-- */
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 3, top: 12, right: 20, bottom: 12),
                  child: TextField(
                    controller: _controller,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          isLoaded = false;
                          user = null;
                        });
                      } else {
                        int? intValue = int.tryParse(value);
                        if (intValue != null) {
                          fetchUserByFilter(intValue);
                        }
                      }
                    },
                    cursorColor: Colors.grey,
                    maxLines: 1,
                    autocorrect: true,
                    cursorErrorColor: Colors.red,
                    cursorHeight: 20.0,
                    enabled: true,
                    cursorRadius: const Radius.circular(5),
                    enableSuggestions: true,
                    cursorOpacityAnimates: true,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      color: Colors.black,
                      height: 1,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: "Search by User ID",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w300,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.0,
                          style: BorderStyle.solid,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 1,
                          style: BorderStyle.solid,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.0,
                          style: BorderStyle.solid,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      prefixIcon: const Icon(Icons.search_rounded),
                      prefixIconColor: Colors.grey,
                      errorMaxLines: 1,
                      suffixIcon: _controller.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear_rounded,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                _controller.clear();
                                setState(() {
                                  isLoaded = false;
                                  user = null;
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          /* --> <-- --> <-- Filter Options for User --> <-- --> <-- */
          const Padding(
            padding: EdgeInsets.only(left: 12, top: 20),
            child: Row(
              children: [
                Text(
                  "SUGGESTIONS",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    letterSpacing: 0.8,
                    wordSpacing: 1.2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                  softWrap: true,
                ),
              ],
            ),
          ),

          /* ---------------------- Search Suggestions ---------------------- */
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Wrap(
              spacing: 8,
              runSpacing: 12,
              children: usernames
                  .asMap()
                  .entries
                  .map((username) =>
                      _buildUserButton(username.value, (username.key + 1)))
                  .toList(),
            ),
          ),

          /* ---------------------- Divider Line ---------------------- */
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey[400],
                    thickness: 1,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: AutoSizeText(
                    'CONTENT CREATORS HUB',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w100,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey[400],
                    thickness: 1,
                  ),
                ),
              ],
            ),
          ),

          /* --> <-- --> <-- Filter List --> <-- --> <-- */
          Expanded(
            child: Visibility(
              visible: isLoaded,
              child: user != null
                  ? ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserProfile(
                                          userID : user!.id
                                      )
                                  )
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[350],
                                borderRadius: BorderRadius.circular(12),
                                shape: BoxShape.rectangle,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  /* ---------------------- User Photo ---------------------- */
                                  Container(
                                    height: 50,
                                    width: 50,
                                    margin: const EdgeInsets.all(12),
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
                                          userImages[user!.id] ?? 'assets/images/1.png',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                                    ),
                                  ),

                                  /* ---------------------- User Details ---------------------- */
                                  Expanded(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                            user!.name,
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'OpenSans',
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          RichText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: user!.company.name,
                                                  style: const TextStyle(color: Colors.black54),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  /* ---------------------- Star Icon and Rating ---------------------- */
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          userRating[user!.id] ?? '4.8',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text("No user found."),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /* ---------------------- Reusable User Button for Search Suggestions ---------------------- */
  Widget _buildUserButton(String username, int index) {
    return GestureDetector(
      onTap: () {
        _controller.text = index.toString();
        fetchUserByFilter(index);
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Colors.transparent,
          border: Border.all(
            color: Colors.grey.shade400,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: AutoSizeText(
            username,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
