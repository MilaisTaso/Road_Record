const { environment } = require('@rails/webpacker')

//追加したパッケージの設定
const webpack = require('webpack')
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    Popper: 'popper.js',
    Swiper: 'swiper/swiper-bundle'
  })
)

module.exports = environment
