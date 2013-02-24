angular.module('dashboardApp', ['LocalStorageModule','DashboardModule', 'JenkinsModule', 'ui'])
.config ($routeProvider) ->
   	$routeProvider
    .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'

    .when '/dashboard/:name',
        templateUrl: 'views/dashboard.html'
        controller: 'DashCtrl'
    .otherwise
        redirectTo: '/'

