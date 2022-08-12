require('@rails/ujs').start()
require('turbolinks').start()
require('@rails/activestorage').start()
require('channels')
require('jquery')
require('bootstrap')
import I18n from 'i18n-js'
window.I18n = I18n

$(document).ready(function() {
  $('#micropost_picture').bind('change', function () {
    var size_in_megabytes = this.files[0].size / 1024 / 1024;
    if (size_in_megabytes > 5) {
      alert(I18n.t('img_size_alert'));
    }
  });
});
