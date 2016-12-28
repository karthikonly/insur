$(function() {
  function success(data) {
    $('div#treeview').treeview(data);
  };
  $.getJSON("/home/treeview_data_json", "", success);
});