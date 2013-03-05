angular.module('dashboardApp', ['$strap', 'LocalStorageModule','DashboardModule', 'JenkinsModule', 'TravisCiModule', 'ui'])
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

