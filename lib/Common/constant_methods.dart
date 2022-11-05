import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ConstantMethods{

  loader(){
    return const Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Color(0xffFF0000))),);
  }

  launchNews(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

}