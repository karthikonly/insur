$(function() {
  alert('hello');
  var json = <%= raw(@json_data) %>;
  var $tree = $('#treeview12').treeview({
    data: json
  });
});
