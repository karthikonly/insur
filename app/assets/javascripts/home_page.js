$(function() {
  function success(data) {
    $('div#treeview').treeview({data: data});
  };
  $.getJSON("/home/home_treeview_data", "", success);
});