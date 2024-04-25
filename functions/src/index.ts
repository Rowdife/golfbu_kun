import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import * as logger from "firebase-functions/logger";

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

exports.notifyNewCommentForMyVideo = functions.firestore
  .document("/university/{universityId}/videos/{videoId}/comments/{commentId}")
  .onCreate(async (snapshot, context) => {
    const universityId = context.params.universityId;
    const videoId = context.params.videoId;
    const comment = snapshot.data();
    const videoRef = admin
      .firestore()
      .doc(`/university/${universityId}/videos/${videoId}`);
    const video = await videoRef.get();
    const videoData = video.data();
    const uploaderUid = videoData!.uploaderUid;

    // Check if the uploaderId is different from the current user's id
    if (uploaderUid !== comment.uploaderUid) {
      const uploaderRef = admin
        .firestore()
        .doc(`/university/${universityId}/users/${uploaderUid}`);
      console.log(uploaderRef);
      const uploader = await uploaderRef.get();
      const uploaderData = uploader.data();
      const uploaderToken = uploaderData!.token;
      const payload = {
        token: uploaderToken,
        notification: {
          title: "コメントが追加されました",
          body: `${comment.uploaderName}: ${comment.text}`,
        },
        data: {
          body: `${comment.uploaderName}: ${comment.text}`,
        },
      };
      await admin.messaging().send(payload);
      logger.info(`Sent new comment notification for video ${videoId}`);
    }
  });

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
