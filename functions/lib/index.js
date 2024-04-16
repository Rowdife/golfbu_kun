"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const admin = require("firebase-admin");
const functions = require("firebase-functions");
const logger = require("firebase-functions/logger");
admin.initializeApp();

// Listen for changes in the comments collection
exports.updateCommentsCount = functions.firestore
  .document("/university/{universityId}/videos/{videoId}/comments/{commentId}")
  .onWrite(async (change, context) => {
    const universityId = context.params.universityId;
    const videoId = context.params.videoId;
    // Get the comments collection reference
    const commentsRef = admin
      .firestore()
      .collection(`/university/${universityId}/videos/${videoId}/comments`);
    // Get the comments count
    const commentsSnapshot = await commentsRef.get();
    const commentsCount = commentsSnapshot.size;
    // Update the comments field in the video document
    const videoRef = admin
      .firestore()
      .doc(`/university/${universityId}/videos/${videoId}`);
    await videoRef.update({ comments: commentsCount });
    logger.info(
      `Updated comments count for video ${videoId}: ${commentsCount}`
    );
  });
// Listen for changes in the

// Start writing functions
// https://firebase.google.com/docs/functions/typescript
// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
//# sourceMappingURL=index.js.map
