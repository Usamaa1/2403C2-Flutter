import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewSection extends StatefulWidget {
  final String productId;
  final String status;

  const ReviewSection({
    super.key,
    required this.productId,
    required this.status,
  });

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  int rating = 5;
  final TextEditingController reviewController = TextEditingController();
  final reviewsRef = FirebaseFirestore.instance.collection("reviews");

  bool alreadyReviewed = false;
  String existingReview = "";
  int existingRating = 0;

  @override
  void initState() {
    super.initState();
    checkExistingReview();
  }

  Future<void> checkExistingReview() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await reviewsRef
        .where("userId", isEqualTo: user.uid)
        .where("productId", isEqualTo: widget.productId)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      setState(() {
        alreadyReviewed = true;
        existingReview = data["review"] ?? "";
        existingRating = (data["rating"] ?? 0);
      });
    }
  }

  Future<void> submitReview() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final reviewText = reviewController.text.trim();

    if (reviewText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please write a review")),
      );
      return;
    }

    await reviewsRef.add({
      "userId": user.uid,
      "productId": widget.productId,
      "rating": rating,
      "review": reviewText,
      "createdAt": FieldValue.serverTimestamp(),
    });

    await checkExistingReview();

    reviewController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Review submitted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.status != "delivered") {
      return const SizedBox();
    }

    /// 🔴 Already Reviewed → Show Previous Data Only
    if (alreadyReviewed) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const Text(
            "Your Review",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),

          RatingBarIndicator(
            rating: existingRating.toDouble(),
            itemBuilder: (context, _) =>
                const Icon(Icons.star, color: Colors.amber),
            itemCount: 5,
            itemSize: 24,
          ),

          const SizedBox(height: 6),

          Text(existingReview),

          const SizedBox(height: 10),

          const Text(
            "You have already reviewed this product.",
            style: TextStyle(color: Colors.green),
          ),
        ],
      );
    }

    /// 🟢 Not Reviewed → Allow Review
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const Text(
          "Leave a Review",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),

        RatingBar.builder(
          initialRating: rating.toDouble(),
          minRating: 1,
          itemCount: 5,
          itemSize: 30,
          itemBuilder: (context, _) =>
              const Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (value) {
            setState(() {
              rating = value.toInt();
            });
          },
        ),

        const SizedBox(height: 8),

        TextField(
          controller: reviewController,
          decoration: const InputDecoration(
            hintText: "Write your review",
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: submitReview,
            child: const Text("Submit Review"),
          ),
        ),
      ],
    );
  }
}
