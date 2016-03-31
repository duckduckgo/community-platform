app.controller('UserPageController', function($scope, $http, fn) {
    $scope.fn = fn;

    $http.get(window.location.pathname + "/index.json").success(function(response) {
	$scope.showUser(response);
    });

    // for sorting instant answers (live should be first)
    $scope.iaSort = function(ia) {
	switch (ia.dev_milestone) {
	case 'live': return 0;
	case 'complete': return 10;
	case 'testing': return 20;
	case 'development': return 30;
	case 'planning': return 40;
	default: return 1000;
	}
    };

    var initial = false;

    // given a username, fill out the $scope variables appropriately, like IAs, etc.
    $scope.showUser = function(response) {
	$scope.response = response;
	$scope.count = {};
	$scope.topics = [];

	$scope.ias_developed_only = _.filter(response.ia.live, function(ia) {
	    return _.find(ia.developer, function(dev) {
		return dev.name === response.gh_data.login && dev.type === "github";
	    });
	});

	$scope.prs_open = _.filter(response.pulls, function(pull) {
	    return pull.state === "open";
	});

	$scope.count.maintained_ias = _.size(response.maintained);
	$scope.count.developed_only_ias = _.size($scope.ias_developed_only);
	$scope.count.open_issues = _.size(response.issues);
	// $scope.count.closed_issues = _.size($scope.user.issues) - $scope.count.open_issues;
	$scope.count.open_prs = _.size($scope.prs_open);
	// $scope.count.reviewed_prs = _.size($scope.prs_open_reviewed);
	// $scope.count.developed_prs = _.size($scope.prs_open_developed);
	$scope.count.closed_prs = _.size(response.pulls) - $scope.count.open_prs;

	var maxtopic = _.max($scope.topics, function(topic){ return topic.amount; });
	$scope.count.max_topics = maxtopic.amount;

	// by default. for 'filterable'
	$scope.show_ias = ($scope.count.maintained_ias) ? response.maintained : $scope.ias_developed_only;
    }
});

// helper functions
app.factory('fn', function() {
    return {
	// given an array, search for an attr (like 'username'): if found, return object
	findByAttr: function(arr, attr, name) {
	    return _.find(arr, function(obj) {
		return obj[attr] == name;
	    });
	},
	// get avatar image. If not found, uses first letter from devname
	getAvatar: function(users, username, align) {
	    var html = '';
	    if (username) {
		html = '<div class="avatar ' + align + '" title="' + username + '"';
		var user = this.findByAttr(users, 'username', username);

		if (user && user.avatar) html += '><img src="avatars/' + user.avatar + '" /></div>';
		else html += "><span>" + username.charAt(0) + '</span></div>';
	    }

	    return html;
	},
	// get developers based on an instant answer; returns html
	getDevs: function(ia) {
	    var html = '';
	    _.each(ia.developer, function(dev) {
		html += '<span>' + dev.name + ' </span>';
	    });
	    return html;
	},
	// get developers based on an instant answer; returns avatars
	getDevsAvatars: function(ia, users, skipname) {
	    var html = '';
	    _.each(ia.developer, function(dev) {
		// console.log(skipname + ' | ' + dev.name);
		if (skipname != dev.name) html += this.getAvatar(users, dev.name, '');
	    }, this);
	    return html;
	},
	// get topics based on an instant answer; returns html
	getTopics: function(ia) {
	    var html = '';
	    _.each(ia.topic, function(topic) {
		html += '<span>' + topic + ' </span>';
	    });
	    return html;
	},
	// get labels based on an issue; returns html
	getLabels: function(issue) {
	    var html = '';
	    _.each(issue.labels, function(label) {
		html += '<span>' + label.name + '; </span>';
	    });
	    return html;
	},
	// get "time ago" from date
	getFromNow: function(datetimestr) {
            return moment(datetimestr).fromNow();
        }

    };
});
