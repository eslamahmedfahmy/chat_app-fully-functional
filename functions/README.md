# Chat push notifications (Cloud Function)

`sendChatPush` runs when a document is created in `chats/{chatId}/messages` and sends a push to the receiver's `push_token` with the FCM HTTP v1 API.
The app no longer sends pushes itself and no longer contains a server key.

Not tested: it needs a Firebase project on the Blaze plan.

Deploy (from the project root, with the Firebase CLI logged in):

```bash
cd functions && npm install && cd ..
firebase deploy --only functions
```
