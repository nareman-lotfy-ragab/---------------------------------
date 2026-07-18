// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geolocator/geolocator.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/widgets/custom_card.dart';
// import '../bloc/weather_bloc.dart';
// import '../../data/datasources/weather_datasource.dart';
// import '../../data/models/weather_model.dart';
// import 'my_fields_page.dart';
// import 'reports_page.dart';
// import '../../../ai_chat/presentation/pages/ai_chat_page.dart';
// import '../../../plant_disease/presentation/pages/plant_disease_page.dart';
// import '../../../articles/presentation/bloc/article_bloc.dart';
// import '../../../articles/presentation/bloc/article_event.dart';
// import '../../../articles/presentation/bloc/article_state.dart';
// import '../../../articles/data/datasources/article_datasource.dart';
// import '../../../articles/data/models/article_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late WeatherBloc _weatherBloc;
//   late ArticleBloc _articleBloc;
//   String _locationName = 'Fetching location...';
//   String _userName = 'User';
//   @override
//   void initState() {
//     super.initState();
//     _loadUserName();
//     _weatherBloc = WeatherBloc(weatherDatasource: WeatherDatasource());
//     _articleBloc = ArticleBloc(articleDatasource: ArticleDatasource())..add(FetchArticlesEvent());
//     _getCurrentLocation();
//   }

//   Future<void> _loadUserName() async {
//   final prefs = await SharedPreferences.getInstance();

//   setState(() {
//     _userName =
//         prefs.getString('user_name') ?? 'User';
//   });
// }


//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       setState(() => _locationName = 'Location disabled');
//       _weatherBloc.add(const FetchWeatherEvent(latitude: 30.0444, longitude: 31.2357));
//       return;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         setState(() => _locationName = 'Permission denied');
//         _weatherBloc.add(const FetchWeatherEvent(latitude: 30.0444, longitude: 31.2357));
//         return;
//       }
//     }

//     try {
//       Position position = await Geolocator.getCurrentPosition();
//       setState(() => _locationName = 'Current Location');
//       _weatherBloc.add(FetchWeatherEvent(
//         latitude: position.latitude,
//         longitude: position.longitude,
//       ));
//     } catch (e) {
//       setState(() => _locationName = 'Error fetching location');
//       _weatherBloc.add(const FetchWeatherEvent(latitude: 30.0444, longitude: 31.2357));
//     }
//   }

//   @override
//   void dispose() {
//     _weatherBloc.close();
//     _articleBloc.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<WeatherBloc>.value(value: _weatherBloc),
//         BlocProvider<ArticleBloc>.value(value: _articleBloc),
//       ],
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildTopSection(context),
//                 Padding(
//                   padding: const EdgeInsets.all(24.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildMyFieldsButton(context),
//                       const SizedBox(height: 12),
//                       _buildReportsButton(context),
//                       const SizedBox(height: 24),
//                       _buildFeatureGrid(context),
//                       const SizedBox(height: 32),
//                       _buildArticlesSection(context),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTopSection(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage('assets/images/WhatsApp Image 2026-05-01 at 2.35.59 AM.jpeg'),
//           fit: BoxFit.cover,
//         ),
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(40),
//           bottomRight: Radius.circular(40),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Welcome back,',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     _userName,
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.9),
//                       fontSize: 18,
//                     ),
//                   ),
//                 ],
//               ),
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.settings, color: Colors.white, size: 24),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),
//           BlocBuilder<WeatherBloc, WeatherState>(
//   builder: (context, state) {
//     if (state is WeatherLoaded) {
//       return _buildWeatherCard(
//         context,
//         state.weather,
//       );
//     }
//     return const SizedBox.shrink();
//   },
// ),
//         ],
//       ),
//     );
//   }

//   Widget _buildWeatherCard(BuildContext context, WeatherModel weather) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Row(
//                 children: [
//                   Icon(Icons.cloud_outlined, color: Colors.white, size: 20),
//                   SizedBox(width: 8),
//                   Text('Current Weather', style: TextStyle(color: Colors.white)),
//                 ],
//               ),
//               Text(_locationName, style: const TextStyle(color: Colors.white, fontSize: 12)),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 '${weather.temperature.round()}°C',
//                 style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
//               ),
//               Text(weather.description, style: const TextStyle(color: Colors.white)),
//             ],
//           ),

//           const SizedBox(height: 20),

// Divider(
//   color: Colors.white.withOpacity(0.2),
// ),

// const SizedBox(height: 16),

// Row(
//   mainAxisAlignment:
//       MainAxisAlignment.spaceAround,
//   children:
//       weather.dailyForecast.take(5).map((day) {

//     final date = DateTime.fromMillisecondsSinceEpoch(
//       day.dt * 1000,
//     );

//     final weekDay = [
//       'Mon',
//       'Tue',
//       'Wed',
//       'Thu',
//       'Fri',
//       'Sat',
//       'Sun'
//     ][date.weekday - 1];

//     return Column(
//       children: [
//         Text(
//           weekDay,
//           style: const TextStyle(
//             color: Colors.white70,
//             fontSize: 14,
//           ),
//         ),

//         const SizedBox(height: 8),

//         Text(
//           '${day.tempMax.round()}°',
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }).toList(),
// ),

//         ],
//       ),
//     );
//   }

//   Widget _buildMyFieldsButton(BuildContext context) {
//     return OutlinedButton(
//       onPressed: () => Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const MyFieldsPage()),
//       ),
//       style: OutlinedButton.styleFrom(
//         foregroundColor: AppColors.primaryGreen,
//         side: const BorderSide(color: AppColors.primaryGreen),
//         minimumSize: const Size(double.infinity, 56),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       ),
//       child: const Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.landscape),
//           SizedBox(width: 8),
//           Text('My Fields', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }

//   Widget _buildReportsButton(BuildContext context) {
//     return OutlinedButton(
//       onPressed: () => Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const ReportsPage()),
//       ),
//       style: OutlinedButton.styleFrom(
//         foregroundColor: AppColors.primaryBlue,
//         side: const BorderSide(color: AppColors.primaryBlue),
//         minimumSize: const Size(double.infinity, 56),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       ),
//       child: const Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.description_outlined),
//           SizedBox(width: 8),
//           Text('Reports History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }

//   Widget _buildFeatureGrid(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildFeatureItem(
//             context,
//             'AI Chat',
//             Icons.chat_bubble_outline,
//             AppColors.primaryBlue,
//             () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AIChatPage())),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: _buildFeatureItem(
//             context,
//             'Disease',
//             Icons.eco_outlined,
//             AppColors.primaryPurple,
//             () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PlantDiseasePage())),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildFeatureItem(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: CustomCard(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Icon(icon, color: color, size: 32),
//             const SizedBox(height: 8),
//             Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildArticlesSection(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Agricultural Articles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 16),
//         BlocBuilder<ArticleBloc, ArticleState>(
//           builder: (context, state) {
//             if (state is ArticleLoaded) {
//               return SizedBox(
//                 height: 200,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: state.articles.length,
//                   itemBuilder: (context, index) => _buildArticleCard(state.articles[index]),
//                 ),
//               );
//             }
//             return const Center(child: CircularProgressIndicator());
//           },
//         ),
//       ],
//     );
//   }





//   Widget _buildArticleCard(ArticleModel article) {
//     return Container(
//       width: 280,
//       margin: const EdgeInsets.only(right: 16),
//       child: CustomCard(
//         padding: EdgeInsets.zero,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//               child: Image.network(article.imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:agri_sense_ai/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../bloc/weather_bloc.dart';
import '../../data/datasources/weather_datasource.dart';
import '../../data/models/weather_model.dart';
import 'my_fields_page.dart';
import 'reports_page.dart';
// import 'fertilization_plan_page.dart';
import '../../../ai_chat/presentation/pages/ai_chat_page.dart';
import '../../../plant_disease/presentation/pages/plant_disease_page.dart';
import '../../../articles/presentation/bloc/article_bloc.dart';
import '../../../articles/presentation/bloc/article_event.dart';
import '../../../articles/presentation/bloc/article_state.dart';
import '../../../articles/data/datasources/article_datasource.dart';
import '../../../articles/data/models/article_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late WeatherBloc _weatherBloc;
  late ArticleBloc _articleBloc;
  String _locationName = 'Fetching location...';
  String _userName = 'User';
  @override
  void initState() {
    super.initState();
    _loadUserName();
    _weatherBloc = WeatherBloc(weatherDatasource: WeatherDatasource());
    _articleBloc = ArticleBloc(articleDatasource: ArticleDatasource())..add(FetchArticlesEvent());
    _getCurrentLocation();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    setState(() {
      _userName = prefs.getString('user_name') ?? 'User';
    });
  }


  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!mounted) return;

    if (!serviceEnabled) {
      setState(() => _locationName = 'Location disabled');
      _weatherBloc.add(const FetchWeatherEvent(latitude: 30.0444, longitude: 31.2357));
      return;
    }

    permission = await Geolocator.checkPermission();
    if (!mounted) return;

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (!mounted) return;

      if (permission == LocationPermission.denied) {
        setState(() => _locationName = 'Permission denied');
        _weatherBloc.add(const FetchWeatherEvent(latitude: 30.0444, longitude: 31.2357));
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      if (!mounted) return;

      setState(() => _locationName = 'Current Location');
      _weatherBloc.add(FetchWeatherEvent(
        latitude: position.latitude,
        longitude: position.longitude,
      ));
    } catch (e) {
      if (!mounted) return;

      setState(() => _locationName = 'Error fetching location');
      _weatherBloc.add(const FetchWeatherEvent(latitude: 30.0444, longitude: 31.2357));
    }
  }

  @override
  void dispose() {
    _weatherBloc.close();
    _articleBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WeatherBloc>.value(value: _weatherBloc),
        BlocProvider<ArticleBloc>.value(value: _articleBloc),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopSection(context),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMyFieldsButton(context),
                      const SizedBox(height: 12),
                      _buildReportsButton(context),
                      const SizedBox(height: 12),
                      // _buildFertilizationButton(context),
                      const SizedBox(height: 24),
                      _buildFeatureGrid(context),
                      const SizedBox(height: 32),
                      _buildArticlesSection(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/WhatsApp Image 2026-05-01 at 2.35.59 AM.jpeg'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back,',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _userName,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfilePage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          BlocBuilder<WeatherBloc, WeatherState>(
  builder: (context, state) {
    if (state is WeatherLoaded) {
      return _buildWeatherCard(
        context,
        state.weather,
      );
    }
    return const SizedBox.shrink();
  },
),
        ],
      ),
    );
  }

  Widget _buildWeatherCard(BuildContext context, WeatherModel weather) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.cloud_outlined, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Current Weather', style: TextStyle(color: Colors.white)),
                ],
              ),
              Text(_locationName, style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${weather.temperature.round()}°C',
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text(weather.description, style: const TextStyle(color: Colors.white)),
            ],
          ),

          const SizedBox(height: 20),

Divider(
  color: Colors.white.withOpacity(0.2),
),

const SizedBox(height: 16),

Row(
  mainAxisAlignment:
      MainAxisAlignment.spaceAround,
  children:
      weather.dailyForecast.take(5).map((day) {

    final date = DateTime.fromMillisecondsSinceEpoch(
      day.dt * 1000,
    );

    final weekDay = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun'
    ][date.weekday - 1];

    return Column(
      children: [
        Text(
          weekDay,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          '${day.tempMax.round()}°',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }).toList(),
),

        ],
      ),
    );
  }

  Widget _buildMyFieldsButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyFieldsPage()),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryGreen,
        side: const BorderSide(color: AppColors.primaryGreen),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.landscape),
          SizedBox(width: 8),
          Text('My Fields', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildReportsButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ReportsPage()),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryBlue,
        side: const BorderSide(color: AppColors.primaryBlue),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description_outlined),
          SizedBox(width: 8),
          Text('Reports History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Widget _buildFertilizationButton(BuildContext context) {
  //   return OutlinedButton(
  //     onPressed: () => Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => const FertilizationPlanPage()),
  //     ),
  //     style: OutlinedButton.styleFrom(
  //       foregroundColor: Colors.orange,
  //       side: const BorderSide(color: Colors.orange),
  //       minimumSize: const Size(double.infinity, 56),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //     ),
  //     child: const Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(Icons.auto_awesome),
  //         SizedBox(width: 8),
  //         Text('Smart Fertilization Plan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildFeatureGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildFeatureItem(
            context,
            'AI Chat',
            Icons.chat_bubble_outline,
            AppColors.primaryBlue,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AIChatPage())),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildFeatureItem(
            context,
            'Disease',
            Icons.eco_outlined,
            AppColors.primaryPurple,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PlantDiseasePage())),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CustomCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildArticlesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Agricultural Articles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        BlocBuilder<ArticleBloc, ArticleState>(
          builder: (context, state) {
            if (state is ArticleLoaded) {
              return SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.articles.length,
                  itemBuilder: (context, index) => _buildArticleCard(state.articles[index]),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }

  Widget _buildArticleCard(ArticleModel article) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: CustomCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(article.imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
