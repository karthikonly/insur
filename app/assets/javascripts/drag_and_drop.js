$(document).on('click','#home_button', function() {
  window.location.href = "/";
});

function build_content_json()
{
  content = [];
  $("div.element").each(function(index) {
    content.push($(this).data("data_content"));
  });
  $("#debug").html(JSON.stringify(content, null, ' '));
  return { drag: { saved: true, content: content}};
}

$(document).on('click','#save_and_preview', function() {
  data = build_content_json();
  $.ajax({
    url: "/drags/"+id+"/save_and_preview",
    type: "PUT",
    dataType: "HTML",
    data: JSON.parse(JSON.stringify(data)),
    success: function(returnData) {
      $("#debug").append("API succeeded.");
      console.log(returnData);
      $("#preview").html(returnData);
    },
    error: function() {
      $("#debug").append("An error occured in save.");
    }
  });
});

$(document).on('click','#save_only', function() {
  data = build_content_json();
  $.ajax({
    url: "/drags/"+id+".json",
    type: "PUT",
    data: JSON.parse(JSON.stringify(data)),
    success: function(returnData) {
      $("#debug").append("received data: " + JSON.stringify(returnData));
    },
    error: function() {
      $("#debug").append("An error occured in save.");
    }
  });
});

$(document).on('click','#delete_element', function() {
  $("div.current.element").remove();
});

$(document).ready(function() {
  var data_content = null;
  Object.keys(content).forEach(function (key) {
    data_content = content[key];
    add_new_element(data_content);
  })
});

var total_element = 0;
function add_new_element(data_content) {
  var $div = $("<div/>")
              .attr("class", "ui-widget-content element")
              .data("data_content", data_content)
              .html(data_content.display_name);
  $('#playground').append($div);
  $div.draggable({snap: true});
  total_element++;
}

$(document).on('click','#new_element', function() {
  var data_content = { var_name: total_element, display_name: "Element"+total_element,
                mandatory: "true", data_type: "integer", default_value: "default", control: "number_field" };
  add_new_element(data_content);
});

$(document).on('click',".element", function() {
  $("div.current.element").removeClass("current");
  $(this).addClass("current");
  var data = $(this).data("data_content");
  data_to_dom(data);
});

$(document).on('change','#properties :input', dom_to_data);
$(document).on('keyup','#properties :input', dom_to_data);

function data_to_dom(data) {
  $("#properties #var_name").val(data.var_name);
  $("#properties #display_name").val(data.display_name);
  $("#properties #mandatory").val(data.mandatory);
  $("#properties #data_type").val(data.data_type);
  $("#properties #default_value").val(data.default_value);
  $("#properties #control").val(data.control);
  $("#debug").html(JSON.stringify(data, null, ' '));
}

function dom_to_data() {
  var data_content = new Object();
  data_content.var_name = $("#properties #var_name").val();
  data_content.display_name = $("#properties #display_name").val();
  data_content.mandatory = $("#properties #mandatory").val();
  data_content.data_type = $("#properties #data_type").val();
  data_content.default_value = $("#properties #default_value").val();
  data_content.control = $("#properties #control").val();
  $("div.current.element").data("data_content", data_content);
  $("div.current.element").html(data_content.display_name);
  $("#debug").html(JSON.stringify(data_content, null, ' '));
}