import 'package:googleapis_auth/auth_io.dart';

class OAuth2TokenAccess {
  static String firebaseCloudMessagingScope = 'https://www.googleapis.com/auth/firebase.messaging'; // End-point URL.

  Future<String> getAccessToken() async {
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(
        {
          "type": "service_account",
          "project_id": "portugo-c7f05",
          "private_key_id": "20d78e4302fc8401d741fef76295e1fe81120623",
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCnTUvCl+hBBjpy\nbe+a6D+vrD8wXLAdMbqOVPAnKeolDeoK+2bUyLsj32g8gRbUpHhz1E+dfb1xT02C\nb6UkPZx/CZKvOdNa/lhJF2CeGnpkMXQEAcKehu8kAgAW98WGYgCQ/LAAbJMVScRN\nwjuSHbwP+oy5cEgPw2MtpoS072daSTzeZRYe0bE+vfpUWi14LiqA04FmiSTmRSWt\nDhvU2tXY0SQ2vd+/MvLvwObeJxPcLkdcSluI+lPfHO1Suas+xSMSKqiJXEQkrtrK\nHCwFWyeorT/IiiVStfpYPa94ApO7LBu3oaNqHqI3hMJOnF0kCrDnzhC85+joITPa\ng8jPdwhjAgMBAAECggEAAlBo5FuqjD+0TkHkBw4AV4M36ojVrMmzzWUyXzBOu016\nd8VrcjUGlaPw8qlMcguGWP/OTBzhonAY392AeMRbZkxxGXhgyojrGrO2k+lE2R7v\n/mAx23R9WU+nxamOs2GmpVrBangV/rzi+LpfjZFYuRXbnXMGpCUtOYPsoP4QvWhx\nMmWcRzVnqMV9Dw2BZmRo1+0xyMH7PzVTsYwtPdn7JGhr1O8K7dBmgL11aVUjvgjP\nMnnfF3I9/sTgPe9KhhZw5lbVAi+ADwyW8hEI6VkhivMshnlFLGJ3+mFwL07C7VeD\n2duNgpCAJOy65jwbXbeq0q6JvKm3aDeI9sX4Eg2AQQKBgQDYtOKb8lDnCSejxWo8\nucuvmp41TRAakzbHKjPQ3Qrco0HaFYBxXWhm716ud8aBF5PWCpGqzoh9TzTJMg1A\na+L3UvaT3VvlXa0uu1k5bdExkAUdL25A6CPayHSrpWKlzVNJWh9w86pVzmYM4ac5\nJWPqpQM7ibtTP7WibgWO/32eowKBgQDFoyOuVCEXidfna55WuIIK+NYRO0lQBlzD\npcQvAIELCDdAtdID0IrGa20M08txQPzvwYjNue1D/ahQhMbVd0DHsknecfb7W15N\naG47fEZbLKV1lVqvkBcsvG3HmeBkgoyovxtMRQfLy9sfVl0Jf49SzMlNcpZTT8Lr\n2PSY+ghLQQKBgQCJQhj+OX7wtyW6X4IosG3I7iAjFoqKqo/ZmmtzcW49zdIZ9eCC\n7W0BNcA8tXSvs2VZ/xvAmkxtQkvm26L1GOCLUqsHgP+BydG1dcjPzTThNZ1nnPEy\nf1ambq0nQvu2lNSZ81FS06Mh8jdFFXA7i+k7aAUiItzZn9LF7PXsWvsQDQKBgQDC\nwRlXH3YgoOgOF0HHyTf0ofMotdhvsGVXMpGZk5CWE3mHHeSfd7BZCOFEI601pEnb\n5UXvHImPV3W2KrFZB5PhdXJPbtRoK0hJVWBS5Arcq6k8rnnXyVDc963iZGL4CKGd\nY/z9coTVMcRzJAK4amgMutqfpAw4er/k8z1NRg5IQQKBgArRFhDA57UB/jLg4GVi\nvUEDPJrgh2ZJSNILb2jjGstdlOzY8Ikv7YEGlqNjuGosuBpQwhbtGq1vlMkOX+JY\nAlmTht3VlrKTIpX4vRl8uu/BUUTf8zXweP8H/iLTeJvL+KEKibgwPDqT6XnJQGb1\nTPNqfQdWgd6fai9m2yo2U++K\n-----END PRIVATE KEY-----\n",
          "client_email": "firebase-adminsdk-7goyd@portugo-c7f05.iam.gserviceaccount.com",
          "client_id": "116544252828678985399",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-7goyd%40portugo-c7f05.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }
      ), [firebaseCloudMessagingScope]
    );
    // Extracting the oAuth 2.0 access token from the credentials:
    final oAuth2CloudMessagingToken = client.credentials.accessToken.data;
    // Returning the oAuth 2.0 access token:
    return oAuth2CloudMessagingToken;
  }
}