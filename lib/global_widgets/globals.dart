// globals.dart
library ward.globals;// Optional, helps organize the library

bool? doesUserHavePGlobal;
bool? doesUserHaveRGlobal;
int? numOfUsersPGlobal;
List<String>? userPlantsIDsList;


//// very important   User? user = FirebaseAuth.instance.currentUser;
// any object instance of class User? is global so it doesn't need a global var any
// instance can be already used in class in project