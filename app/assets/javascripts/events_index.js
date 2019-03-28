// <div id="all_events">
//   <ol>
//     <% @events.each do |event| %>
//       <li>
//         <%= link_to event.name, event_path(event) %>, by:
//         <%= link_to User.find(event.admin_id).username, user_path(event.admin_id) %>
//       </li>
//     <% end %>
//   </ol>
// </div>

function display_all_events() {
  $.ajax({
    url: '/events.json',
    method: 'GET'
  })
  .done(function(events) {
    debugger;
  })
  $('#all_events')
}

$(function() {
  display_all_events();
});
