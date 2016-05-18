app.controller('UserPageController', function($scope, $http, fn) {
  $scope.fn = fn;

  $http.get(window.location.pathname + "/index.json").success(function(response) {
    $scope.showUser(response);
  });

  $scope.comleaders = [
    'ScreapDK',
    'mintsoft',
    'TomBebbington',
    'loganom',
    'bradcater',
    'mattr555',
    'preemeijer',
    'javathunderman',
    'MrChrisW',
    'killerfish',
    'sebasorribas',
    'NickCalabs',
    'haseeb',
    'iambibhas',
    'codenirvana',
    'Jedidiah',
    'hemanth',
    'gautamkrishnar',
    'GuiltyDolphin'
  ];

  $scope.staff = [
    'abeyang',
    'AdamSC1-ddg',
    'alohaas',
    'andrey-p',
    'b1ake',
    'b2ddg',
    'bbraithwaite',
    'bsstoner',
    'chrismorast',
    'daxtheduck',
    'edgesince84',
    'jagtalon',
    'jbarrett',
    'jdorweiler',
    'jkv',
    'kablamo',
    'malbin',
    'marcantonio',
    'MariagraziaAlastra',
    'moollaza',
    'mrshu',
    'nilnilnil',
    'russellholt',
    'tagawa',
    'thm',
    'tommytommytommy',
    'yegg',
    'zachthompson',
    'zekiel'
  ];

// for sorting instant answers (live should be first)
  $scope.iaSort = function(ia) {
      var issues = ia.issues.length;

      if(issues > 0) {
	  var sorted = _.sortBy(ia.issues, function(issue) { return moment().diff(moment(issue.updated_at)); });
	  return -(1/moment().diff(moment(sorted[0].updated_at)));
      }

    switch (ia.dev_milestone) {
      case 'live': return 0;
      case 'complete': return 10;
      case 'testing': return 20;
      case 'development': return 30;
      case 'planning': return 40;
      default: return 1000;
    }
  };

    $scope.iaPriority = function(ia) {
	return ia.issues.length;
    }

  var initial = false;

  // given a username, fill out the $scope variables appropriately, like IAs, etc.
  $scope.showUser = function(response) {
    $scope.response = response;
    $scope.count = {};
    $scope.topics = [];

    $scope.role = 'regular';

    if ($scope.staff.indexOf($scope.response.gh_data.login) !== -1) {
        $scope.role = 'staff';
    } else if ($scope.comleaders.indexOf($scope.response.gh_data.login) !== -1) {
        $scope.role = 'comleader';
    }

    $scope.imgUrl = 'https://duckduckgo.com/t/userpage_' + $scope.role + '_' + $scope.response.gh_data.login;

    $scope.newImg = new Image();
    $scope.newImg.src = $scope.imgUrl + '?' + Math.ceil(Math.random() * 1e7);

    $scope.addImg = function(pre_id, element_id) {
      var randomNum = Math.ceil(Math.random() * 1e7);
      pre_id = pre_id? '_' + pre_id : '';
      element_id = element_id? '_' + element_id.replace(/[^0-9A-Za-z]/g, '') : '';
      var imgUrlSuffix = pre_id + element_id + '?' + randomNum;

      $scope.newImg = new Image();
      $scope.newImg.src = $scope.imgUrl + imgUrlSuffix;
    };

    $scope.ias = [];
    _.each(response.ia, function(element, index) {
      $scope.ias = $scope.ias.concat(element);
    });

    _.each($scope.ias, function(ia) {
      if(ia.dev_milestone === "development") {
        ia.dev_milestone = "dev";
      }
    });

    $scope.ias_developed_only = _.filter($scope.ias, function(ia) {
      return _.find(ia.developer, function(dev) {
        return (dev.name === response.gh_data.login || dev.name === response.gh_data.name) && dev.type === "github";
      }) && ia.dev_milestone !== "ghosted";
    });

    $scope.prs_open = _.filter(response.pulls, function(pull) {
      return pull.state === "open";
    });

    $scope.prs_open_developed = _.filter(response.pulls_created, function(pull) {
      return pull.state === "open" && !pull.ia_id;
    });
    $scope.prs_open_reviewed = _.filter(response.pulls_assigned, function(pull) {
      return pull.state === "open";
    });


    $scope.maintained = _.filter(response.maintained, function(ia) {
      return ia.dev_milestone !== "ghosted";
    });

      $scope.mapIssues = {};

      _.each($scope.maintained.concat($scope.ias_developed_only), function(ia) {
	  ia.issues = [];

	  _.each(response.issues_assigned, function(v, k) {
	      if(v.ia_id === ia.id) {
		  ia.issues = ia.issues.concat(v);
	      }
	  });

	  // Also add the PRs in here.
	  _.each(response.pulls_assigned, function(pull) {
	      if(pull.ia_id === ia.id) {
		  ia.issues = ia.issues.concat(pull);
	      }
	  });

	  _.each(response.pulls_created, function(pull) {
	      if(pull.ia_id === ia.id) {
		  ia.issues = ia.issues.concat(pull);
	      }
	  });

	  _.each(response.pulls_other, function(pull) {
	      if(pull.ia_id === ia.id) {
                  ia.issues = ia.issues.concat(pull);
              }
	  });

	  _.each(response.issues_other, function(v, k) {
	      if(v.ia_id === ia.id) {
                  ia.issues = ia.issues.concat(v);
              }
	  });

	  _.each(ia.issues, function(issue) {
	      if(issue.title.length > 70) {
		  issue.title = issue.title.substring(0, 70) + "...";
	      }

	      if(issue.tags) {
		  var hasMaintainerApproved = _.filter(issue.tags, function(tag) {
		      if(tag.name === "Maintainer Input Requested") {
			  return true;
		      }
		  }).length > 0;
		  issue.hasMaintainer = hasMaintainerApproved;
	      }
	  });


	  _.each(ia.issues, function(issue) {
	      $scope.mapIssues[issue.id] = true;
	  });
      });

      $scope.issues_unassigned = _.filter(response.issues_assigned, function(v, k) {
	  return !v.ia_id;
      });

    $scope.count.maintained_ias = _.size($scope.maintained);
    $scope.count.developed_only_ias = _.size($scope.ias_developed_only);
    $scope.count.open_issues = _.size(response.issues_assigned);
    $scope.count.closed_issues = _.size(response.issues) - $scope.count.open_issues;
    $scope.count.open_prs = _.size($scope.prs_open);
    $scope.count.reviewed_prs = _.size(response.pulls_assigned);
    $scope.count.developed_prs = _.size(response.pulls_assigned);
    $scope.count.closed_prs = response.closed_pulls;
    $scope.count.ias = _.size($scope.ias)
      $scope.count.filtered = _.filter($scope.maintained.concat($scope.ias_developed_only), function(ia) {
	  return ia.issues.length > 0;
      }).length;

    $scope.ias_maintained = response.maintained;

    $scope.topics = _.map(response.topics, function(key, num) {
      return {count: key, topic: num};
    });

    $scope.count.total_ias = (function() {
      var all = {};
      _.each($scope.maintained.concat($scope.ias_developed_only), function(ia) {
        all[ia.id] = true;
      });

      return _.size(all);
    }());

    var maxtopic = _.max($scope.topics, function(topic) {
      return topic.count;
    });

    $scope.count.max_topics = maxtopic.count;

    // by default. for 'filterable'
    $scope.show_ias = ($scope.count.maintained_ias) ? $scope.maintained : $scope.ias_developed_only;

      $scope.changeShownIAs = function(which, open) {
	  if(open) {
	      $scope.show_ias = _.filter(which, function(ia) {
		  ia.expand = true;
		  return ia.issues.length > 0;
	      });
	  } else {
	      $scope.show_ias = _.each(which, function(ia) {
		  ia.expand = false;
	      });
	  }

	  var objKey = _.findKey($scope, which);
	  if(objKey) {
	      $scope.addImg(objKey.replace(/_/g, ''));
	  }
      };
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

    // return the first char in a dev's username (for when avatar is not available)
    firstUsernameChar: function(username) {
      username = username ? username.charAt(0) : '';
      return username;
    },
    // get developers based on an instant answer; returns html
    getDevs: function(ia) {
      var html = '';
      _.each(ia.developer, function(dev) {
        html += '<span>' + dev.name + ' </span>';
      });
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
      return moment().diff(moment(datetimestr), 'days') + "d";
    }

  };
});
