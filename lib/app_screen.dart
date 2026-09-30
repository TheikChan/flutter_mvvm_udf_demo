sealed class AppScreen {}

class Home extends AppScreen { }

class AlertMessage extends AppScreen {
  final String message;
  AlertMessage(this.message);
}