//googlemaps/js-api-loaderにてAPI読込
import { Loader } from "@googlemaps/js-api-loader";

const loader = new Loader({
  apiKey: process.env.GOOGLE_API_KEY,
  version: "weekly",
  libraries: ["geometry"]
});

// グローバル変数
let map;
let geocoder;
let poly;
let path
let geoInput;
let latLng = [];
let i = 1;
let count = true;
const addressField = document.getElementById('course_address');
const latLngField = document.getElementById("course_latlng");
const distanceField = document.getElementById("course_distance");
const distanceArea = document.createElement("p");

function initMap() {
  //マップの描画と必要なオプション
  map = new google.maps.Map(document.getElementById("map"), {
    center: { lat: 35.68123620000001, //初期センターは東京駅
              lng: 139.7671248 },
    zoom: 15,
    clickableIcons: false,
    mapTypeControl: false,
  });

  //ジオコード宣言とその他設定
  geocoder = new google.maps.Geocoder();

  // 入力フィールドの作成
  geoInput = document.createElement("input");
  geoInput.type = "text";
  geoInput.placeholder = "住所から位置を取得";
  geoInput.classList.add("map-input");

  // ボタンの作成
  const geoBtn = document.createElement("input");
  geoBtn.type = "button";
  geoBtn.value = "検索";
  geoBtn.classList.add("map-btn", "button-primary");

  //消去ボタンの作成
  const polyClearBtn = document.createElement("input");
  polyClearBtn.type = "button";
  polyClearBtn.value = "消去";
  polyClearBtn.classList.add("map-btn","button-secondary" );

  //ポリライン消去ボタンの作成
  const polyBackBtn = document.createElement('input');
  polyBackBtn.type = "button";
  polyBackBtn.value = "一つ戻る";
  polyBackBtn.classList.add("map-btn", "button-indigo");

  distanceArea.textContent = "距離: 0 km";
  distanceArea.classList.add("distance-area");

  //戻るボタンの作成

  // 作成したタグをマップ内へ埋め込む
  map.controls[google.maps.ControlPosition.TOP_LEFT].push(geoInput);
  map.controls[google.maps.ControlPosition.TOP_LEFT].push(geoBtn);
  map.controls[google.maps.ControlPosition.TOP_LEFT].push(polyClearBtn);
  map.controls[google.maps.ControlPosition.TOP_LEFT].push(polyBackBtn);
  map.controls[google.maps.ControlPosition.TOP_LEFT].push(distanceArea);


  //ポリラインの描画設定

  const lineSymbol = {
    path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW,
  };

  poly = new google.maps.Polyline({
    strokeColor: "#00cc33",
    strokerOpacity: 0.8,
    strokeWeight: 4,
    icons: [{
      icon: lineSymbol,
      offset: "100%"
    },],
  });

  //クリックイベント
  map.addListener("click", addLatLng);

  map.addListener("click", (e) => {
    if (count) {
      geocode({ location: e.latLng });
      count = false;
    }
  });

  geoBtn.addEventListener("click", () =>
  geocode({ address: geoInput.value })
  );

  polyClearBtn.addEventListener("click", () => {
    polyClear();
  });

  polyBackBtn.addEventListener("click", () => {
    if (path.length >= 1) {
      path.pop();
      let arrayLatLng = latLng.split('|');
      arrayLatLng.pop();
      latLng = arrayLatLng.join('|');
      latLngField.value = latLng;
      addLatLng;
    }
    if (path.length === 0) {
      addressField.value = "";
      i = 1;
      console.log("test");
      count = true;
    }
  });

  function addLatLng(event) {
    poly.setMap(map);
    path = poly.getPath();
    path.push(event.latLng);

    addDistance(path);

    let latP = event.latLng.lat();
    let lngP = event.latLng.lng();
    if (i == 1) {
      latLng = lngP + "," + latP;
    } else {
      latLng = latLng + "|" + lngP + "," + latP;
    }
    //経度緯度の値はhidden_fieldへ渡す
    latLngField.value = latLng;
    i++;
  }
}

function polyClear() {
  poly.setMap(null);
  poly.setPath([]);
  i = 1;
  latLngField.value = '';
  addressField.value = '';
  count = true;
  distanceArea.textContent = "距離: 0 km";
}

function addDistance(path){
  if(path.getLength() === 1) return ;
  const rad = 6371.0710; //球面三角法にて計算
  let latP = [];
  let lngP = [];
  let totalDistance = 0;
  path.forEach(p => {
    latP.push(p.lat());
    lngP.push(p.lng());

    if (latP.length === 2) {
      let radLat1 = latP[0] * (Math.PI / 180);
      let radLat2 = latP[1] * (Math.PI / 180);
      let diffLat = radLat2 - radLat1;
      let diffLng = (lngP[1] - lngP[0]) * (Math.PI / 180);

      let distance = 2 * rad
      * Math.asin(Math.sqrt(Math.sin(diffLat / 2) * Math.sin(diffLat / 2)
      + Math.cos(radLat1)*Math.cos(radLat2)
      * Math.sin(diffLng / 2) * Math.sin(diffLng / 2)));
      totalDistance = totalDistance + distance;
      lngP.shift();
      latP.shift();
    }
  });

  distanceField.value = totalDistance;
  distanceArea.textContent = `距離: ${totalDistance.toFixed(2)} km`
}

function geocode(request) {
  geoInput.value = '';
  geocoder
  .geocode(request)
  .then((result) => {
    const { results } = result;
    if (request.address) {
      map.setCenter(results[0].geometry.location);
      map.setZoom(15);
      count = true;
    }
    getFormatAddress(results[0].address_components);
    return results;
  })
  .catch((e) => {
    alert("以下の理由により正常に動作しませんでした。: " + e);
  });
}

function getFormatAddress(results) {
  let formatAddress = [];
  results.forEach(result  => {
    let addressName = result.long_name;
    let addressType = result.types;
    if (addressType.includes("sublocality_level_2")) {
      formatAddress.push(addressName);
    } else if (addressType.includes("locality")) {
      formatAddress.push(addressName);
    } else if (addressType.includes("administrative_area_level_1")) {
      formatAddress.push(addressName);
    }
  });
  addressField.value = formatAddress;
}

//API通信成功事、描画を実施。実際の描画はこの処理の中で行う
loader
  .load()
  .then((google) => {
    initMap();
  })
  .catch(err => {
    console.log(err);
  });
