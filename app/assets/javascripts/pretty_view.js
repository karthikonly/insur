$(function() {
  $('div#treeview').treeview(treeview_data);
  $('#treeview').on('nodeSelected', nodeSelectionHandler);
  $('#treeview').treeview('selectNode', [0, { silent: false}]);
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
  treeview_data = data;
  $('div#treeview').treeview(treeview_data);
  $('#treeview').on('nodeSelected', nodeSelectionHandler);
  $('#treeview').treeview('selectNode', [selected_node.nodeId, { silent: true}]);
  $('#treeview').treeview('revealNode', [selected_node.nodeId, { silent: true}]);
  $('#treeview').treeview('expandNode', [selected_node.nodeId, { silent: true}]);
};

function multiUpdatePostHandler(data, status) {
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
      nodes.push.apply(nodes, node.nodes);
    }
    node = nodes.pop();
  }
}

function clickHandler() {
  if (!selected_node) {
    alert('Make a selection first');
    return;
  }
  update_data = new Object();
  review_done = $('table.property #reviewed').prop('checked');
  component_id = $('table.property select#component').val();
  add_nodes_to_data_hash(update_data, [selected_node], 0, review_done, component_id);
  $.post(
    "/file_infos/multi_update",
    { file_infos: update_data },
    multiUpdatePostHandler
  );
}
