import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileBox extends StatefulWidget {
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback onView;
  final int imageID;
  final bool isLikedList;
  final bool isSavedList;


  ProfileBox({
    super.key,
    required this.onLike,
    required this.onSave,
    required this.onView,
    required this.imageID,
    required this.isLikedList,
    required this.isSavedList,
  });

  @override
  State<ProfileBox> createState() => _ProfileBoxState();
}

class _ProfileBoxState extends State<ProfileBox> {
  bool isLiked = false;
  bool isSaved = false;

  final Map<int, String> userImages = {
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
    isLiked = widget.isLikedList;
    isSaved = widget.isSavedList;
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    widget.onLike();
  }

  void toggleSave() {
    setState(() {
      isSaved = !isSaved;
    });
    widget.onSave();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 200,
                  height: 225,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: Image.asset(
                          userImages[widget.imageID] ?? 'assets/images/1.png',
                          fit: BoxFit.cover,
                          width: 200,
                          height: 200,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 60,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(
                          isLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                          color: isLiked ? Colors.red : Colors.grey[600],
                          size: 24,
                        ),
                        onPressed: toggleLike,
                      ),
                      IconButton(
                        icon: Icon(
                          isSaved ? FontAwesomeIcons.solidBookmark : FontAwesomeIcons.bookmark,
                          color: isSaved ? Colors.grey[600] : Colors.grey[600],
                          size: 24,
                        ),
                        onPressed: toggleSave,
                      ),
                      IconButton(
                        icon: Icon(Icons.call_made_rounded,
                            color: Colors.grey[600],
                            size: 28,
                        ),
                        onPressed: widget.onView,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
