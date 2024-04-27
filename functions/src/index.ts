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

exports.notifyNewCommentMentioned = functions.firestore
  .document("/university/{universityId}/videos/{videoId}/comments/{commentId}")
  .onCreate(async (snapshot, context) => {
    const universityId = context.params.universityId;
    const videoId = context.params.videoId;
    const video = await admin
      .firestore()
      .doc(`/university/${universityId}/videos/${videoId}`)
      .get();
    const uploaderName = video.data()!.uploaderName;
    const comment = snapshot.data();
    if (comment.text.startsWith("@")) {
      const mentionedUserId = comment.text.match(/@(\S+)/)?.[1];

      if (mentionedUserId) {
        console.log(mentionedUserId);
        const mentionedUserRef = admin
          .firestore()
          .doc(`/university/${universityId}/users/${mentionedUserId}`);
        const mentionedUser = await mentionedUserRef.get();
        if (!mentionedUser.exists) {
          logger.error(`User ${mentionedUserId} does not exist`);
          return;
        }
        const mentionedUserData = mentionedUser.data();
        const mentionedUserToken = mentionedUserData!.token;
        const payload = {
          token: mentionedUserToken,
          notification: {
            title: `${uploaderName}さんの動画でメンションされました。`,
            body: `${comment.uploaderName}: ${comment.text.slice(29)}`,
          },
          data: {
            body: `${comment.uploaderName}: ${comment.text.slice(29)}`,
          },
        };
        await admin.messaging().send(payload);
      }
    }
  });

exports.notifyNewVideoInMyUniversity = functions.firestore
  .document("/university/{universityId}/videos/{videoId}")
  .onCreate(async (snapshot, context) => {
    const universityId = context.params.universityId;
    const videoId = context.params.videoId;
    const video = snapshot.data();

    const uploaderUid = video.uploaderUid;
    const uploaderRef = admin
      .firestore()
      .doc(`/university/${universityId}/users/${uploaderUid}`);
    const uploader = await uploaderRef.get();
    const uploaderData = uploader.data();
    const uploaderToken = uploaderData!.token;

    const usersSnapshot = await admin
      .firestore()
      .collection(`/university/${universityId}/users`)
      .where("token", "!=", null)
      .get();

    const tokensInMySchool: string[] = [];
    usersSnapshot.forEach((userDoc) => {
      const userData = userDoc.data();
      const userToken = userData.token;
      tokensInMySchool.push(userToken);
    });

    for (const token of tokensInMySchool) {
      if (token !== uploaderToken) {
        const payload = {
          token: token,
          notification: {
            title: "新しい動画が追加されました",
            body: `${video.uploaderName}が動画を投稿しました。`,
          },
          data: {
            body: `${video.uploaderName}が動画を投稿しました。`,
          },
        };
        await admin.messaging().send(payload);
        logger.info(`Sent new video notification for video ${videoId}`);
      }
    }
  });

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
