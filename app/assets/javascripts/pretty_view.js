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

function treeDataHandler(data, status) {
  // alert('Tree Update Status: ' + status);
  $('div#treeview').treeview(data);
  $('#treeview').on('nodeSelected', nodeSelectionHandler);
  $('#treeview').treeview('selectNode', [selected_node.nodeId, { silent: true}]);
  var node = selected_node;
  while(node)
  {
    $('#treeview').treeview('expandNode', [node.nodeId, { silent: true}]);
    node = $('#treeview').treeview('getParent', node);
  }
};

function multiUpdatePostHandler(data, status) {
  // alert('Update Status: ' + status);
  $.getJSON("/home/treeview_data_json", "", treeDataHandler);
}

function add_nodes_to_data_hash(data_hash, nodes, counter, review_done, component_id) {
  counter = 0;
  node = nodes.pop();
  while(node) {
    console.log(node.text);
    if (!node.is_folder) {
      data_hash[counter.toString()] = {
        id: node.href,
        review_done: review_done,
        component_id: component_id
      }
      counter++;
    }
    else {
      // console.log(node.nodes);
      nodes.push.apply(nodes, node.nodes);
    }
    node = nodes.pop();
  }
  // alert(selected_node.text + " is folder. not handled now.");
}

function clickHandler() {
  if (!selected_node) {
    alert('Make a selection first');
    return;
  }
  // console.log(selected_node);
  update_data = new Object();
  review_done = $('table.property #reviewed').prop('checked');
  component_id = $('table.property select#component').val();
  add_nodes_to_data_hash(update_data, [selected_node], 0, review_done, component_id);
  // console.log(update_data);
  $.post(
    "/file_infos/multi_update",
    { file_infos: update_data },
    multiUpdatePostHandler
  );
}
