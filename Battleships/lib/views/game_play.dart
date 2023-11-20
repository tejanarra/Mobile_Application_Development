import 'dart:convert';
import 'package:battleships/utils/sessionmanager.dart';
import 'package:battleships/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GamePage extends StatefulWidget {
  final int gameId;
  final bool isNewGame;

  const GamePage({
    Key? key,
    required this.gameId,
    required this.isNewGame,
  }) : super(key: key);

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  List<String> selected = [];
  List<String> ships = [];
  List<String> wrecks = [];
  List<String> shots = [];
  List<String> sunk = [];
  List<String> rowNames = ['A', 'B', 'C', 'D', 'E', 'F'];
  bool isGameOver = false;
  String? hovered;

  @override
  void initState() {
    super.initState();
    fetchGame();
    _checkAccessToken();
  }

  Future<void> _checkAccessToken() async {
    final accessToken = await SessionManager.getSessionToken();
    final response = await http.get(
      Uri.parse('http://165.227.117.48/games'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return;
    } else {
      SessionManager.clearSession();
      logout();
    }
  }

  Future<void> fetchGame() async {
    final String accessToken = await SessionManager.getSessionToken();
    final response = await http.get(
      Uri.parse('http://165.227.117.48/games/${widget.gameId}'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['status'] != 3) {
        isGameOver = true;
      }
      setState(() {
        ships = List<String>.from(responseBody['ships']);
        wrecks = List<String>.from(responseBody['wrecks']);
        shots = List<String>.from(responseBody['shots']);
        sunk = List<String>.from(responseBody['sunk']);
      });
    } else if (response.statusCode == 401) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['message'] == "Token expired") {
        logout();
      }
    }
  }

  void logout() async {
    await SessionManager.clearSession();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNewGame ? 'Place ships' : 'Play game'),
      ),
      body: Column(
        children: [
          Expanded(
            child: gameView(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                if (widget.isNewGame) {
                  if (selected.length < 5) {
                    showSnackBar('You must place five ships');
                  } else {
                    Navigator.of(context).pop(selected);
                  }
                } else {
                  if (isGameOver) {
                    return;
                  }
                  handleShotSubmission();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isGameOver ? Colors.grey : null,
              ),
              child: const Text('Submit'),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void handleShotSubmission() async {
    String selectedPosition = selected.first;
    final accessToken = await SessionManager.getSessionToken();
    Map<String, String> requestBody = {'shot': selectedPosition};
    final response = await http.put(
      Uri.parse('http://165.227.117.48/games/${widget.gameId}'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['message'] == 'Shot played successfully') {
        bool sunkShip = responseBody['sunk_ship'] ?? false;

        setState(() {
          shots.add(selectedPosition);
          if (sunkShip) {
            sunk.add(selectedPosition);
            showSnackBar('Ship sunk!');
            if (responseBody['won'] == true) {
              showGameOverDialog();
            }
          } else {
            showSnackBar('No enemy ship hit');
          }
        });
      }
    } else if (response.statusCode == 400) {
      if (!mounted) return;
      showSnackBar('Shot already played');
    }
    fetchGame();
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game over'),
          content: const Text('You won!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget gameView() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double maxWidth = (height > 800 && width < 700)
        ? 800
        : (height < 800 && width > 350)
            ? 400
            : 700;
    return Center(
      child: Container(
        alignment: Alignment.center,
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            childAspectRatio: 1.0,
          ),
          itemCount: 36,
          itemBuilder: (context, index) {
            int row = index ~/ 6;
            int col = index % 6;
            if (row == 0 || col == 0) {
              return Container(
                color: Colors.white,
                child: Center(
                  child: Text(
                    col == 0
                        ? (row == 0 ? '' : String.fromCharCode(row + 64))
                        : '$col',
                  ),
                ),
              );
            } else {
              String cellId = '${rowNames[row - 1]}$col';
              bool isShipPlaced = ships.contains(cellId);

              return MouseRegion(
                onEnter: (_) {
                  setState(() {
                    if (!selected.contains(cellId)) {
                      hovered = cellId;
                    }
                  });
                },
                onExit: (_) {
                  setState(() {
                    hovered = null;
                  });
                },
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (widget.isNewGame) {
                        if (selected.contains(cellId)) {
                          selected.remove(cellId);
                        } else if (selected.length < 5) {
                          selected.add(cellId);
                        }
                      } else {
                        if (!shots.contains(cellId)) {
                          if (selected.contains(cellId)) {
                            selected.remove(cellId);
                          } else if (selected.length < 2) {
                            selected.clear();
                            selected.add(cellId);
                          }
                        }
                      }
                    });
                  },
                  child: Container(
                    color: widget.isNewGame
                        ? (selected.contains(cellId)
                            ? Colors.blue[200]
                            : (hovered == cellId)
                                ? Colors.green[100]
                                : Colors.white)
                        : (selected.contains(cellId)
                            ? Colors.red[200]
                            : (hovered == cellId)
                                ? Colors.red[100]
                                : Colors.white),
                    child: Center(
                      child: getCellContent(cellId, isShipPlaced),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget getCellContent(String position, bool isShipPlaced) {
    bool isShotByYou = shots.contains(position);
    bool isYourShip = ships.contains(position);
    bool isSunk = sunk.contains(position);
    bool isWrecked = wrecks.contains(position);

    if (isWrecked && isSunk) {
      return _buildContent('🫧', '💥');
    } else if (isYourShip && isSunk) {
      return _buildContent('🚢', '💥');
    } else if (isYourShip && isShotByYou) {
      return _buildContent('🚢', '💣');
    } else if (isWrecked && isShotByYou) {
      return _buildContent('🫧', '💣');
    } else if (isSunk) {
      return _buildContent('', '💥');
    } else if (isYourShip) {
      return _buildContent('🚢', '');
    } else if (isWrecked) {
      return _buildContent('🫧', '');
    } else if (isShotByYou) {
      return _buildContent('', '💣');
    } else {
      return const Text('');
    }
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buildContent(String leftEmoji, String rightEmoji) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leftEmoji.isNotEmpty)
          Text(leftEmoji, style: const TextStyle(fontSize: 20)),
        if (leftEmoji.isNotEmpty && rightEmoji.isNotEmpty)
          const SizedBox(width: 4),
        if (rightEmoji.isNotEmpty)
          Text(rightEmoji, style: const TextStyle(fontSize: 20)),
      ],
    );
  }
}
