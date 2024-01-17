import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

admin.initializeApp();
const firestore = admin.firestore();

exports.updateStockOnOrderCreate = functions.firestore
  .document("user/{userId}/order/{orderId}")
  .onCreate(async (snap, context) => {
    const orderData = snap.data();

    if (!orderData || !orderData.items || !Array.isArray(orderData.items)) {
      console.error("Invalid order data.");
      return null;
    }

    const items = orderData.items;

    const batch = firestore.batch();

    items.forEach(async (item) => {
      const foodRef = firestore.collection("food").doc(item.foodId);

      batch.update(foodRef, {
        stock: admin.firestore.FieldValue.increment(-item.quantities),
      });
    });

    return batch.commit();
  });

exports.updateStockOnOrderDelete = functions.firestore
  .document("user/{userId}/order/{orderId}")
  .onDelete(async (snap, context) => {
    const orderData = snap.data();

    if (!orderData || !orderData.items || !Array.isArray(orderData.items)) {
      console.error("Invalid order data.");
      return null;
    }

    const items = orderData.items;

    const batch = firestore.batch();

    items.forEach(async (item) => {
      const foodRef = firestore.collection("food").doc(item.foodId);

      batch.update(foodRef, {
        stock: admin.firestore.FieldValue.increment(item.quantities),
      });
    });

    return batch.commit();
  });

exports.restockFoods = functions.pubsub
  .schedule("every day 00:00")
  .timeZone("Europe/Madrid")
  .onRun(async () => {
    const foodsSnapshot = await firestore.collection("food").get();

    const batch = firestore.batch();

    foodsSnapshot.forEach((foodDoc) => {
      const foodRef = firestore.collection("food").doc(foodDoc.id);
      batch.update(foodRef, {stock: 1000});
    });

    return batch.commit();
  });
