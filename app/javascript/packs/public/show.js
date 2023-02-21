import { Loader } from "@googlemaps/js-api-loader";

const loader = new Loader({
  apiKey: process.env.GOOGLE_API_KEY,
  version: "weekly",
  //その他オプションの指定(ライブラリ等)
});

let latLangArray = [];
let positions = JSON.parse(document.getElementById('position_info').dataset.json);

positions.map(position => {
  let latLang = {
    lat: Number(position.lat),
    lng: Number(position.lng)
  }
  latLangArray.push(latLang);
});

const initMap = () => {
  const mapOptions = {
    center: {
      lat: parseFloat(positions[0].lat),
      lng: parseFloat(positions[0].lng),
    },
    zoom: 15
  };

  const map = new google.maps.Map(document.getElementById("map"), mapOptions);
  
  const lineSymbol = {
    path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW,
  };
  const flightPath = new google.maps.Polyline({
    path: latLangArray,
    geodesic: true,
    strokeColor: "#00cc33",
    strokeOpacity: 0.8,
    strokeWeight: 4,
    icons: [{
      icon: lineSymbol,
      offset: "100%"
    },],
  });
  flightPath.setMap(map);
}

loader
  .load()
  .then((google) => {
    initMap();
  })
  .catch(err => {
    console.log(err);
  });
  