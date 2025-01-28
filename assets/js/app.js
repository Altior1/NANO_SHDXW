// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")


// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())


// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// Import FullCalendar JavaScript
import { Calendar } from '@fullcalendar/core';
import timeGridPlugin from '@fullcalendar/timegrid';

let Hooks = {};

Hooks.CalendarHook = {
  mounted() {
    const calendarEl = this.el;
    console.log(this.el)

    if (calendarEl) {
      const calendar = new Calendar(calendarEl, {
        plugins: [timeGridPlugin],
        initialView: 'timeGridWeek',
        slotDuration: '00:15:00',
        slotLabelFormat: {
          hour: 'numeric',
          minute: '2-digit',
          hour12: false
        },
        expandRows: true,


        events: async function (fetchInfo, successCallback, failureCallback) {
          try {
            const response = await fetch(
              `/reservations_calendar/events?start_date=${fetchInfo.startStr}`
            );

            if (!response.ok) {
              throw new Error('Erreur lors de la récupération des événements');
            }

            const data = await response.json();

            const events = data.map(event => ({
              title: event.user_email,
              start: event.start,
              end: event.end,
            }));
            console.log(events);

            successCallback(events);
          } catch (error) {
            console.error('Erreur dans FullCalendar :', error);
            failureCallback(error);
          }
        },
      });

      calendar.render();

      document.getElementById('zoom_day').addEventListener('click', () => {
        calendar.changeView('timeGridDay'); // Zoom avant
      });

      document.getElementById('zoom_week').addEventListener('click', () => {
        calendar.changeView('timeGridWeek'); // Zoom arrière
      });
    }
  },
};
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: Hooks
})

// connect if there are any LiveViews on the page
liveSocket.connect()