# Copyright (c) 2021 Andy Maleh
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require_relative 'playfield'

class GlimmerTetris
  module View
    class ScoreLane
      include Glimmer::UI::CustomWidget
  
      options :game
      
      body {
        composite {
          row_layout {
            type :vertical
            center true
            fill true
            margin_width 0
            margin_right BLOCK_SIZE
            margin_height BLOCK_SIZE
          }
          label(:center) {
            text 'Next'
            font name: FONT_NAME, height: FONT_TITLE_HEIGHT, style: FONT_TITLE_STYLE
          }
          playfield(game_playfield: game.preview_playfield, playfield_width: Model::Game::PREVIEW_PLAYFIELD_WIDTH, playfield_height: Model::Game::PREVIEW_PLAYFIELD_HEIGHT)

          label(:center) {
            text 'Score'
            font name: FONT_NAME, height: FONT_TITLE_HEIGHT, style: FONT_TITLE_STYLE
          }
          label(:center) {
            text bind(game, :score)
            font height: FONT_TITLE_HEIGHT
          }
          
          label # spacer
          
          label(:center) {
            text 'Lines'
            font name: FONT_NAME, height: FONT_TITLE_HEIGHT, style: FONT_TITLE_STYLE
          }
          label(:center) {
            text bind(game, :lines)
            font height: FONT_TITLE_HEIGHT
          }
          
          label # spacer
          
          label(:center) {
            text 'Level'
            font name: FONT_NAME, height: FONT_TITLE_HEIGHT, style: FONT_TITLE_STYLE
          }
          label(:center) {
            text bind(game, :level)
            font height: FONT_TITLE_HEIGHT
          }
        }
      }
    end
  end
end
