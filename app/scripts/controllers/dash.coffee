# dashboard controller
angular.module('dashboardApp')
 .controller 'DashCtrl',  ($scope, $routeParams, DashboardManager, Jenkins) ->

    $scope.dashboard = DashboardManager.getDashboard($routeParams.name)
    DashboardManager.loadDashboard()

    $scope.timer = setInterval () =>
        DashboardManager.loadDashboard()
    , $scope.dashboard.refreshInterval

    $scope.$on '$destroy', (event) =>
        clearInterval($scope.timer)

    $scope.selectItemAction = (item) ->
        $scope.selectedItem = item

    $scope.saveDashboardAction = () ->
        DashboardManager.saveCurrentDashboard()








