import 'package:http/http.dart' as http;
import '../settings/url.dart';

Future<http.Response> postsBySlug(slug) =>
    http.get(serverUrl + '/api/tags/' + slug);

Future<http.Response> fetchHome() => http.get(serverUrl + '/api/home');

Future<http.Response> getCompanies() => http.get(serverUrl + '/api/companies');
