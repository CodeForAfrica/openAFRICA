"use strict";

ckan.module("datamx_load_apps", function($, _) {
  return {
    initialize: function() {
      var organization = this.options.organization;
      var api_url = "http://cmx-apps.herokuapp.com/v1/apps.json";
      var that = this;

      $.proxyAll(this, /_on/);

      // Get the apps from the APPs API
      $.ajax({
        url: api_url,
        data: {"organization": organization},
        success: function (data) {
          var index = 0;
          for(index in data) {
            that.sandbox.client.getTemplate("datamx_application_frame.html", data[index], that._onReceiveSnippet);
          }
        }
      });
    },

    _onReceiveSnippet: function(html) {
      console.log(html);
      this.el.append(html);
    }
  };
});
