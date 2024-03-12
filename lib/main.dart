import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:html_unescape/html_unescape.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toolbox',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headline6: TextStyle(
            fontFamily: 'Montserrat', // Fuente personalizada
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87, // Color de texto
          ),
          bodyText1: TextStyle(
            fontFamily: 'Roboto', // Fuente personalizada
            fontSize: 16,
            color: Colors.black87, // Color de texto
          ),
        ),
      ),
      home: ToolboxPage(),
    );
  }
}

class ToolboxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Toolbox'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CircleAvatar(
              radius: 100,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Image.asset(
                  'assets/logo.jpeg',
                  fit: BoxFit.cover,
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              children: [
                ToolCard(
                  icon: Icons.people,
                  label: 'Predict Gender',
                  color: Colors.pink,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PredictGenderPage()),
                    );
                  },
                ),
                ToolCard(
                  icon: Icons.accessibility_new,
                  label: 'Predict Age',
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PredictAgePage()),
                    );
                  },
                ),
                ToolCard(
                  icon: Icons.school,
                  label: 'Universities',
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UniversityListPage()),
                    );
                  },
                ),
                ToolCard(
                  icon: Icons.wb_sunny,
                  label: 'Weather',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WeatherPage()),
                    );
                  },
                ),
                ToolCard(
                  icon: Icons.web,
                  label: 'WordPress News',
                  color: Colors.deepPurple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WordPressNewsPage()),
                    );
                  },
                ),
                ToolCard(
                  icon: Icons.info,
                  label: 'About',
                  color: Colors.teal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutPage()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ToolCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  ToolCard(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(label,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1), // Utilizar el estilo de texto del tema
          ],
        ),
      ),
    );
  }
}

//funcionalidad de genero

class PredictGenderPage extends StatefulWidget {
  @override
  _PredictGenderPageState createState() => _PredictGenderPageState();
}

class _PredictGenderPageState extends State<PredictGenderPage> {
  String? gender;
  TextEditingController _controller = TextEditingController();

  void _getGender() async {
    final response = await http
        .get(Uri.parse('https://api.genderize.io/?name=${_controller.text}'));
    final data = jsonDecode(response.body);
    setState(() {
      gender = data['gender'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Predict Gender'),
        backgroundColor: Color(0xFFB3E5FC), // Azul pastel
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter a name',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _getGender();
              },
              child: Text('Predict'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 246, 169, 190), // Azul pastel
                textStyle: TextStyle(fontSize: 18, color: Colors.white),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
            ),
            SizedBox(height: 20),
            if (gender != null)
              Column(
                children: [
                  Text(
                    gender == 'male' ? 'Male' : 'Female',
                    style: TextStyle(
                      fontSize: 24,
                      color: gender == 'male'
                          ? Color(0xFF2196F3)
                          : Color(0xFFFF4081), // Azul y rosa pastel
                    ),
                  ),
                  SizedBox(height: 10),
                  Icon(
                    gender == 'male'
                        ? Icons.male
                        : Icons.female, // Icono correspondiente al género
                    size: 48, // Tamaño del icono
                    color: gender == 'male'
                        ? Color(0xFF2196F3)
                        : Color(0xFFFF4081), // Azul y rosa pastel
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

//funcionalidad de la predicion edad

class PredictAgePage extends StatefulWidget {
  @override
  _PredictAgePageState createState() => _PredictAgePageState();
}

class _PredictAgePageState extends State<PredictAgePage> {
  String? ageGroup;
  int? age;
  TextEditingController _controller = TextEditingController();

  void _getAge() async {
    final response = await http
        .get(Uri.parse('https://api.agify.io/?name=${_controller.text}'));
    final data = jsonDecode(response.body);
    setState(() {
      age = data['age'];
      if (age != null) {
        if (age! <= 35)
          ageGroup = 'Joven';
        else if (age! <= 60)
          ageGroup = 'Adulto';
        else
          ageGroup = 'Anciano';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Predict Age'),
        backgroundColor: Color.fromARGB(255, 152, 243, 152),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Ingrese un nombre',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _getAge();
              },
              child: Text('Predict'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 251, 206, 109),
                textStyle: TextStyle(fontSize: 18),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
            ),
            SizedBox(height: 20),
            if (ageGroup != null)
              Column(
                children: [
                  Text(
                    'Grupo de Edad:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    ageGroup!,
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  if (age != null)
                    Text(
                      'Edad: $age',
                      style: TextStyle(fontSize: 18),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
//funcionalidad de las universidades

class UniversityListPage extends StatefulWidget {
  @override
  _UniversityListPageState createState() => _UniversityListPageState();
}

class _UniversityListPageState extends State<UniversityListPage> {
  List<dynamic>? universities;
  TextEditingController _countryController = TextEditingController();

  void _getUniversities(String country) async {
    try {
      final response = await http.get(
        Uri.parse('http://universities.hipolabs.com/search?country=$country'),
      );
      if (response.statusCode == 200) {
        setState(() {
          universities = jsonDecode(response.body);
        });
      } else {
        print('Failed to load universities: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching universities: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Universities'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _countryController,
              decoration: InputDecoration(
                labelText: 'Ingrese el nombre de una ciudad en Ingles',
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _getUniversities(_countryController.text.trim());
              },
              child: Text('Search'),
            ),
            SizedBox(height: 20),
            if (universities != null)
              Expanded(
                child: ListView.builder(
                  itemCount: universities!.length,
                  itemBuilder: (context, index) {
                    var university = universities![index];
                    Uri websiteUri = Uri.parse(university['web_pages'].first);
                    String domain = websiteUri.host;
                    return ListTile(
                      title: Text(
                        university['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.purpleAccent, // Color morado pastel
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Website: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            university['web_pages'].first,
                            style: TextStyle(
                              color: Colors.black87, // Color de texto normal
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Domain: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            domain,
                            style: TextStyle(
                              color: Colors.black87, // Color de texto normal
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

//funcionalidad del clima

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Map<String, dynamic>? weatherData;
  bool isLoading = false;

  void _fetchWeatherData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?lat=18.46922&lon=-69.29099&appid=ac67794e75db151d92ef86cae6587cf2'),
      );

      if (response.statusCode == 200) {
        setState(() {
          weatherData = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        print('Error al cargar los datos del clima: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error al obtener los datos del clima: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  IconData _getWeatherIcon(String description) {
    switch (description.toLowerCase()) {
      case 'clear sky':
        return Icons.wb_sunny;
      case 'few clouds':
        return Icons.cloud;
      case 'scattered clouds':
        return Icons.cloud_queue;
      case 'broken clouds':
        return Icons.cloud_done;
      case 'shower rain':
        return Icons.grain;
      case 'rain':
        return Icons.beach_access;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
        return Icons.cloud_circle;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
        backgroundColor: Color(0xFF81D4FA), // Azul pastel
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF81D4FA), Color(0xFFB3E5FC)], // Azul pastel
              ),
            ),
          ),
          Center(
            child: isLoading
                ? CircularProgressIndicator()
                : weatherData != null
                    ? Container(
                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              _getWeatherIcon(
                                  weatherData!['weather'][0]['description']),
                              size: 100,
                              color: Colors.grey[800],
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Weather Information',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Temperature:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${weatherData!['main']['temp']}°C',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Description:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${weatherData!['weather'][0]['description']}',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Humidity:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${weatherData!['main']['humidity']}%',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Text(
                        'No weather data available',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

//funcionalidad de la pag wordPress

class WordpressApi {
  final String apiUrl = "http://fortune.com/wp-json/wp/v2/posts";

  Future<List> fetchPosts() async {
    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List posts = json.decode(response.body);
      // Obtener las imágenes destacadas para cada publicación
      for (var post in posts) {
        post['featured_image_url'] =
            await fetchFeaturedImage(post['featured_media']);
      }
      return posts;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<String> fetchFeaturedImage(int mediaId) async {
    final mediaUrl = "http://fortune.com/wp-json/wp/v2/media/$mediaId";
    var response = await http.get(Uri.parse(mediaUrl));
    if (response.statusCode == 200) {
      var media = json.decode(response.body);
      return media['guid']['rendered'];
    } else {
      throw Exception('Failed to load featured image');
    }
  }
}

class WordPressNewsPage extends StatefulWidget {
  @override
  _WordPressNewsPageState createState() => _WordPressNewsPageState();
}

class _WordPressNewsPageState extends State<WordPressNewsPage> {
  List<dynamic> _newsData = [];
  WordpressApi api = WordpressApi();

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    try {
      final response = await api.fetchPosts();
      setState(() {
        _newsData = response;
      });
    } catch (error) {
      print('Error fetching news: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Noticias'),
      ),
      body: Center(
        child: _newsData.isEmpty
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.jpg',
                      height: 100, // Adjust as needed
                      width: 100, // Adjust as needed
                    ),
                    SizedBox(height: 20),
                    for (var news in _newsData.take(3))
                      NewsItem(
                        title: _removeHtmlTags(news['title']['rendered']),
                        summary: _removeHtmlTags(news['excerpt']['rendered']),
                        link: news['link'],
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  // Método para eliminar etiquetas HTML del texto
  String _removeHtmlTags(String htmlText) {
    final unescape = HtmlUnescape();
    return unescape.convert(htmlText.replaceAll(RegExp(r'<[^>]*>'), ''));
  }
}

class NewsItem extends StatelessWidget {
  final String title;
  final String summary;
  final String link;

  NewsItem({required this.title, required this.summary, required this.link});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              summary,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                _launchURL(link);
              },
              child: Text('Leer Mas'),
            ),
          ],
        ),
      ),
    );
  }
}

void _launchURL(String url) async {
  Uri uri = Uri.parse(url);

  await launchUrl(uri);
}

//acerca de

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: Color(0xFFB3E5FC), // Color azul pastel
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 100, // Tamaño más grande para el avatar
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/foto.jpg'),
            ),
            SizedBox(height: 20),
            Text(
              'Contact Information:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildContactInfo('Nombre', 'Iliana La Paz'),
            _buildContactInfo('Email', 'ilianalapaz77@gmail.com'),
            _buildContactInfo('Phone', '+1849222112'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
