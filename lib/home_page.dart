import 'package:flutter/material.dart';
import 'stdeditprof.dart';
import '../login2.dart';
import 'advertisement_card.dart';
import 'box_grid_item.dart';
import 'drawer_item.dart';
import 'detail_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final Map<String, IconData> _boxIcons = {
    '1 to 10': Icons.school,
    'Science': Icons.science,
    'Commerce': Icons.store,
    'Arts': Icons.palette,
    'Competitive Exam': Icons.emoji_events,
    'Drawing': Icons.brush,
    'English Spoken': Icons.record_voice_over,
  };

  List<String> _filteredBoxTitles = [];

  @override
  void initState() {
    super.initState();
    _filteredBoxTitles = _boxIcons.keys.toList();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoScroll());
    _searchController.addListener(_onSearchChanged);
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3)).then((_) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % 3;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
        _startAutoScroll();
      }
    });
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterBoxes();
    });
  }

  void _filterBoxes() {
    _filteredBoxTitles = _searchQuery.isEmpty
        ? _boxIcons.keys.toList()
        : _boxIcons.keys
        .where((title) =>
        title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(context),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: const CircleAvatar(
              backgroundColor: Colors.cyan,
              radius: 20,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ),
      ),
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.indigo[50],
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.indigo),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
              icon: Icon(Icons.clear, color: Colors.indigo[400]),
              onPressed: () => _searchController.clear(),
            )
                : null,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.indigo[700]),
          onPressed: () {},
        ),
      ],
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo[50]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.cyan,
                  radius: 30,
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 10),
                Text(
                  'username',
                  style: TextStyle(
                    color: Colors.blueGrey[900],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          buildDrawerItem3(context, 'Edit Profile', Icons.edit),
          buildDrawerItem(context, 'Change Password', Icons.lock),
          buildDrawerItem(context, 'Theme', Icons.color_lens),
          buildDrawerItem(context, 'About Us', Icons.info),
          buildLogoutItem(context, 'Logout', Icons.logout),
        ],
      ),
    );
  }

  Widget buildDrawerItem(
      BuildContext context, String title, IconData icon) {
    return DrawerItem(
      icon: icon,
      title: title,
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(title: title),
          ),
        );
      },
    );
  }

  Widget buildLogoutItem(
      BuildContext context, String title, IconData icon) {
    return DrawerItem(
      icon: icon,
      title: title,
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login2()),
        );
      },
    );
  }

  Widget buildDrawerItem3(
      BuildContext context, String title, IconData icon) {
    return DrawerItem(
      icon: icon,
      title: title,
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserFormPage()),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Slider
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.indigo[100]?.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) =>
                  setState(() => _currentPage = index),
              children: const [
                AdvertisementCard(text: 'Top Rated Tuition Available!'),
                AdvertisementCard(text: 'Join Now and Learn Fast!'),
                AdvertisementCard(text: 'Limited Seats Available!'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Grid Tiles
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1.0,
            ),
            itemCount: _filteredBoxTitles.length,
            itemBuilder: (context, index) {
              final title = _filteredBoxTitles[index];
              final icon = _boxIcons[title]!;
              return BoxGridItem(title: title, icon: icon);
            },
          ),
        ],
      ),
    );
  }
}
