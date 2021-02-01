$('document').ready(function() {
    $('.container').hide()

    window.addEventListener("message", function (event) {

        if (event.data.action =="playAudioLocked") {
            var sound = document.querySelector('#sounds');
            sound.setAttribute('src', 'sounds/door-bolt-4.ogg');
            sound.volume = 0.08;
			sound.play();
        } else if (event.data.action =="playAudioUnlocked") {
            var sound = document.querySelector('#sounds');
            sound.setAttribute('src', 'sounds/door-bolt-4.ogg');
            sound.volume = 0.08;
			sound.play();
        }
        else
        {
            if (event.data.text == "Locked") {
                event.data.text = '<i style="color:orange" class="fas fa-lock"></i>'
            } else if (event.data.text == "Unlocked") {
                event.data.text = '<i style="color:limegreen" class="fas fa-unlock"></i>'
            } else if (event.data.text == "Locking") {
                event.data.text = '<i style="color:orange" class="fas fa-lock"><br>Locking</i>'
            }


            event.x = (event.data.x * 100) + '%';
            event.y = (event.data.y * 100) + '%';
            if (event.data.text == undefined) {event.data.action = "hide"}
            $('.doorlock').html(event.data.text);
            $('.doorlock').css({ "left": event.x, "top": event.y });


            if (event.data.action == "display") {
                $('.doorlock').show()
                $('.container').show()
            } else if (event.data.action == "hide") {
                $('.doorlock').html('');
                $('.doorlock').hide()
                $('.container').hide()
            }
        }
    })
});
