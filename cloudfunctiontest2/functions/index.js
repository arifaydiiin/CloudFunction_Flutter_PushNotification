
const functions = require("firebase-functions");
const admin = require('firebase-admin');
const { event } = require("firebase-functions/v1/analytics");

admin.initializeApp(functions.config().firebase);
// const fetch = require('node-fetch');
// exports.zamanlifunc = functions.pubsub.schedule('every 1 minutes').onRun((context) => {
    
//   const fetchFromURL = async () => await (await fetch('https://jsonplaceholder.typicode.com/todos/1')).json();   
//      fetchFromURL().then((data) => {
//      functions.logger.info("istek atıldı Gelen cevap : ----"+data.id, { structuredData: true });
//     }); 

// });

exports.yenikullanici=functions.firestore.document('users/{docID}').onCreate(async(change,context)=>{
    const docid = context.params.docID;
    console.log('User to send notification', docid);
    const deviceIdTokens = await admin
    .firestore()
    .collection('users').doc(docid).get();
    
    var payload = {
        notification: {
            title: 'Push Title',
            body: 'Push Body',
            sound: 'default',
        },
        // data: {
        //     push_key: 'Push Key Value',
        //     key1: newData.data,
        // },
    };
    try {
        const response = await admin.messaging().sendToDevice(deviceIdTokens.data().token, payload);
        console.log('Notification sent successfully');
    } catch (err) {
        console.log(err);
    }
});