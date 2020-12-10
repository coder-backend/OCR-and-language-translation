firebase.auth().onAuthStateChanged((user)=>{
    if (user) {
    //   User is signed in.
        let user = firebase.auth().currentUser;
        let uid
        if(user != null){
            uid = user.uid;
        }
        let firebaseRefKey = firebase.database().ref().child(uid);
        firebaseRefKey.on('value', (dataSnapShot)=>{
            document.getElementById("userPfFullName").innerHTML = dataSnapShot.val().userFullName;
            document.getElementById("userplace").innerHTML = dataSnapShot.val().userplace;
             userEmail = dataSnapShot.val().userEmail;
             alert(userEmail);
            // userPassword = dataSnapShot.val().userPassword;
            document.getElementById("usercollege").innerHTML = dataSnapShot.val().usercollege;
        })
    } else {
    //   No user is signed in.
    }
});