﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="VerifyToken._default" %>
<!--

/*
 *
 * Copyright 2013 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

-->

<html>
<head>
  <title>Demo: Token Verification in C#/.Net</title>
  <script type="text/javascript">
      (function () {
          var po = document.createElement('script');
          po.type = 'text/javascript'; po.async = true;
          po.src = 'https://plus.google.com/js/client:plusone.js';
          var s = document.getElementsByTagName('script')[0];
          s.parentNode.insertBefore(po, s);
      })();
  </script>
  <!-- JavaScript specific to this application that is not related to API
     calls -->
  <script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js" ></script>
</head>
<body>
  <div id="gConnect">
    <button class="g-signin"
        data-scope="https://www.googleapis.com/auth/plus.login"
        data-requestvisibleactions="http://schemas.google.com/AddActivity"
        data-clientId="<%=VerifyToken.VerifyToken.CLIENT_ID %>"
        data-accesstype="offline"
        data-callback="onSignInCallback"
        data-cookiepolicy="single_host_origin">
    </button>
  </div>
  <div id="authOps" style="display:none">
    <h2>Authentication Logs</h2>
    <pre id="authResult"></pre>
    <pre id="tokenResult"></pre>
  </div>
</body>
<script type="text/javascript">
    var helper = (function () {
        var authResult = undefined;

        return {
            /**
             * Hides the sign-in button and connects the server-side app after
             * the user successfully signs in.
             *
             * @param {Object} authResult An Object which contains the access token and
             *   other authentication information.
             */
            onSignInCallback: function (authResult) {
                $('#authResult').html('Auth Result:<br/>');
                for (var field in authResult) {
                    $('#authResult').append(' ' + field + ': ' + authResult[field] + '<br/>');
                }
                if (authResult['access_token']) {
                    // The user is signed in
                    this.authResult = authResult;
                    this.verifyTokens();
                    $('#authOps').show('slow');
                } else if (authResult['error']) {
                    // There was an error, which means the user is not signed in.
                    // As an example, you can troubleshoot by writing to the console:
                    console.log('There was an error: ' + authResult['error']);
                    $('#authResult').append('Logged out');
                    $('#authOps').hide('slow');
                    $('#gConnect').show();
                }
                console.log('authResult', authResult);
            },
            /**
             * Calls the server endpoint to verify the ID Token and Access Token
             */
            verifyTokens: function () {
                $.ajax({
                    type: 'POST',
                    url: window.location.href + 'verify'
                        + '?id_token=' + this.authResult.id_token
                        + '&access_token=' + this.authResult.access_token,
                    success: function (result) {
                        console.log(result);
                        $('#tokenResult').html('Token Verification Result:<br/>');
                        $('#tokenResult').append(JSON.stringify(result, undefined, 2));
                    },
                    processData: false,
                });
            },
        };
    })();

    /**
     * Perform jQuery initialization and check to ensure that you updated your
     * client ID.
     */
    $(document).ready(function () {
        $('#disconnect').click(helper.disconnectServer);
        if ($('[data-clientid="YOUR_CLIENT_ID"]').length > 0) {
            alert('This sample requires your OAuth credentials (client ID) ' +
                'from the Google APIs console:\n' +
                '    https://code.google.com/apis/console/#:access\n\n' +
                'Find and replace YOUR_CLIENT_ID with your client ID and ' +
                'YOUR_CLIENT_SECRET with your client secret in the project sources.'
            );
        }
    });

    /**
     * Calls the helper method that handles the authentication flow.
     *
     * @param {Object} authResult An Object which contains the access token and
     *   other authentication information.
     */
    function onSignInCallback(authResult) {
        helper.onSignInCallback(authResult);
    }
</script>
</html>