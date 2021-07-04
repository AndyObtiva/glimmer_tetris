$LOAD_PATH.unshift(File.expand_path('..', __FILE__))

require 'bundler/setup'
Bundler.require(:default)
require 'glimmer_tetris/view/app_view'

class GlimmerTetris
  APP_ROOT = File.expand_path('../..', __FILE__)
  VERSION = File.read(File.join(APP_ROOT, 'VERSION'))
  LICENSE = File.read(File.join(APP_ROOT, 'LICENSE.txt'))
  BLOCK_SIZE = 25
  FONT_NAME = 'Menlo'
  FONT_TITLE_HEIGHT = 32
  FONT_TITLE_STYLE = :bold
  BEVEL_CONSTANT = 20
end