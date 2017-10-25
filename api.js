var app = angular.module('myApp', ['ngAnimate']);
app.controller('customersCtrl', function ($scope, $http, $timeout) {

    //$scope.popTxt = "";

    $scope.id = 0;
    $scope.name = "";
    $scope.surname = "";
    $scope.email = "";
    $scope.timestamp = "";

    $scope.success = false;
    $scope.failure = false;

    var pageSize = 10;

    $scope.orderBy = "id desc";
    $scope.page = 1;

    $scope.searchOptions = false;
    $scope.searchText = "Search Options >>";

    $scope.displayOptions = false;

    $scope.baseURL = "http://snig.gr/api/";


    $scope.searchProps = function () {
        $timeout(function () {
            $scope.success = false;
            $scope.failure = false;
        }, 600)
        var searchURL = $scope.baseURL + "list.aspx?page=" + $scope.page + "&limit=" + pageSize + "&orderby=" + $scope.orderBy;
        $http.get(searchURL)
    .then(function (response) { $scope.pages = Math.ceil(response.data.recordcount / pageSize); $scope.users = response.data.records; if ($scope.page == 1) { $scope.btnP = true; $scope.prevTxt = ""; } else { $scope.btnP = false; $scope.prevTxt = "<< Previous"; } if ($scope.page >= $scope.pages) { $scope.btnN = true; $scope.nextTxt = ""; } else { $scope.btnN = false; $scope.nextTxt = "Next >>"; } if (response.data.records.length == 0) { $scope.prevPage() } })
    };

    $scope.nextPage = function () {
        $scope.page += 1;
        $scope.searchProps();
    };

    $scope.prevPage = function () {
        if ($scope.page > 1) { $scope.page -= 1 };
        $scope.searchProps();
    };

    $scope.orderby = function (order) {
        $scope.page = 10;
        $scope.orderBy = order;
        $scope.searchProps();
    }

    $scope.searchProps();

    

    $scope.toggleSearch = function () {
        if ($scope.searchOptions == false) {
            $scope.hide();
            $scope.searchOptions = true;
            $scope.searchText = "<< Hide";
        } else {
            $scope.searchOptions = false;
            $scope.searchText = "Search Options >>";
        }
    }

    $scope.delete = function (id) {
    var delURL = $scope.baseURL + "delete.aspx?id=" + id;
    $http.get(delURL)
    .then(function (response) { if (response.data.result == "false") { $scope.failure = true; } else { $scope.success = true; } $scope.searchProps(); })
    };

    $scope.display = function (id) {

        if ($scope.searchOptions == true) { $scope.toggleSearch(); }

        var dispURL = $scope.baseURL + "user.aspx?id=" + id;
        $http.get(dispURL)
    .then(function (response) { $scope.id = id; $scope.name = response.data.name; $scope.surname = response.data.surname; $scope.email = response.data.email; $scope.timestamp = response.data.timestamp; $scope.displayOptions = true; })
    };

    $scope.hide = function () {

        $scope.displayOptions = false;

    };

    $scope.update = function () {

        var updURL = $scope.baseURL + "update.aspx";
        var data = $.param({
            id: $scope.id,
            name: $scope.name,
            surname: $scope.surname,
            email: $scope.email
        });

        var config = {
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8;'
            }
        }
        $http.post(updURL, data, config)
    .then(function (response) { if (response.data.result == "error") { $scope.failure = true; alert(response.data.result + " - " + response.data.reason); } else { $scope.success = true; } $scope.hide(); $scope.searchProps(); })

    };


});
