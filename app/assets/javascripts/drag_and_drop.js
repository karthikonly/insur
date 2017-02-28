$(document).on('click','#home_button', function() {
  window.location.href = "/";
});

function build_content_json()
{
  content = [];
  $("div.element").each(function(index) {
    content.push($(this).data("data_content"));
  });
  $("#debug").text(JSON.stringify(content));
}

$(document).on('click','#save_and_preview', function() {
  build_content_json();
  // TBD: ajax call to save_and_preview
});

$(document).on('click','#save_only', function() {
  build_content_json();
  // TBD: ajax call to save
});

var total_element = 0;
$(document).on('click','#new_element', function() {
  var $div = $("<div/>")
              .attr("class", "ui-widget-content element")
              .data("data_content", {
                var_name: total_element, display_name: "Element"+total_element,
                mandatory: "true", data_type: "integer", default_value: "default", control: "number_field"
                })
              .html("Element"+total_element);
  total_element++;
  $('#playground').append($div);
  $div.draggable({snap: true});
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
  $("#debug").text(JSON.stringify(data));
  $("#properties #var_name").val(data.var_name);
  $("#properties #display_name").val(data.display_name);
  $("#properties #mandatory").val(data.mandatory);
  $("#properties #data_type").val(data.data_type);
  $("#properties #default_value").val(data.default_value);
  $("#properties #control").val(data.control);
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
  $("#debug").text(JSON.stringify(data_content));
}