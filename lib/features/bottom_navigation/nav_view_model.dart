import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'nav_state.dart';

final navViewModelProvider = StateNotifierProvider<NavViewModel, NavState>(
  (ref) => NavViewModel(),
);

class NavViewModel extends StateNotifier<NavState> {
  NavViewModel() : super(NavState.initialState());

  void changeIndex(int index) {
    state = state.copyWith(index: index);
  }

  Future<void> updateUser({Map<String, dynamic>? data}) async {
    if (data != null){
      state = state.copyWith(userData: data);
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        final Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        userData['uid'] = user.uid;
        state =
            state.copyWith(userData: userData);
      }
    }
  }
}
