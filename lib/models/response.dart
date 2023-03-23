import 'dart:convert';

Response responseFromJson(String str) => Response.fromJson(json.decode(str));

class Response {
  Response({
    this.isSuccess,
    this.message,
    this.errorMessages,
    this.result,
  });

  bool? isSuccess;
  String? message;
  dynamic? errorMessages;
  String? result;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        isSuccess: json["isSuccess"],
        message: json["message"],
        errorMessages: json["errorMessages"],
        result: json["result"],
      );
}
