import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
    Login({
        required this.statusCode,
        required this.item,
        this.itemCount,
        this.itemPageing,
        required this.response,
        this.responseheader,
        this.responsedetails,
        this.responseattachments,
        this.gudid,
        this.parameter1,
        this.parameter2,
        this.parameter3,
        this.parameter4,
        this.parameter5,
        this.parameter6,
        this.parameter7,
        this.parameter8,
        this.parameter9,
        this.parameter10,
        this.parameter11,
    });

    String statusCode;
    String item;
    dynamic itemCount;
    dynamic itemPageing;
    String response;
    dynamic responseheader;
    dynamic responsedetails;
    dynamic responseattachments;
    dynamic gudid;
    dynamic parameter1;
    dynamic parameter2;
    dynamic parameter3;
    dynamic parameter4;
    dynamic parameter5;
    dynamic parameter6;
    dynamic parameter7;
    dynamic parameter8;
    dynamic parameter9;
    dynamic parameter10;
    dynamic parameter11;

    factory Login.fromJson(Map<String, dynamic> json) => Login(
        statusCode: json["StatusCode"],
        item: json["Item"],
        itemCount: json["ItemCount"],
        itemPageing: json["ItemPageing"],
        response: json["response"],
        responseheader: json["responseheader"],
        responsedetails: json["responsedetails"],
        responseattachments: json["responseattachments"],
        gudid: json["gudid"],
        parameter1: json["parameter1"],
        parameter2: json["parameter2"],
        parameter3: json["parameter3"],
        parameter4: json["parameter4"],
        parameter5: json["parameter5"],
        parameter6: json["parameter6"],
        parameter7: json["parameter7"],
        parameter8: json["parameter8"],
        parameter9: json["parameter9"],
        parameter10: json["parameter10"],
        parameter11: json["parameter11"],
    );

    Map<String, dynamic> toJson() => {
        "StatusCode": statusCode,
        "Item": item,
        "ItemCount": itemCount,
        "ItemPageing": itemPageing,
        "response": response,
        "responseheader": responseheader,
        "responsedetails": responsedetails,
        "responseattachments": responseattachments,
        "gudid": gudid,
        "parameter1": parameter1,
        "parameter2": parameter2,
        "parameter3": parameter3,
        "parameter4": parameter4,
        "parameter5": parameter5,
        "parameter6": parameter6,
        "parameter7": parameter7,
        "parameter8": parameter8,
        "parameter9": parameter9,
        "parameter10": parameter10,
        "parameter11": parameter11,
    };
}
Sidenav sidenavFromJson(String str) => Sidenav.fromJson(json.decode(str));

String sidenavToJson(Sidenav data) => json.encode(data.toJson());

class Sidenav {
    Sidenav({
        required this.header,
    });

    String header;

    factory Sidenav.fromJson(Map<String, dynamic> json) => Sidenav(
        header: json["Header"],
    );

    Map<String, dynamic> toJson() => {
        "Header": header,
    };
}
