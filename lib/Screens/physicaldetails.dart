import 'package:flutter/material.dart';

import '../myprofile/height.dart';
import '../myprofile/weight.dart';
import 'familydetails.dart';

class PhysicalDetails extends StatefulWidget {
  const PhysicalDetails({super.key});

  @override
  State<PhysicalDetails> createState() => _PhysicalDetailsState();
}

class _PhysicalDetailsState extends State<PhysicalDetails> {

  double selectedHeight = 0.0;
  String? selectedBodyType;

  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController bodytype=TextEditingController();
  TextEditingController Complexion=TextEditingController();
  TextEditingController physicallyChallengedController = TextEditingController();
  TextEditingController physicalstatus=TextEditingController();
  TextEditingController food=TextEditingController();

  List<Weight> weights = [
    Weight( displayText: '38 Kg'),
    Weight( displayText: '39 Kg'),
    Weight( displayText: '40 Kg'),
    Weight(displayText: '41 Kg'),
    Weight( displayText: '42 Kg'),
    Weight( displayText: '43 Kg'),
    Weight( displayText: '44 Kg'),
    Weight( displayText: '45 Kg'),
    Weight( displayText: '46 Kg'),
    Weight( displayText: '47 Kg'),
    Weight( displayText: '48 Kg'),
    Weight( displayText: '49 Kg'),
    Weight( displayText: '50 Kg'),
    Weight( displayText: '51 Kg'),
    Weight( displayText: '52 Kg'),
    Weight( displayText: '53 Kg'),
    Weight( displayText: '54 Kg'),
    Weight( displayText: '55 Kg'),
    Weight( displayText: '56 Kg'),
    Weight( displayText: '57 Kg'),
    Weight( displayText: '58 Kg'),
    Weight( displayText: '59 Kg'),
    Weight( displayText: '60 Kg'),
    Weight( displayText: '61 Kg'),
    Weight( displayText: '62 Kg'),
    Weight( displayText: '63 Kg'),
    Weight( displayText: '64 Kg'),
    Weight( displayText: '65 Kg'),
    Weight( displayText: '66 Kg'),
    Weight( displayText: '67 Kg'),
    Weight( displayText: '68 Kg'),
    Weight( displayText: '69 Kg'),
    Weight( displayText: '70 Kg'),
    Weight( displayText: '71 Kg'),
    Weight( displayText: '72 Kg'),
    Weight( displayText: '73 Kg'),
    Weight( displayText: '74 Kg'),
    Weight( displayText: '75 Kg'),
    Weight( displayText: '76 Kg'),
    Weight( displayText: '77 Kg'),
    Weight( displayText: '78 Kg'),
    Weight( displayText: '79 Kg'),
    Weight( displayText: '80 Kg'),
    Weight( displayText: '81 Kg'),
    Weight( displayText: '82 Kg'),
    Weight( displayText: '83 Kg'),
    Weight( displayText: '84 Kg'),
    Weight( displayText: '85 Kg'),
    Weight( displayText: '86 Kg'),
    Weight( displayText: '87 Kg'),
    Weight( displayText: '88 Kg'),
    Weight( displayText: '89 Kg'),
    Weight( displayText: '90 Kg'),
    Weight( displayText: '91 Kg'),
    Weight( displayText: '92 Kg'),
    Weight( displayText: '93 Kg'),
    Weight( displayText: '94 Kg'),
    Weight( displayText: '95 Kg'),
    Weight( displayText: '96 Kg'),
    Weight( displayText: '97 Kg'),
    Weight( displayText: '98 Kg'),
    Weight( displayText: '99 Kg'),
    Weight( displayText: '100 Kg'),
    Weight( displayText: '101 Kg'),
    Weight( displayText: '102 Kg'),
    Weight( displayText: '103 Kg'),
    Weight( displayText: '104 Kg'),
    Weight( displayText: '105 Kg'),
    Weight( displayText: '106 Kg'),
    Weight( displayText: '107 Kg'),
    Weight( displayText: '108 Kg'),
    Weight( displayText: '109 Kg'),
    Weight( displayText: '110 Kg'),
    Weight( displayText: '111 Kg'),
    Weight( displayText: '112 Kg'),
    Weight( displayText: '113 Kg'),
    Weight( displayText: '114 Kg'),
    Weight( displayText: '115 Kg'),
    Weight( displayText: '116 Kg'),
    Weight( displayText: '117 Kg'),
    Weight( displayText: '118 Kg'),
    Weight( displayText: '119 Kg'),
    Weight( displayText: '120 Kg'),
    Weight( displayText: '121 Kg'),
    Weight( displayText: '122 Kg'),
    Weight( displayText: '123 Kg'),
    Weight( displayText: '124 Kg'),
    Weight( displayText: '125 Kg'),
    Weight( displayText: '126 Kg'),
    Weight( displayText: '127 Kg'),
    Weight( displayText: '128 Kg'),
    Weight( displayText: '129 Kg'),
    Weight( displayText: '130 Kg'),
    Weight( displayText: '131 Kg'),
    Weight( displayText: '132 Kg'),
    Weight( displayText: '133 Kg'),
    Weight( displayText: '134 Kg'),
    Weight( displayText: '135 Kg'),
    Weight( displayText: '136 Kg'),
    Weight( displayText: '137 Kg'),
    Weight( displayText: '138 Kg'),
    Weight( displayText: '139 Kg'),
    Weight( displayText: '140 Kg'),
  ];

  Weight? selectedWeight;
  String? selectedPhysicalStatus;
  String? selectedComplexion;
  String? selectedFood;
  List<String> bodyTypeOptions = ["Slim", "Average", "Athletic", "Heavy"];

  List<String> complexionOptions = [
    "Fair",
    "Very Fair",
    "Wheatish",
    "Wheatish Medium",
    "Wheatish Brown",
    "Dark",
  ];

  void physicalregistration()
  {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context)=>const FamilyDetails())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFe00a0a),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  minimumSize: const Size(100, 50),
                ),
                child: const Text(
                  "Physical Attributes",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Height *",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<Height>(
                value: heights.firstWhere(
                      (height) => height.value == selectedHeight,
                  orElse: () => heights[0],
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                icon: null,
                items: heights.map<DropdownMenuItem<Height>>((Height height) {
                  return DropdownMenuItem<Height>(
                    value: height,
                    child: Text(height.displayText),
                  );
                }).toList(),
                onChanged: (Height? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedHeight = newValue.value;
                      heightController.text = newValue.displayText;
                    });
                  }
                  print("Selected height value: ${newValue?.value}");
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Weight *",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<Weight>(
                value: selectedWeight ?? weights[0],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                icon: null,
                items: weights.map<DropdownMenuItem<Weight>>((weight) {
                  return DropdownMenuItem<Weight>(
                    value: weight,
                    child: Text(weight.displayText),
                  );
                }).toList(),
                onChanged: (Weight? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedWeight = newValue;
                      weightController.text = newValue.displayText;
                    });
                  }
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Body Type *",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: selectedBodyType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                icon: null,
                items: bodyTypeOptions.map<DropdownMenuItem<String>>((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      selectedBodyType = value;
                      bodytype.text = value;
                    });
                  }
                  // Handle the selected value
                  print("Selected value: $value");
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Complexion *",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: selectedComplexion,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                icon: null,
                items: complexionOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      selectedComplexion = value;
                      Complexion.text = value;
                    });
                  }
                  // Handle the selected value
                  print("Selected value: $value");
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Physical Status *",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: selectedPhysicalStatus,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                icon: null,
                items: const [
                  DropdownMenuItem(
                    value: "Normal",
                    child: Text("Normal"),
                  ),
                  DropdownMenuItem(
                    value: "Physically Challenged",
                    child: Text("Physically Challenged"),
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    selectedPhysicalStatus = value;
                    physicalstatus.text = value ?? "";
                  });
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Physical Challanged Details *",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Visibility(
              visible: selectedPhysicalStatus == "Physically Challenged",
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: physicallyChallengedController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFe00a0a),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  minimumSize: const Size(100, 50),
                ),
                child: const Text(
                  "Habits",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Food *",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: selectedFood,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                icon: null,
                items: const [
                  DropdownMenuItem(
                    value: "Vegetarian",
                    child: Text("Vegetarian"),
                  ),
                  DropdownMenuItem(
                    value: "Non-Vegetarian",
                    child: Text("Non-Vegetarian"),
                  ),
                  DropdownMenuItem(
                    value: "Eggetarian",
                    child: Text("Eggetarian"),
                  ),
                ],
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      selectedFood = value;
                      food.text = value;
                    });
                  }
                  // Handle the selected value
                  print("Selected value: $value");
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  physicalregistration();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFf9fd00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  minimumSize: const Size(100, 50),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
