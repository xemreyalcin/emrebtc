import Option "mo:base/Option";
import Map "mo:base/OrderedMap";
import Nat32 "mo:base/Nat32";

actor YemekScoring {
  public type YemekId = Nat32;
  public type Yemek = {
    title : Text;
    author : Text;
    point : Nat32;
  };

  stable var next : YemekId = 0;
  let Ops = Map.Make<YemekId>(Nat32.compare);
  stable var map : Map.Map<YemekId, Yemek> = Ops.empty();

  public func createYemek(yemek : Yemek) : async YemekId {
    let yemekId = next;
    next += 1;
    map := Ops.put(map, yemekId, yemek);
    yemekId
  };

  public query func getYemek(yemekId : YemekId) : async ?Yemek {
    Ops.get(map, yemekId)
  };

  public func updatePoint(yemekId : YemekId, newPoint : Nat32) : async Bool {
    switch (Ops.get(map, yemekId)) {
      case (?yemek) {
        map := Ops.put(map, yemekId, {
          title = yemek.title;
          author = yemek.author;
          point = newPoint
        });
        true
      };
      case null {
        false
      }
    }
  };

  public func delete(yemekId : YemekId) : async Bool {
    let (result, old_value) = Ops.remove(map, yemekId);
    let exists = Option.isSome(old_value);
    if (exists) {
      map := result;
    };
    exists
  }
}
