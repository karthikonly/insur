$(function() {
  $('div#treeview').treeview(treeview_data);
});

$(function() {
  $('div#treeview a').on('click', function(e) {
    e.preventDefault();
    alert($(this).text());
  });
});

  // $("div#treeview span.badge").delay(500).filter(function(index, element) {
  //   return index == 0;
  // }).addClass('first');
  // $("div#treeview span.badge").filter(function(index, element) {
  //   return index == 1;
  // }).addClass('second');
