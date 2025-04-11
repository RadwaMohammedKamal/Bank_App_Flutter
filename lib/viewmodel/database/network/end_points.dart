//End Points that's Used in API
// Network Connection Details


import '../local/shared_helper.dart';

const String baseUrl = 'https://student.valuxapps.com/api/';
const String login ='login';
const String register ='register';
const String home ='home';
const String categories ='categories';
const String favorites ='favorites';
const String profile ='profile';
const String updateprofile ='update-profile';
const String search ='products/search';
String? token='';


// // End Points
// const Login = '/login';
// const Register = '/register';
// const Profile = '/show-profile';
// const Calls2 ='/calls/2';
// const Cases ='/case/14';
// const delete ='/reports/1';
// const put ='/tasks/1';
// const log ='/calls/1';
//
// String puttoken='eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNmY0MTg0ZGZiYmE4MTE2MjRmODFmMTcwODg2ZjFhMmJjYzFmMzc0MTQ5YTE1ZDQ0OWYyMmFjNDFlODVmY2E0YzIyN2QyZjNmZThmYTNjNWMiLCJpYXQiOjE2OTMzODkwMjguMDMzNDkzLCJuYmYiOjE2OTMzODkwMjguMDMzNDk4LCJleHAiOjE3MjUwMTE0MjguMDMyMTAxLCJzdWIiOiIzNDMiLCJzY29wZXMiOltdfQ.jT07FE3DiSUH1N23s2mMZF6ZbzQLsd7zSyGJdVjKEyrFbzN_G4gXwR3e5m7QkDciByLZM_iYHKmx9tmurNYpfV0wWDF4-csyn8dcX7xybar-4Jp4_QW_uGiQWAqgmdtLNKnu2OocYPPzSM71oHeKbpa7cSxdd4SHL4w-pR9ijl_lwsdJvThmWljSn4zGzw4bJgILHoIkNuwPT0DyALyfBY1wl3XZu0sABKW4x1abxod4azbQXWu2PIqNJnzDsMYPywqs7rQlBiHCW8XL9VYwTAClpjK77Getk8YGcEJaGuFjhWay9NPPAu85qFQg91E17_Zu1njWOm1vLg__ztjXOd8sOSfKYWAOgyuBE2aOXHgTub8jxqNDs7gvMVoKF_zBIjxkTnLLqBnqYs2oduu5WO-keGfdfLiXOQ4Ut0tJ_DMm6U7s2_erN0zDFqnVNBg4afG6EZiG2EF4vg11YuY9hm9bT_NOx0udpZMXNVmVWveGqv2Rc1Exl6rKEhaAWiFyK363v5ll3pYvguS6Dz-GVjRw-Pi8ygOdWPuFCOv_GCjOvhoJzpEcD_WzE_gur1OT164kqUr_dvNUytUpp_6t-iOiqk4BiYNpe1yBw2RhycHnMMYVbOQ3tKQ1herZXTS9sM0KhbojGHM_5c5sqIfU3BLKScrOgbnpWsGiwoXWefA';
// String deletetoken='eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNmY0MTg0ZGZiYmE4MTE2MjRmODFmMTcwODg2ZjFhMmJjYzFmMzc0MTQ5YTE1ZDQ0OWYyMmFjNDFlODVmY2E0YzIyN2QyZjNmZThmYTNjNWMiLCJpYXQiOjE2OTMzODkwMjguMDMzNDkzLCJuYmYiOjE2OTMzODkwMjguMDMzNDk4LCJleHAiOjE3MjUwMTE0MjguMDMyMTAxLCJzdWIiOiIzNDMiLCJzY29wZXMiOltdfQ.jT07FE3DiSUH1N23s2mMZF6ZbzQLsd7zSyGJdVjKEyrFbzN_G4gXwR3e5m7QkDciByLZM_iYHKmx9tmurNYpfV0wWDF4-csyn8dcX7xybar-4Jp4_QW_uGiQWAqgmdtLNKnu2OocYPPzSM71oHeKbpa7cSxdd4SHL4w-pR9ijl_lwsdJvThmWljSn4zGzw4bJgILHoIkNuwPT0DyALyfBY1wl3XZu0sABKW4x1abxod4azbQXWu2PIqNJnzDsMYPywqs7rQlBiHCW8XL9VYwTAClpjK77Getk8YGcEJaGuFjhWay9NPPAu85qFQg91E17_Zu1njWOm1vLg__ztjXOd8sOSfKYWAOgyuBE2aOXHgTub8jxqNDs7gvMVoKF_zBIjxkTnLLqBnqYs2oduu5WO-keGfdfLiXOQ4Ut0tJ_DMm6U7s2_erN0zDFqnVNBg4afG6EZiG2EF4vg11YuY9hm9bT_NOx0udpZMXNVmVWveGqv2Rc1Exl6rKEhaAWiFyK363v5ll3pYvguS6Dz-GVjRw-Pi8ygOdWPuFCOv_GCjOvhoJzpEcD_WzE_gur1OT164kqUr_dvNUytUpp_6t-iOiqk4BiYNpe1yBw2RhycHnMMYVbOQ3tKQ1herZXTS9sM0KhbojGHM_5c5sqIfU3BLKScrOgbnpWsGiwoXWefA';
// String accessToken='';


// if(state is LoginSuccessState)
//   {
//     if(state.loginmodel.status ==1)
//       {
//         print(state.loginmodel.message);
//         print(state.loginmodel.data?.accessToken);
//         SharedHelper.removeData(key: 'accessToken').then((value) => null);
//         SharedHelper.set(key: 'accessToken', value:state.loginmodel.data?.accessToken).
//         then((value) {
//           if (state.loginmodel.data?.specialist =='docotor') {
//             Navigator.push(context, MaterialPageRoute(
//                 builder: (context) => Specialist()),);}
//         else  if (state.loginmodel.data?.specialist =='nurse') {
//             Navigator.push(context, MaterialPageRoute(
//                 builder: (context) => SpecialistNures()),);}
//           else  if (state.loginmodel.data?.specialist =='receptionest') {
//             Navigator.push(context, MaterialPageRoute(
//                 builder: (context) => SpecialistReceptionist()),);}
//           else  if (state.loginmodel.data?.specialist =='manager') {
//             Navigator.push(context, MaterialPageRoute(
//                 builder: (context) => SpecialistManager()),);}
//           else  if (state.loginmodel.data?.specialist =='hr') {
//             Navigator.push(context, MaterialPageRoute(
//                 builder: (context) => SpecialistHRScreen()),);}
//           else  if (state.loginmodel.data?.specialist =='analysis employee') {
//             Navigator.push(context, MaterialPageRoute(
//                 builder: (context) => SpecialistAnalysis()),);}
//             }
//     );
//       }
//     else
//       {
//         if(state.loginmodel.status ==0)
//           { print(state.loginmodel.message);
//           Fluttertoast.showToast(
//               msg:'${state.loginmodel.message}',
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.BOTTOM,
//               timeInSecForIosWeb: 5,
//               backgroundColor: Colors.red,
//               textColor: Colors.black,
//               fontSize: 10);}
//
//       }
//   }