import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

actor {
  type Post = {
    message: Text;
    author: Principal;
  };

  stable var postKey = 0;
  let postList = HashMap.HashMap<Text, Post>(0, Text.equal, Text.hash);

  private func generateKey(): Text {
    postKey += 1;
    return Nat.toText(postKey);
  };
  
  public query (msg) func whoAmI() : async Principal {
    return msg.caller;
  };

  public shared (msg) func createPost(message: Text) {
    let post: Post = { message ; author = msg.caller };
    postList.put(generateKey(), post);
    Debug.print("" # Nat.toText(postKey));
    Debug.print("Post guardado exitosamente!");
  };

  public query func getPost(key: Text): async ?Post{
    return postList.get(key);
  };

  public query func getPosts(): async [(Text, Post)]{
    let postIter = postList.entries();
    return Iter.toArray(postIter);
  };

  public func updatePost(key: Text, message: Text){
    let post = postList.get(key);

    switch(post){
      case(null) {
        Debug.print("Ewe no existe.");
      };
      case(?currentPost){
        let newPost = {message; author = currentPost.author};
        postList.put(key, newPost);
      };
    };
  };

  public func deletePost(key: Text){
    let post = postList.get(key);

    switch(post){
      case(null) {
        Debug.print("Ewe no existe.");
      };
      case(_){
        postList.delete(key);
      };
    };
  };

};
