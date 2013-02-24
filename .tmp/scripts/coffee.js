(function() {

  angular.module('dashboardApp', ['LocalStorageModule', 'DashboardModule', 'JenkinsModule', 'ui']).config(function($routeProvider) {
    return $routeProvider.when('/', {
      templateUrl: 'views/main.html',
      controller: 'MainCtrl'
    }).when('/dashboard/:name', {
      templateUrl: 'views/dashboard.html',
      controller: 'DashCtrl'
    }).otherwise({
      redirectTo: '/'
    });
  });

}).call(this);

(function() {

  angular.module('dashboardApp').controller('MainCtrl', function($scope, DashboardManager) {
    $scope.dashboards = DashboardManager.getDashboards();
    return $scope.newDash = function() {
      DashboardManager.createDashboard($scope.newName);
      return $scope.newName = null;
    };
  });

  angular.module('dashboardApp').controller('DashCtrl', function($scope, $routeParams, DashboardManager, Jenkins) {
    var item, _i, _len, _ref, _results;
    $scope.dashboard = DashboardManager.getDashboard($routeParams.name);
    _ref = $scope.dashboard.items;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      item = _ref[_i];
      _results.push(item.load(Jenkins));
    }
    return _results;
  });

  angular.module('dashboardApp').controller('DashParamsCtl', function($scope, Jenkins, DashboardManager) {
    Jenkins.getJobs(function(jobs) {
      return $scope.jenkinsJobs = jobs;
    });
    $scope.addJenkinsJob = function(job) {
      job = JSON.parse(job);
      return DashboardManager.addJenkinsJob(job.name, job.url);
    };
    return $scope.saveDashboard = function() {
      return DashboardManager.saveCurrentDashboard();
    };
  });

}).call(this);

(function() {
  'use strict';

  var Dashboard, DashboardItem, DashboardItemJenkinsJob, DashboardSerializer,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Dashboard = (function() {

    function Dashboard(name) {
      this.name = name;
      this.items = [];
    }

    Dashboard.prototype.addItem = function(item) {
      return this.items.push(item);
    };

    return Dashboard;

  })();

  DashboardItem = (function() {

    function DashboardItem(name, type) {
      this.name = name;
      this.type = type;
    }

    return DashboardItem;

  })();

  DashboardItemJenkinsJob = (function(_super) {

    __extends(DashboardItemJenkinsJob, _super);

    function DashboardItemJenkinsJob(name, url) {
      this.url = url;
      DashboardItemJenkinsJob.__super__.constructor.call(this, name, 'jenkins');
    }

    DashboardItemJenkinsJob.prototype.load = function(jenkins) {
      var _this = this;
      return jenkins.getJob(this.url, function(info) {
        _this.info = info;
        return jenkins.getBuild(_this.info.lastBuild.url, function(build) {
          return _this.build = build;
        });
      });
    };

    return DashboardItemJenkinsJob;

  })(DashboardItem);

  DashboardSerializer = {
    serialize: function(dashboard) {
      var item, jsonObj, _i, _len, _ref;
      jsonObj = {
        name: dashboard.name,
        items: []
      };
      _ref = dashboard.items;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        jsonObj.items.push(this.serializeItem(item));
      }
      return JSON.stringify(jsonObj);
    },
    serializeItem: function(item) {
      var jsonObj;
      jsonObj = {
        name: item.name,
        type: item.type
      };
      switch (item.type) {
        case 'jenkins':
          jsonObj = this.serializeJenkinsItem(item, jsonObj);
      }
      return jsonObj;
    },
    serializeJenkinsItem: function(item, jsonObj) {
      jsonObj.url = item.url;
      return jsonObj;
    },
    deserialize: function(json) {
      var item, jsonObj, obj, _i, _len, _ref;
      if (!(json != null)) {
        return null;
      }
      jsonObj = JSON.parse(json);
      obj = new Dashboard(jsonObj.name);
      _ref = jsonObj.items;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        obj.addItem(this.deserializeItem(item));
      }
      return obj;
    },
    deserializeItem: function(item) {
      var obj;
      obj = null;
      switch (item.type) {
        case 'jenkins':
          obj = this.deserializeJenkinsItem(item);
      }
      return obj;
    },
    deserializeJenkinsItem: function(item) {
      var obj;
      return obj = new DashboardItemJenkinsJob(item.name, item.url);
    }
  };

  angular.module('DashboardModule', []).factory('DashboardManager', function(localStorageService) {
    var instance;
    return instance = {
      dashboards: null,
      currentDashboard: null,
      test: function() {
        var a, c;
        c = new DashboardItemJenkinsJob('job2', 'http://test.fr');
        console.log(c);
        a = new Dashboard('toto');
        a.addItem(c);
        console.log(a);
        a = DashboardSerializer.serialize(a);
        console.log(a);
        a = DashboardSerializer.deserialize(a);
        return console.log(a);
      },
      getDashboards: function() {
        var _ref;
        this.dashboards = JSON.parse(localStorageService.get('dashboards'));
        return (_ref = this.dashboards) != null ? _ref : this.dashboards = [];
      },
      createDashboard: function(name) {
        this.dashboards.push({
          name: name
        });
        return localStorageService.add('dashboards', JSON.stringify(this.dashboards));
      },
      getDashboard: function(name) {
        this.currentDashboard = DashboardSerializer.deserialize(localStorageService.get(name));
        if (!(this.currentDashboard != null)) {
          this.currentDashboard = new Dashboard(name);
        }
        return this.currentDashboard;
      },
      addJenkinsJob: function(name, url) {
        return this.currentDashboard.addItem(new DashboardItemJenkinsJob(name, url));
      },
      saveCurrentDashboard: function() {
        return localStorageService.add(this.currentDashboard.name, DashboardSerializer.serialize(this.currentDashboard));
      }
    };
  });

}).call(this);

(function() {
  'use strict';

  angular.module('JenkinsModule', []).factory('Jenkins', function($http) {
    var instance;
    return instance = {
      getJobs: function(callback) {
        return $http.jsonp('https://builds.apache.org/api/json/?jsonp=JSON_CALLBACK').success(function(data) {
          return callback(data.jobs);
        });
      },
      getJob: function(url, callback) {
        return $http.jsonp(url + '/api/json/?jsonp=JSON_CALLBACK').success(function(data) {
          return callback(data);
        });
      },
      getBuild: function(url, callback) {
        return $http.jsonp(url + '/api/json/?jsonp=JSON_CALLBACK').success(function(data) {
          return callback(data);
        });
      }
    };
  });

}).call(this);

(function() {



}).call(this);
