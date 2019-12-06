import { Elm } from './Main.elm'

var app = Elm.Main.init({ node: document.querySelector('main') })

var firebaseConfig = {
  apiKey: "AIzaSyDp5HhaDZjMJL0MnsZMgi7oo8M53iuyNfg",
  authDomain: "elm-auth-352f2.firebaseapp.com",
  databaseURL: "https://elm-auth-352f2.firebaseio.com",
  projectId: "elm-auth-352f2",
  storageBucket: "elm-auth-352f2.appspot.com",
  messagingSenderId: "221299659004",
  appId: "1:221299659004:web:475affd9888bee6eb1c779",
  measurementId: "G-6LQN6Y5VNX"
};
// Initialize Firebase
firebase.initializeApp(firebaseConfig);
firebase.analytics();


app.ports.isLogin.subscribe(function () {
  const isLogin = firebase.auth().isSignInWithEmailLink(window.location.href)
  console.log('isLogin?', isLogin)
  app.ports.checkLogin.send(isLogin)
})


app.ports.signInWithEmail.subscribe(function () {
  const email = window.localStorage.getItem('emailForSignIn');
  firebase.auth().signInWithEmailLink(email, window.location.href)
    .then(function (result) {
      // result : object of user information
      firebase.auth().currentUser.getIdToken()
        .then(function (token) {
          app.ports.loginSuccess.send(token)
        });
      // window.localStorage.removeItem('emailForSignIn');
    })
    .catch(function (error) {
      console.log(`Error ${error}`)
    });
})


app.ports.sendLoginLink.subscribe(function (email) {
  var actionCodeSettings = {
    url: "http://localhost:1234",
    handleCodeInApp: true
  };

  firebase.auth()
    .sendSignInLinkToEmail(email, actionCodeSettings)
    .then(function () {
      window.localStorage.setItem('emailForSignIn', email);
    })
    .catch(function (error) {
      console.log(`Error ${error}`)
    });
});