const functions = require('firebase-functions');
const admin = require('firebase-admin');
let recipientUid= String("");

admin.initializeApp();

exports.newOnlineCallOrder = functions.firestore
.document('messages/{sender}') 
.onCreate((snap, context) => {
const data = snap.data();
recipientUid = data.recipientUid;



// Notification content
const payload = {
notification: {
title: data.senderName,
body: data.text.substring(0,100),
"tag" : "Update",
sound: "default",
},
"data": {
    "click_action": "FLUTTER_NOTIFICATION_CLICK",
    "status": "done",
    //"screen" : "ChatScreen(data.recipentUid, data.recipientName,data.text, 'https://www.frk.co.il/wp-content/uploads/2018/10/jobs1.png')",   
	"sender": data.senderName,
  },
};



// // ref to the device collection for the user
const db = admin.firestore();
const usersRef = db.collection('userData');
return usersRef.get()
.then((querySnapshot) => {
const tokens  : string[] = [];
querySnapshot.forEach(doc => {
const user = doc.data();
let userUid = String(user.uid);
//let isLoggedIn = String(user.isLoggedIn);  
let notificationSound = String(user.notificationSound);  


if(userUid == recipientUid  &&  notificationSound =="no"){

    payload.notification.sound="1.mp3";
}

if(userUid == recipientUid  /*&&  isLoggedIn == "yes"*/){
    
    tokens.push(user.pushToken);
	
  }

});
return admin.messaging().sendToDevice(tokens, payload)
}).catch((err) => {
return Promise.reject(err);
});
});