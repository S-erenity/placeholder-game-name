//item class

class Item {
  String name;
  String rarity;  
  int    count;

  Item(String name, String rarity) {
    this.name   = name;
    this.rarity = rarity;
    this.count  = 0;
  }
}

class Fragment extends Item {
  color col;

  Fragment(String rarity) {
    super(rarity.equals("rare") ? "Blue Fragment" : "Sword Fragment", rarity);
    this.col = rarity.equals("rare") ? color(80, 140, 255) : color(255, 215, 0);
  }
}
