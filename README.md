# Twitter
1. Authentication
* Login view.
* Using Google Firebase to allow user to sign in anonymously
2. Chatting
* Channels view
* Messages View
* Using Firebase Firestore services to save models
3. Chunking function
- **#Step 1:** Splitting the message in to words
- **#Step 2:** Based on string's length, calculating amount of chunks which is used to seperate string into
- **#Step 3:** Creating chunk by joining words together with a whitespace as separator
- **#Step 4:** Chunking the message with number of chunks which was calculated. Each chunk's size cannot be larger than the maximum of message's length except the last one
- **#Step 5:** Checking the last chunk's size. If it is larger than the maximum of message's length, repeating step 3 with a new number of chunks(by adding 1) until archiving the end result.

- **Complexity:** O(n)
