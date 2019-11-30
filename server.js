var admin = require("firebase-admin");

var serviceAccount = require("./secret.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://elm-auth-352f2.firebaseio.com"
});


const idToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjRhOWEzMGI5ZThkYTMxNjY2YTY3NTRkZWZlZDQxNzQzZjJlN2FlZWEiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vZWxtLWF1dGgtMzUyZjIiLCJhdWQiOiJlbG0tYXV0aC0zNTJmMiIsImF1dGhfdGltZSI6MTU3NTExMzYzNSwidXNlcl9pZCI6ImE4aXFlZ3NkSXVjUHoxM1A3REFSUklnblZKejEiLCJzdWIiOiJhOGlxZWdzZEl1Y1B6MTNQN0RBUlJJZ25WSnoxIiwiaWF0IjoxNTc1MTEzNjM1LCJleHAiOjE1NzUxMTcyMzUsImVtYWlsIjoicGVlcmFzb3JuMTRAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZW1haWwiOlsicGVlcmFzb3JuMTRAZ21haWwuY29tIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.mAWE4Q_uiRev1IicimviedS3sOPYpJyhWGHcTk6zz9cTrlNHz3PswOLs_CgLjMNa8h5tD3HLs_OXAZlDJrTKVXGmFFLGVFPXUBvOl20rlbdSZbiwjpK0b5CSilGvCWnnvz9SQvWvSDNiYGPnaEcYEsdFcc7FOewYDZJZO6yp8T1hbQhO5NR5rdpBrEFBbtNwoPYj7XRBsJGQWOGdQDA6VvPaexw1Y-WC6zK5HA7b62MhwuSeR0IC-s0Bffbxfn1bN319_ACuXwwalP8wONTT_GHRg5Fp-IR_U5uslvym5oQEiWDpSYnnB-xTc5nWoz-Bu9oKgi2YBXENoTikh3EHdQ"
admin.auth().verifyIdToken(idToken)
  .then(function(decodedToken) {
    let uid = decodedToken.uid;
    // ...
    console.log(decodedToken)
    console.log(uid)
  }).catch(function(error) {
    console.log(`Error ${error}`)
  });