import 'package:artificialsw_frontend/shared/models/usermodel.dart';

enum VisibilityType { public, private }

class PersonalQuestionState {
  User? target;
  VisibilityType? visibility;
  String question = '';
}