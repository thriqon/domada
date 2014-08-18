(function() {
  var addHandlerForNotificationEnabler, notificationTemplates, refreshNotificationEnabler, showNotificationFor, storeUserEnabled, storedUserEnabledness, toggleUserEnabledness;

  notificationTemplates = {
    work: {
      title: "Pomodoro",
      body: "It's time to do some work now"
    },
    "short-break": {
      title: "Break",
      body: "You worked a lot, take a break now"
    },
    "long-break": {
      title: "Longer Break",
      body: "You did it! Another full Pomodoro Set! You really earned your break now."
    }
  };

  storedUserEnabledness = function() {
    return localStorage.usingNotifications === 'true';
  };

  storeUserEnabled = function() {
    return localStorage.usingNotifications = 'true';
  };

  toggleUserEnabledness = function() {
    var _ref;
    return localStorage.usingNotifications = (_ref = storedUserEnabledness()) != null ? _ref : {
      "false": true
    };
  };

  refreshNotificationEnabler = function() {
    var element, setEnablednessTo, setIcon;
    element = document.getElementById('enable-notifications');
    setIcon = function(name) {
      return element.querySelector('i').setAttribute('class', 'glyphicon glyphicon-' + name);
    };
    setEnablednessTo = function(val) {
      return element.classList.toggle('disabled', val);
    };
    if (!window.Notification) {
      setIcon('remove');
      return setEnablednessTo(false);
    } else {
      if (Notification.permission === 'denied') {
        setIcon('remove');
        return setEnablednessTo(false);
      } else if (Notification.permission === 'granted' && storedUserEnabledness()) {
        setIcon('check');
        return setEnablednessTo(true);
      } else {
        setIcon('unchecked');
        return setEnablednessTo(true);
      }
    }
  };

  addHandlerForNotificationEnabler = function() {
    var element;
    element = document.getElementById('enable-notifications');
    return element.addEventListener('click', function() {
      if (Notification.permission === 'granted') {
        toggleUserEnabledness();
        return refreshNotificationEnabler();
      } else {
        return Notification.requestPermission(function(answer) {
          if (answer === 'granted') {
            storeUserEnabled();
          }
          return refreshNotificationEnabler();
        });
      }
    });
  };

  showNotificationFor = function(type) {
    var notification;
    if (storedUserEnabledness() && Notification.permission === 'granted') {
      notification = new Notification(notificationTemplates[type].title, {
        body: notificationTemplates[type].body,
        icon: "bowl-of-soup.png"
      });
      notification.onclick = function() {
        return notification.close();
      };
      return setTimeout((function() {
        return notification.close();
      }), 5000);
    }
  };

  document.addEventListener("DOMContentLoaded", function() {
    refreshNotificationEnabler();
    return addHandlerForNotificationEnabler();
  });

  document.addEventListener("PomodoroPartStarted", function(e) {
    return showNotificationFor(e.detail.type);
  });

}).call(this);
