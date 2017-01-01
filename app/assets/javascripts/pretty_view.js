$(function() {
  $('div#treeview').treeview(treeview_data);
  $('#treeview').on('nodeSelected', nodeSelectionHandler);
  $('table.property button#change').on('click', clickHandler);
});

var selected_node = null;
function nodeSelectionHandler(event, node) {
  selected_node = node;
  $('table.property #is_folder').text(node.is_folder);
  $('table.property #loc').text(node.loc);
  $('table.property #files').text(node.files);
  $('table.property #obj_name').text(node.text);
  $('table.property #reviewed').prop('checked', node.reviewed);
  $('table.property select#component').val(node.component_id);
}

function multiUpdatePostHandler(data, status) {
  alert('Status: ' + status);
}

function clickHandler() {
  if (!selected_node) {
    alert('Make a selection first');
  }
  else if(selected_node.is_folder) {
    alert(selected_node.text + " is folder. not handled now.");
  }
  else {
    $.post(
      "/file_infos/multi_update",
      {
        file_infos: {
          '0': { id: '585d104fb88b40ae57e86da0', review_done: true, component_id: '585d0af8b88b40a8c69b83ad'}
        }
      },
      multiUpdatePostHandler
    );
    alert("file:" + selected_node.text);
  }

}
