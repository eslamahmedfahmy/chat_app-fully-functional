// Sends a push notification when a new chat message is created.
// Replaces the old client-side call that used a legacy FCM server key.
// Uses the FCM HTTP v1 API through firebase-admin, so no key is stored in the app.
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendChatPush = onDocumentCreated(
  "chats/{chatId}/messages/{messageId}",
  async (event) => {
    const msg = event.data && event.data.data();
    if (!msg || !msg.toId || !msg.formId) return;

    const db = admin.firestore();
    const [toSnap, fromSnap] = await Promise.all([
      db.collection("users").doc(msg.toId).get(),
      db.collection("users").doc(msg.formId).get(),
    ]);
    const token = toSnap.exists ? toSnap.get("push_token") : "";
    if (!token) return;

    const senderName = fromSnap.exists ? fromSnap.get("name") || "New message" : "New message";
    const body = msg.type === "image" ? "Image" : String(msg.msg || "");

    try {
      await admin.messaging().send({
        token,
        notification: { title: senderName, body },
        data: { from_id: String(msg.formId) },
        android: { notification: { channelId: "chats" } },
      });
    } catch (e) {
      console.error("sendChatPush failed", e.code || e.message);
    }
  }
);
