using Firebase;
using Firebase.Extensions;
using UnityEngine;

public class FirebaseInit : MonoBehaviour {
    public void Initializer() {
        FirebaseApp.CheckAndFixDependenciesAsync().ContinueWithOnMainThread(task => {
            if (task.Result == DependencyStatus.Available) {
                Debug.Log("Firebase is ready.");
                // Now you can use Firestore
            }
            else {
                Debug.LogError("Could not resolve all Firebase dependencies: " + task.Result);
            }
        });
    }
}
