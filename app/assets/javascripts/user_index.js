
function display_users() {
  $('#users').append(
    `
    <ol>
      <li>
        "USER 1"
      </li>
    </ol>
    `
    );
}

// DOCUMENT.READY FUNCTION
$(function() {
  display_users();
});
