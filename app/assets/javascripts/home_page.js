$(function() {
  function success(data) {
    $('div#treeview').treeview(data);
  };
  $.getJSON("/home/treeview_data_json", "", success);
});

$(function() {
  setTimeout(function() {
    $('#multi_update').submit();
    }, 60000);
});