import 'dart:convert';
import 'package:battleships/views/game_play.dart';
import 'package:battleships/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/sessionmanager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> games = [];
  bool showCompletedGames = false;
  String username = '';
  late Future<List<Map<String, dynamic>>> gamesFuture;

  @override
  void initState() {
    super.initState();
    gamesFuture = fetchAndFilterGames();
    _loadUsername();
    _checkAccessToken();
  }

  Future<void> _checkAccessToken() async {
    final accessToken = await SessionManager.getSessionToken();
    final response = await http.get(
      Uri.parse('http://165.227.117.48/games'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode != 200) {
      SessionManager.clearSession();
      logout();
    }
  }

  Future<void> _loadUsername() async {
    final loadedUsername = await SessionManager.getUsername();
    setState(() {
      username = loadedUsername;
    });
  }

  Future<List<Map<String, dynamic>>> fetchAndFilterGames() async {
    final accessToken = await SessionManager.getSessionToken();
    final response = await http.get(
      Uri.parse('http://165.227.117.48/games'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final gamesJson = jsonDecode(response.body)['games'];
      if (gamesJson is List) {
        final filteredGames = gamesJson
            .where((game) => showCompletedGames
                ? game['status'] == 1 || game['status'] == 2
                : game['status'] == 0 || game['status'] == 3)
            .toList();
        setState(() => games = List<Map<String, dynamic>>.from(filteredGames));
        return List<Map<String, dynamic>>.from(filteredGames);
      }
    } else if (response.statusCode == 401) {
      final responseBodyLog = jsonDecode(response.body);
      if (responseBodyLog['message'] == "Token expired") {
        logout();
      }
    }
    return [];
  }

  Future<void> _delete(int gameId, int index) async {
    final accessToken = await SessionManager.getSessionToken();
    if (games[index]['status'] != 1) {
      final response = await http.delete(
        Uri.parse('http://165.227.117.48/games/$gameId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        if (!mounted) return;
        showSnackBar('Game forfeited');
        final filteredGames = await fetchAndFilterGames();
        setState(() => games = List<Map<String, dynamic>>.from(filteredGames));
      } else if (response.statusCode == 401) {
        final responseBodyLog = jsonDecode(response.body);
        if (responseBodyLog['message'] == "Token expired") {
          logout();
        }
      }
    }
  }

  Future<void> _newGame(String? ai) async {
    final accessToken = await SessionManager.getSessionToken();
    if (!mounted) return;
    final ships = await Navigator.of(context).push<List<String>>(
      MaterialPageRoute(
        builder: (context) => const GamePage(gameId: 0, isNewGame: true),
      ),
    );

    if (ships!.length == 5) {
      final requestBody = {'ships': ships, 'ai': ai};
      final response = await http.post(
        Uri.parse('http://165.227.117.48/games'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        showCompletedGames = false;
        await fetchAndFilterGames();
        if (!mounted) return;
        Navigator.pop(context);
      } else if (response.statusCode == 401) {
        final responseBodyLog = jsonDecode(response.body);
        if (responseBodyLog['message'] == "Token expired") {
          logout();
        }
      }
    }
  }

  String _buildTitle(Map<String, dynamic> game) {
    if (game['status'] == 0) {
      return '#${game['id']} Waiting for opponent';
    } else {
      return '#${game['id']} ${game['player1']} vs ${game['player2']}';
    }
  }

  Widget _optionsDialog(String title, VoidCallback onTap) {
    return InkWell(
      onHover: (value) {
        setState(() {});
      },
      onTap: () {
        onTap();
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [Text(title)]),
      ),
    );
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void logout() async {
    await SessionManager.clearSession();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _navigateToGameView(int gameId) async {
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GamePage(gameId: gameId, isNewGame: false),
      ),
    );
    await fetchAndFilterGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Battleships'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchAndFilterGames,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Battleships',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Logged in as $username',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('New game'),
              onTap: () {
                _newGame('');
              },
            ),
            ListTile(
              leading: const Icon(Icons.computer),
              title: const Text('New game (AI)'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Which AI do you want to play against?',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            _optionsDialog('Random', () => _newGame('random')),
                            const SizedBox(height: 16.0),
                            _optionsDialog(
                                'Perfect', () => _newGame('perfect')),
                            const SizedBox(height: 16.0),
                            _optionsDialog(
                                'One ship (A1)', () => _newGame('oneship'))
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu),
              title: showCompletedGames
                  ? const Text('Show active games')
                  : const Text('Show completed games'),
              onTap: () {
                setState(() {
                  showCompletedGames = !showCompletedGames;
                });
                fetchAndFilterGames();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Log out'),
              onTap: () {
                logout();
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: gamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];

                return (game['status'] == 0 || game['status'] == 3)
                    ? Dismissible(
                        key: Key(game['id'].toString()),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          child: const Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        confirmDismiss: (direction) async => true,
                        onDismissed: (direction) async {
                          await _delete(game['id'], index);
                          await fetchAndFilterGames();
                          showSnackBar('Game forfeited');
                        },
                        child: ListTile(
                          title: Text(_buildTitle(game)),
                          trailing: Text((game['status'] == 3
                              ? ((game['player${game['turn']}']) == username
                                  ? 'myTurn'
                                  : "opponentTurn")
                              : 'matchmaking')),
                          onTap: () {
                            _navigateToGameView(game['id']);
                          },
                        ),
                      )
                    : ListTile(
                        title: Text(_buildTitle(game)),
                        trailing: Text(
                          (game['status'] == 1 &&
                                      game['player1'] == username) ||
                                  (game['status'] == 2 &&
                                      game['player2'] == username)
                              ? 'gameWon'
                              : 'gameLost',
                        ),
                        onTap: () {
                          _navigateToGameView(game['id']);
                        },
                      );
              },
            );
          }
        },
      ),
    );
  }
}
