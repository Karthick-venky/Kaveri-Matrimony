class UpdateEducationDetailsModel {

  String employedIn;
  String educationDetails;
  String income;
  String per;
  String occupationDetails;

  UpdateEducationDetailsModel({

    required this.employedIn,
    required this.educationDetails,
    required this.income,
    required this.per,
    required this.occupationDetails,
  });

  Map<String, dynamic> toJson() {
    return {

      'employed_in': employedIn,
      'education_details': educationDetails,
      'income': income,
      'per': per,
      'occupation_details': occupationDetails,
    };
  }
}
