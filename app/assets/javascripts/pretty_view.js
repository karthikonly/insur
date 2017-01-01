$(function() {
  $('div#treeview').treeview(treeview_data);
  $('#treeview').on('nodeSelected', nodeSelectionHandler);
});

function nodeSelectionHandler(event, node) {
  alert([node.is_folder, node.href, node.text, node.icon].join());
}

