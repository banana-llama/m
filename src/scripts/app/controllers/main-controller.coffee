app.controller 'MainController', ($scope, $log, $location) ->
    $scope.selectedPage = 'request'

    $scope.setPage = (page) ->
        $log.info "Selecting page `#{page}`."
        $scope.selectedPage = page

    $scope.pages =
        request:
            requestAmounts: [20, 40, 60]
            makeRequest: (amount) ->
                console.log "Request made for amount:", amount
                amount = Math.max(0, parseInt(amount))
                throw new Error("Amount must be of type `Number`.") if _.isNaN(amount)

app.service 'AttAPI', ($http) ->

  _accessToken = 'sWKt5H0SpgTzjzVYgtyqelh6amoTAkSU'

  _makeRequest: (method, uri, callback) ->
    $http({
      method: method,
      url: 'api.att.com' + uri,
      headers: {
        authorization: 'Bearer ' + this._accessToken,
        accept: 'application/json'
      }
    }).success(callback);

  # The Create Message Index method allows the developer to create an index
  # cache for the customer's AT&T Message inbox with prior consent.
  # Input: none
  # Response: none
  createMessage: (callback) ->
    method = 'POST';
    uri = '/messages/index'
    this._makeRequest(method, uri, callback);

  # The Delete Message method gives the developer the ability to delete one
  # specific message from a customer's AT&T Message inbox with prior consent.
  # Input: string messageID
  # Response: none
  deleteMessage: (callback, messageID) ->
    method = 'DELETE';
    uri = '/messages/' + messageID;
    this._makeRequest(method, uri, callback);

  # The Delete Messages method gives the developer the ability to delete one
  # or more messages from a customer's AT&T Message inbox with prior consent.
  # Input: array of strings messageIDs
  # Response: none
  deleteMessages: (callback, messageIDs) ->
    method = 'DELETE';
    uri = '/messages?messageIds=' + messageIDs.join(',');
    this._makeRequest(method, uri, callback);

  # The Get Message method retrieves one specific message from the customer's
  # AT&T Message inbox. For SMS messages, the text of the message will be
  # retrieved as well. For MMS content, use the Get Message Content method.
  # Input: string messageID
  # Response: message
  getMessage: (callback, messageID) ->
    method = 'GET';
    uri = '/messages/' + messageID;
    this._makeRequest(method, uri, callback);

  # The Get Message Content method retrieves media associated with a customer
  # message from the AT&T Message inbox using information returned by the Get
  # Message List method request.
  # Input: string messageID, string partID
  # Response: media content in binary format
  getMessageContent: (callback, messageID, partID) ->
    method = 'GET';
    uri = '/messages/' + messageID + '/parts/' + partID;
    this._makeRequest(method, uri, callback);

  # The Get Message Index Info method allows the developer to get the state,
  # status, and message count of the index cache for the customer's AT&T
  # Message inbox.
  # Input: None
  # Response: None
  getMessageIndexInfo: (callback) ->
    method = 'GET';
    uri = '/messages/index/info';
    this._makeRequest(method, uri, callback);

  getMessageList: (callback) ->
    method = 'GET';
    uri = '/messages';
    this._makeRequest(method, uri, callback);

  getMessageDelta: (callback, state) ->
    method = 'GET';
    uri = '/delta?state=' + state;
    this._makeRequest(method, uri, callback);

  getNotificationConnectionDetails: (callback, queues) ->
    method = 'GET';
    uri = '/notificationConnectionDetails?queues=' + queues;
    this._makeRequest(method, uri, callback);

  sendMessage: (callback, message) ->
    $http({
      method: 'POST',
      url: 'api.att.com/messages',
      data: {
        messageRequest: {
          addresses: [
            "tel:2067472615"
          ],
          text: 'hello world'
        }
      },
      headers: {
        accept: 'application/json',
        authorization: 'Bearer ' + this._accessToken,
        "content-type": 'application/json'
      }
    }).success(callback);

  updateMessage: (callback, messageID) ->
    $http({
      method: 'PUT',
      url: 'api.att.com/messages/' + messageID;
      data: {
        message: {
          isUnread: true
        }
      },
      headers: {
        accept: 'application/json',
        authorization: 'Bearer ' + this._accessToken,
        "content-type": 'application/json'
      }
    }).success(callback);

  updateMessages: (callback, messageIDs) ->
    messageUpdates = [];
    messageUpdates.push({
      messageId: messageID,
      isUnread: true
    }) for messageID in messageIDs;
    $http({
      method: 'PUT',
      url: 'api.att.com/messages/' + messageID;
      data: {
        messages: messageUpdates
      },
      headers: {
        accept: 'application/json',
        authorization: 'Bearer ' + this._accessToken,
        "content-type": 'application/json'
      }
    }).success(callback);
