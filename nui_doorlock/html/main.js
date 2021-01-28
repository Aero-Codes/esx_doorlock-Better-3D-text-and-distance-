$('document').ready(function() {

    window.addEventListener("message", function (event) {
        if (event.data.action == "display") {
            event.x = (event.data.x * 100) + '%';
            event.y = (event.data.y * 100) + '%';

            if (event.data.text == "Locked") {
                event.data.text = '<i style="color:orange" class="fas fa-lock"></i>'
            } else if (event.data.text == "Unlocked") {
                event.data.text = '<i style="color:limegreen" class="fas fa-unlock"></i>'
            } else {
                event.data.text = '<i style="color:orange" class="fas fa-lock"></i>'
            }

            $('.doorlock').html(event.data.text);
            $('.doorlock').css({ "opacity": "1", "left": event.x, "top": event.y });
            $('.container').css({ "opacity": "1" });

        } else {
            $('.doorlock').css({ "opacity": "0" });
            $('.doorlock').html('');
            $('.container').css({ "opacity": "0" });
        }
    })
});