
class Astronaut {
  String name;
  String craft;

  Astronaut(this.name, this.craft);

  Astronaut.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    craft = json['craft'];
  }
}