import 'family_member_model.dart';

enum VisibilityType { public, private }

class PersonalQuestionState {
  FamilyMember? target;
  VisibilityType? visibility;
  String question = '';
}
