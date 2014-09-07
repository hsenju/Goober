Goober
======
MHACKS IV Project: This app allows you to see the trending areas around you on Twitter and then order an Uber to that location. Watch video at https://www.youtube.com/watch?v=7dIo1W36xAE&feature=youtu.be to see demo.

Our inspiration came from our interest in working with the newly released Uber API. We decided to combine the Uber API with our desire to use techniques such as machine learning techniques like sentiment analysis. Our app aims to help users seamlessly discover and participate in the popular events around them.

We created an iOS app in which users can see the most popular events in their vicinity via data analysis in the backend. The users then have the option to request an Uber to those events. The top half of the main screen consists of a map that visualizes these events. The bottom half consists of the detailed event list, where by clicking a row, the app launched the Uber app with the pickup, destination, and car-type pre-filled. At this point, the user only has to click one more button to order his/her Uber.

The backend is powered by Python's natural language processing library, textblob, hosted on an AWS instance. The app watches twitter in the user's local area to decide where the happiest people in the city currently are. We used reverse-geocoding to determine which venues are popular. We then populated our Parse datastore to make the information readily available to the iOS frontend.

run app.py to start backend
run server.py to start the server
run install cocoapods to run the app
