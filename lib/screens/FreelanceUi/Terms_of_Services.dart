// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';

class TermsofServices extends StatelessWidget {
  const TermsofServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Terms of Services'),
          centerTitle: true,
          flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF8C52FF),
                Color(0xFFFF914D),
              ],
            ),
          ),
        ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
            Text('Privacy Policy', style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   In TaskTrove, we take your privacy seriously and are committed to protecting your personal information. This Privacy Policy outlines how we collect, use, and safeguard your data when you use our mobile application.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              child: Text('1. Information We Collect:', 
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   - Personal Information: We may collect personal information such as your name, email address, and payment details when you subscribe to our services.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   - Usage Information: We gather information about how you interact with our app, including log data, device information, and usage patterns.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   - Cookies: We use cookies and similar tracking technologies to enhance your experience and improve our services.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              child: Text('2. How We Use Your Information:', 
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
            ),
             Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   - Personalization: We use your information to personalize your experience and provide tailored services.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
             Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   - Communication: We may send you updates, newsletters, and promotional offers based on your preferences.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
             Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   - Analytics: We analyze user behavior to improve our app`s performance, features, and functionality.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              child: Text('3. Data Security:', 
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   - We implement industry-standard security measures to protect your data from unauthorized access, alteration, disclosure, or destruction.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   - However, no method of transmission over the internet or electronic storage is 100% secure, and we cannot guarantee absolute security.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              child: Text('4. Sharing Your Information:', 
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   - We may share your information with trusted third parties for purposes such as payment processing, analytics, and marketing.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   - We will not sell, rent, or trade your personal information to third parties without your consent.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              child: Text('5. Updates to This Policy:', 
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   - We reserve the right to update this Privacy Policy to reflect changes in our practices and legal requirements.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   - We will notify you of any material changes by posting the updated policy on our website or sending you a notification through the app.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   By using TaskTrove, you consent to the terms outlined in this Privacy Policy. If you have any questions or concerns about our practices, please contact us at our Admin Account.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text('Community Guidelines', style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   TaskTrove is committed to providing a safe and welcoming community for all users. By using our platform, you agree to adhere to the following guidelines.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
             Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              child: Text('1. Respect Others:', 
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
            ),
             Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   - Treat all users with respect and courtesy, regardless of their background, skills, or opinions.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
             Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   - Avoid engaging in personal attacks, harassment, or discrimination of any kind.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              child: Text('2. Professional Conduct:', 
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   - Conduct yourself in a professional manner when interacting with clients, fellow programmers, and TaskTrove staff.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   - Maintain confidentiality and respect the intellectual property rights of others.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              child: Text('3. Quality of Work:', 
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   - Strive to deliver high-quality work that meets or exceeds the expectations of clients.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   - Communicate openly and transparently with clients to ensure project success.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              child: Text('4. Compliance with Policies:', 
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   - Follow TaskTrove`s Terms of Service, Privacy Policy, and Subscription Agreement at all times.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   - Report any violations or inappropriate behavior to TaskTrove`s support team.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              child: Text('5. Feedback and Improvement:', 
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   - Provide constructive feedback to help improve the platform and enhance the user experience.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   - Continuously seek opportunities for professional development and growth.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   Violation of these guidelines may result in suspension or termination of your account. TaskTrove reserves the right to take appropriate action against users who fail to comply with these standards.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('   By using TaskTrove, you agree to uphold these Community Guidelines and contribute to a positive and collaborative environment for all users.', 
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ]
          ),
        ),
    );
  }
}