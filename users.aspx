<%@ Page Language="C#" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="style/api.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.0/jquery.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular-animate.js"></script>
    <script src ="js/api.js"></script>
</head>
<body ng-app="myApp" ng-controller="customersCtrl">
<div class="userDetails" ng-show="displayOptions" ><a href="javascript:void(0)" ng-click="hide()"><< Hide</a><br /><form ng-submit="update()"><table><tr><td>Name:</td><td><input type="text" ng-model="name" /></td></tr><tr><td>Surname:</td><td><input type="text" ng-model="surname" /></td></tr><tr><td>Email:</td><td><input type="text" ng-model="email" /></td></tr><tr><td>Record Created:</td><td>{{timestamp}}</td></tr><tr><td colspan="2"><input type="submit" value="Update" /></td></tr></table></form></div>         
<div class='searchOver' ><a href="javascript:void(0)" ng-click="toggleSearch()">{{searchText}}</a> :: <a href="javascript:void(0)" ng-click="display(-1)">New User >></a></div>
<div class="searchDiv" ng-show="searchOptions" >
<table><tr><td>Order by:</td><td><select ng-model="orderBy" ng-change="page=1;searchProps();"><option selected value="id desc">Most Recent</option><option value="name">Name</option><option value="surname">Surname</option></select></td></tr></table>
</div>
<div class='prev'><a href="javascript:void(0)" ng-click='prevPage()'>{{prevTxt}}</a></div><div class='pages'>Page {{ page }} of {{pages}}</div><div class='next'><a href="javascript:void(0)" ng-click='nextPage()'>{{nextTxt}}</a></div>
<hr />
<div id='results'><table width="100%"><tr class="heading"><td>Name</td><td colspan="2">Email</td></tr><tr class="user" ng-repeat="x in users"><td><a href="javascript:void(0)" ng-click="display(x.id)">{{x.name}} {{x.surname}}</a></td><td>{{x.email}}</td><td align="right"><a href="javascript:void(0)" ng-click="delete(x.id)">delete</a></td></tr></table></div>
<hr/>
<div class='prev'><a href="javascript:void(0)" ng-click='prevPage()'>{{prevTxt}}</a></div><div class='pages'>Page {{ page }} of {{pages}}</div><div class='next'><a href="javascript:void(0)" ng-click='nextPage()'>{{nextTxt}}</a></div>
</body>
</html>
