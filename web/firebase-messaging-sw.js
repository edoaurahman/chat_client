importScripts("https://www.gstatic.com/firebasejs/10.1.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.1.0/firebase-messaging-compat.js");

firebase.initializeApp({
    apiKey: "AIzaSyCLWmggqordR56iJtvhFfA5miilB8Tej-Q",
    authDomain: "chatme-d4b25.firebaseapp.com",
    projectId: "chatme-d4b25",
    storageBucket: "chatme-d4b25.appspot.com",
    messagingSenderId: "213611714815",
    appId: "1:213611714815:web:53b95b247f1895b25854ca",
    measurementId: "G-211TSYCVP0"
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);
});