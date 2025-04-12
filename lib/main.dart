import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interior_design_project/Screens/cart_screen.dart';
import 'package:interior_design_project/Screens/favorite_screen.dart';
import 'package:interior_design_project/Screens/home_screen.dart';
import 'package:interior_design_project/Screens/initial_screen.dart';
import 'package:interior_design_project/Screens/profile_screen.dart';

import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
  DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      initialRoute: '/initial',
      routes: {
        '/initial':(context)=> InitialScreen()
      },
      title: 'Persistent Bottom Nav Bar',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      FavouriteScreen(key: UniqueKey()),
      CartScreen(key: UniqueKey(),),
      const ProfileScreen(),

    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: "Home",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white70,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.favorite_border),
        title: "Favourites",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white70,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.shopping_cart),
        title: "My Cart",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white70,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: "Profile",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white70,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      backgroundColor: Colors.black54,
      items: _navBarsItems(),
      stateManagement: true,
      navBarStyle: NavBarStyle.style1,

      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      onItemSelected: (index) {
        if (index == 1) {
          setState(() {});
        }
        if (index == 2) {
          setState(() {});
        }

      },
    );
  }
}

